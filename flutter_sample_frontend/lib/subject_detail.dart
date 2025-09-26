import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'games_list.dart';
import 'theme_provider.dart';
import 'package:provider/provider.dart';

class SubjectDetailPage extends StatefulWidget {
  final Map<String, dynamic> subject;

  const SubjectDetailPage({super.key, required this.subject});

  @override
  _SubjectDetailPageState createState() => _SubjectDetailPageState();
}

class _SubjectDetailPageState extends State<SubjectDetailPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late TabController _tabController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;
  
  // Sample data for topics - replace with actual API calls
  final List<Map<String, dynamic>> _topics = [
    {'name': 'Algebra', 'games': 8, 'materials': 12, 'difficulty': 'Medium', 'icon': Icons.calculate},
    {'name': 'Geometry', 'games': 6, 'materials': 10, 'difficulty': 'Easy', 'icon': Icons.architecture},
    {'name': 'Trigonometry', 'games': 4, 'materials': 8, 'difficulty': 'Hard', 'icon': Icons.timeline},
    {'name': 'Statistics', 'games': 5, 'materials': 15, 'difficulty': 'Medium', 'icon': Icons.bar_chart},
  ];
  
  final List<Map<String, dynamic>> _materials = [
    {'title': 'Introduction to Algebra', 'type': 'Video', 'duration': '12 min', 'icon': Icons.play_circle},
    {'title': 'Practice Problems Set 1', 'type': 'PDF', 'duration': '45 min', 'icon': Icons.picture_as_pdf},
    {'title': 'Interactive Quiz', 'type': 'Quiz', 'duration': '20 min', 'icon': Icons.quiz},
    {'title': 'Formula Cheat Sheet', 'type': 'PDF', 'duration': '5 min', 'icon': Icons.description},
  ];
  
  final List<Map<String, dynamic>> _achievements = [
    {'name': 'First Steps', 'description': 'Complete your first lesson', 'progress': 1.0, 'earned': true},
    {'name': 'Problem Solver', 'description': 'Solve 10 problems correctly', 'progress': 0.7, 'earned': false},
    {'name': 'Speed Demon', 'description': 'Complete a quiz in under 5 minutes', 'progress': 0.0, 'earned': false},
    {'name': 'Perfectionist', 'description': 'Get 100% on any test', 'progress': 0.3, 'earned': false},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _tabController = TabController(length: 3, vsync: this);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _floatingAnimation = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.white : Color(0xFF062863);
    final cardColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final subjectColor = widget.subject['color'] as Color;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF062863) : Color(0xFFD0F4FF),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: CustomScrollView(
                slivers: [
                  // Custom App Bar
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: false,
                    pinned: true,
                    backgroundColor: subjectColor,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        widget.subject['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              subjectColor,
                              subjectColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 20,
                              top: 80,
                              child: AnimatedBuilder(
                                animation: _floatingAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatingAnimation.value),
                                    child: Icon(
                                      widget.subject['icon'],
                                      size: 80,
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.subject['games']} Games Available',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Progress: ',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${(widget.subject['progress'] * 100).toInt()}%',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to favorites!'),
                              backgroundColor: subjectColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  // Progress Card
                  SliverToBoxAdapter(
                    child: _buildProgressCard(cardColor, primaryColor, subjectColor),
                  ),
                  
                  // Tabs
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: subjectColor,
                        unselectedLabelColor: primaryColor.withOpacity(0.6),
                        indicatorColor: subjectColor,
                        tabs: [
                          Tab(text: 'Topics'),
                          Tab(text: 'Materials'),
                          Tab(text: 'Achievements'),
                        ],
                      ),
                    ),
                  ),
                  
                  // Tab Content
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 600,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTopicsTab(cardColor, primaryColor, subjectColor),
                          _buildMaterialsTab(cardColor, primaryColor, subjectColor),
                          _buildAchievementsTab(cardColor, primaryColor, subjectColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _floatingAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatingAnimation.value),
            child: FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => 
                        GamesListPage(subject: widget.subject),
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
              backgroundColor: subjectColor,
              foregroundColor: Colors.white,
              icon: Icon(Icons.games),
              label: Text(
                'Play Games',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildProgressCard(Color cardColor, Color primaryColor, Color subjectColor) {
    return Container(
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: widget.subject['progress'],
                  backgroundColor: subjectColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
                ),
                SizedBox(height: 8),
                Text(
                  '${(widget.subject['progress'] * 100).toInt()}% Complete',
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          CircularProgressIndicator(
            value: widget.subject['progress'],
            backgroundColor: subjectColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
            strokeWidth: 6,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopicsTab(Color cardColor, Color primaryColor, Color subjectColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Card(
              color: cardColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => 
                          GamesListPage(
                            subject: widget.subject,
                            topic: topic['name'],
                          ),
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
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: subjectColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          topic['icon'],
                          color: subjectColor,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${topic['games']} games • ${topic['materials']} materials',
                              style: TextStyle(
                                color: primaryColor.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(topic['difficulty']).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              topic['difficulty'],
                              style: TextStyle(
                                color: _getDifficultyColor(topic['difficulty']),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor.withOpacity(0.5),
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildMaterialsTab(Color cardColor, Color primaryColor, Color subjectColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        itemCount: _materials.length,
        itemBuilder: (context, index) {
          final material = _materials[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Card(
              color: cardColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: Open material
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${material['title']}...'),
                      backgroundColor: subjectColor,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getMaterialTypeColor(material['type']).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          material['icon'],
                          color: _getMaterialTypeColor(material['type']),
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              material['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  material['type'],
                                  style: TextStyle(
                                    color: _getMaterialTypeColor(material['type']),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' • ${material['duration']}',
                                  style: TextStyle(
                                    color: primaryColor.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.download,
                        color: primaryColor.withOpacity(0.5),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildAchievementsTab(Color cardColor, Color primaryColor, Color subjectColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        itemCount: _achievements.length,
        itemBuilder: (context, index) {
          final achievement = _achievements[index];
          final isEarned = achievement['earned'] as bool;
          
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Card(
              color: cardColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isEarned 
                            ? Colors.orange.withOpacity(0.2) 
                            : primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isEarned ? Icons.emoji_events : Icons.lock,
                        color: isEarned ? Colors.orange : primaryColor.withOpacity(0.5),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isEarned ? primaryColor : primaryColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            achievement['description'],
                            style: TextStyle(
                              color: primaryColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          if (!isEarned) ...[
                            SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: achievement['progress'],
                              backgroundColor: primaryColor.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${(achievement['progress'] * 100).toInt()}% Complete',
                              style: TextStyle(
                                color: subjectColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isEarned)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Earned',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  Color _getMaterialTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Colors.red;
      case 'pdf':
        return Colors.blue;
      case 'quiz':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}