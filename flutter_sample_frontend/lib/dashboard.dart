import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'subject_detail.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'theme_provider.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;
  
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _userSubjects = [];
  
  // Sample leaderboard data - anonymized for privacy
  List<Map<String, dynamic>> _leaderboard = [];
  
  final List<Map<String, dynamic>> _sampleLeaderboard = [
    {'name': 'StudyStar ⭐', 'score': 2850, 'avatar': '⭐', 'position': 1},
    {'name': 'MathGuru 🧮', 'score': 2720, 'avatar': '🧮', 'position': 2},
    {'name': 'QuizMaster 🏆', 'score': 2680, 'avatar': '🏆', 'position': 3},
    {'name': 'BrainAce 🧠', 'score': 2550, 'avatar': '🧠', 'position': 4},
    {'name': 'You', 'score': 2420, 'avatar': 'Y', 'position': 5},
  ];
  
  final List<Map<String, dynamic>> _awards = [
    {'name': 'Math Wizard', 'icon': Icons.calculate, 'date': '2 days ago'},
    {'name': 'Science Explorer', 'icon': Icons.science, 'date': '1 week ago'},
    {'name': 'Speed Reader', 'icon': Icons.auto_stories, 'date': '2 weeks ago'},
    {'name': 'Problem Solver', 'icon': Icons.extension, 'date': '1 month ago'},
  ];
  
  // Subject icons and colors mapping
  final Map<String, Map<String, dynamic>> _subjectStyles = {
    'Mathematics': {'icon': Icons.calculate, 'color': Color(0xFF4CAF50)},
    'Science': {'icon': Icons.science, 'color': Color(0xFF2196F3)},
    'English': {'icon': Icons.auto_stories, 'color': Color(0xFF9C27B0)},
    'History': {'icon': Icons.history_edu, 'color': Color(0xFFFF9800)},
    'Geography': {'icon': Icons.public, 'color': Color(0xFF607D8B)},
    'Computer Science': {'icon': Icons.computer, 'color': Color(0xFFE91E63)},
    'Physics': {'icon': Icons.science, 'color': Color(0xFF3F51B5)},
    'Chemistry': {'icon': Icons.science_outlined, 'color': Color(0xFFE91E63)},
    'Biology': {'icon': Icons.local_florist, 'color': Color(0xFF4CAF50)},
    'Hindi': {'icon': Icons.language, 'color': Color(0xFFFF9800)},
    'Social Studies': {'icon': Icons.people, 'color': Color(0xFF795548)},
    'Economics': {'icon': Icons.monetization_on, 'color': Color(0xFFFFC107)},
    'Political Science': {'icon': Icons.account_balance, 'color': Color(0xFF673AB7)},
  };

  @override
  void initState() {
    super.initState();
    
    // Initialize leaderboard with sample data
    _leaderboard = List.from(_sampleLeaderboard);
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _floatingAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _loadUserData();
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserData() async {
    try {
      // Debug stored data
      await AuthService.debugStoredData();
      
      // First try to get fresh data from backend
      print('🔄 Refreshing user profile from backend...');
      final freshUserData = await ApiService.refreshUserProfile();
      
      // Fallback to local storage if backend fails
      final userData = freshUserData ?? await AuthService.getUserData();
      print('🔍 Dashboard loaded user data: $userData');
      
      // Process user's subjects
      _processUserSubjects(userData);
      
      setState(() {
        _userData = userData;
      });
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }
  
  void _processUserSubjects(Map<String, dynamic>? userData) {
    _userSubjects.clear();
    
    if (userData != null && userData['subjects'] != null) {
      final subjects = userData['subjects'] as List<dynamic>;
      print('🔍 User has ${subjects.length} subjects: $subjects');
      
      for (var subject in subjects) {
        final subjectName = subject['name'] as String;
        final style = _subjectStyles[subjectName] ?? {
          'icon': Icons.book, 
          'color': Colors.grey
        };
        
        _userSubjects.add({
          'name': subjectName,
          'icon': style['icon'],
          'color': style['color'],
          'progress': 0.5 + (subjectName.hashCode % 50) / 100.0, // Random progress for demo
          'games': 5 + (subjectName.hashCode % 15), // Random game count for demo
        });
      }
    } else {
      print('⚠️ No subjects found for user, using default subjects');
      // Fallback to a few default subjects if no user subjects found
      _userSubjects = [
        {'name': 'Mathematics', 'icon': Icons.calculate, 'color': Color(0xFF4CAF50), 'progress': 0.75, 'games': 12},
        {'name': 'Science', 'icon': Icons.science, 'color': Color(0xFF2196F3), 'progress': 0.60, 'games': 8},
        {'name': 'English', 'icon': Icons.auto_stories, 'color': Color(0xFF9C27B0), 'progress': 0.85, 'games': 15},
      ];
    }
    
    // Update leaderboard to show current user
    _updateLeaderboardWithCurrentUser(userData);
    
    print('🎯 Processed ${_userSubjects.length} subjects for display');
  }
  
  void _updateLeaderboardWithCurrentUser(Map<String, dynamic>? userData) {
    if (userData != null && userData['username'] != null) {
      // Find "You" entry and update it with user's actual initial
      for (int i = 0; i < _leaderboard.length; i++) {
        if (_leaderboard[i]['name'] == 'You') {
          _leaderboard[i]['avatar'] = userData['username'][0].toUpperCase();
          break;
        }
      }
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.white : Color(0xFF062863);
    final secondaryColor = isDarkMode ? Color(0xFF62D9FF) : Color(0xFF238FFF);
    final cardColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF062863) : Color(0xFFD0F4FF),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: CustomScrollView(
                  slivers: [
                    // Custom App Bar
                    SliverToBoxAdapter(
                      child: _buildHeader(primaryColor, secondaryColor, isDarkMode),
                    ),
                    
                    // Stats Cards
                    SliverToBoxAdapter(
                      child: _buildStatsCards(cardColor, primaryColor, secondaryColor, isDarkMode),
                    ),
                    
                    // Leaderboard Section
                    SliverToBoxAdapter(
                      child: _buildLeaderboard(cardColor, primaryColor, secondaryColor),
                    ),
                    
                    // Awards Section
                    SliverToBoxAdapter(
                      child: _buildAwards(cardColor, primaryColor, secondaryColor),
                    ),
                    
                    // Subjects Section
                    SliverToBoxAdapter(
                      child: _buildSubjects(cardColor, primaryColor, secondaryColor),
                    ),
                    
                    // Bottom padding
                    SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _floatingAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatingAnimation.value),
            child: FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.lightImpact();
                // TODO: Add quick game launcher
                _showQuickGameLauncher();
              },
              backgroundColor: Color(0xFF62D9FF),
              foregroundColor: Color(0xFF062863),
              icon: Icon(Icons.rocket_launch),
              label: Text(
                'Quick Play',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildHeader(Color primaryColor, Color secondaryColor, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _userData?['username'] ?? 'Student',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.home, color: primaryColor),
                    onPressed: () => _goBackToHome(),
                    tooltip: 'Back to Home',
                  ),
                  IconButton(
                    icon: Icon(Icons.bug_report, color: primaryColor),
                    onPressed: () => _debugUserData(),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: primaryColor),
                    onPressed: () => _showNotifications(),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF62D9FF),
                    child: Text(
                      (_userData?['username'] ?? 'User')[0].toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF062863),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsCards(Color cardColor, Color primaryColor, Color secondaryColor, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Current Rank',
              value: '#5',
              subtitle: 'in class',
              icon: Icons.emoji_events,
              color: Colors.orange,
              cardColor: cardColor,
              primaryColor: primaryColor,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Total Score',
              value: '2,420',
              subtitle: 'points',
              icon: Icons.star,
              color: secondaryColor,
              cardColor: cardColor,
              primaryColor: primaryColor,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Streak',
              value: '12',
              subtitle: 'days',
              icon: Icons.local_fire_department,
              color: Colors.red,
              cardColor: cardColor,
              primaryColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color primaryColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: primaryColor.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLeaderboard(Color cardColor, Color primaryColor, Color secondaryColor) {
    return Container(
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.leaderboard, color: secondaryColor, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...List.generate(5, (index) {
            final user = _leaderboard[index];
            final isCurrentUser = user['name'] == 'You';
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrentUser 
                    ? secondaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isCurrentUser 
                    ? Border.all(color: secondaryColor.withValues(alpha: 0.3))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: user['position'] <= 3 
                          ? (user['position'] == 1 ? Colors.amber : 
                             user['position'] == 2 ? Colors.grey[400] : 
                             Colors.brown[300])
                          : secondaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user['position'].toString(),
                        style: TextStyle(
                          color: user['position'] <= 3 ? Colors.white : primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: isCurrentUser ? secondaryColor : primaryColor.withValues(alpha: 0.2),
                    child: Text(
                      user['avatar'],
                      style: TextStyle(
                        color: isCurrentUser ? Colors.white : primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      user['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    '${user['score']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildAwards(Color cardColor, Color primaryColor, Color secondaryColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.orange, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Recent Awards',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _awards.map((award) {
                return Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.all(16),
                  width: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        secondaryColor.withValues(alpha: 0.1),
                        secondaryColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: secondaryColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        award['icon'],
                        color: secondaryColor,
                        size: 28,
                      ),
                      SizedBox(height: 12),
                      Text(
                        award['name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        award['date'],
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSubjects(Color cardColor, Color primaryColor, Color secondaryColor) {
    return Container(
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: secondaryColor, size: 24),
              SizedBox(width: 12),
              Text(
                'Your Subjects',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
          ],
        ),
        SizedBox(height: 20),
        _userSubjects.isEmpty 
            ? Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 48,
                      color: primaryColor.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No subjects selected yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Update your profile to add subjects',
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              )
            : GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: _userSubjects.length,
            itemBuilder: (context, index) {
              final subject = _userSubjects[index];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => 
                          SubjectDetailPage(subject: subject),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        subject['color'].withValues(alpha: 0.1),
                        subject['color'].withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: subject['color'].withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            subject['icon'],
                            color: subject['color'],
                            size: 24,
                          ),
                          Text(
                            '${subject['games']} games',
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryColor.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        subject['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryColor.withValues(alpha: 0.6),
                            ),
                          ),
                          SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: subject['progress'],
                            backgroundColor: subject['color'].withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(subject['color']),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${(subject['progress'] * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: subject['color'],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  void _showQuickGameLauncher() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Quick Play',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildQuickGameTile('Math Quiz', Icons.calculate, Color(0xFF4CAF50)),
                  _buildQuickGameTile('Science Lab', Icons.science, Color(0xFF2196F3)),
                  _buildQuickGameTile('Word Builder', Icons.auto_stories, Color(0xFF9C27B0)),
                  _buildQuickGameTile('Memory Game', Icons.psychology, Color(0xFFFF9800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickGameTile(String title, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text('Quick 5-minute game'),
      trailing: Icon(Icons.play_arrow),
      onTap: () {
        Navigator.pop(context);
        // TODO: Launch specific game
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title launching soon!'),
            backgroundColor: color,
          ),
        );
      },
    );
  }
  
  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.notifications),
            SizedBox(width: 8),
            Text('Notifications'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.emoji_events, color: Colors.orange),
              title: Text('New Achievement!'),
              subtitle: Text('You earned the "Speed Reader" badge'),
            ),
            ListTile(
              leading: Icon(Icons.trending_up, color: Colors.green),
              title: Text('Rank Update'),
              subtitle: Text('You moved up to rank #5!'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _goBackToHome() {
    // Navigate back to welcome/home page
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/', 
      (Route<dynamic> route) => false,
    );
  }
  
  void _debugUserData() async {
    // Show debug dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.bug_report, color: Colors.red),
            SizedBox(width: 8),
            Text('Debug User Data'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current User Data:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Username: ${_userData?['username'] ?? 'NULL'}'),
              Text('Full Name: ${_userData?['full_name'] ?? 'NULL'}'),
              Text('Email: ${_userData?['email'] ?? 'NULL'}'),
              Text('ID: ${_userData?['id'] ?? 'NULL'}'),
              SizedBox(height: 8),
              Text('Subjects in profile: ${_userData?['subjects']?.length ?? 0}'),
              Text('Subjects displayed: ${_userSubjects.length}'),
              if (_userSubjects.isNotEmpty) ...
                _userSubjects.map((s) => Text('  • ${s['name']}')).take(3),
              SizedBox(height: 8),
              Text('🏆 Leaderboard Info:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('  • Using anonymous sample data'),
              Text('  • Real user names are hidden for privacy'),
              Text('  • Your position: ${_leaderboard.firstWhere((u) => u['name'] == 'You', orElse: () => {'position': 'N/A'})['position']}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  _loadUserData(); // Refresh data from backend
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Refresh from Backend'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await AuthService.clearAllData();
                  Navigator.pop(context);
                  _loadUserData(); // Reload data
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Clear All Data & Reload'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await AuthService.debugStoredData();
                },
                child: Text('Print Debug to Console'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
