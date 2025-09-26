import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import 'topics_page.dart';
import 'dart:math' as math;

class SubjectsSelectionPage extends StatefulWidget {
  const SubjectsSelectionPage({super.key});

  @override
  _SubjectsSelectionPageState createState() => _SubjectsSelectionPageState();
}

class _SubjectsSelectionPageState extends State<SubjectsSelectionPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late List<AnimationController> _cardControllers;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  // Super funky subject data with vibrant colors and cool emojis
  final List<Map<String, dynamic>> _subjects = [
    {
      'key': 'mathematics',
      'name': 'Math Magic 🔥',
      'funkyName': 'Numbers & Wizardry',
      'color': Color(0xFF00D4AA),
      'gradientColors': [Color(0xFF00D4AA), Color(0xFF00B4D8)],
      'emoji': '🧮',
      'bigEmoji': '🔢',
      'description': 'Crack the code of numbers!',
      'topics': ['algebra', 'geometry', 'arithmetic', 'calculus', 'probability', 'statistics'],
      'difficulty': 'Medium',
      'stars': 4.8,
    },
    {
      'key': 'science',
      'name': 'Science Squad 🚀',
      'funkyName': 'Lab Experiments',
      'color': Color(0xFFFF6B6B),
      'gradientColors': [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
      'emoji': '🔬',
      'bigEmoji': '⚗️',
      'description': 'Discover the universe!',
      'topics': ['physics', 'chemistry', 'biology'],
      'difficulty': 'Hard',
      'stars': 4.9,
    },
    {
      'key': 'english',
      'name': 'Word Warriors 📖',
      'funkyName': 'Language Masters',
      'color': Color(0xFF4ECDC4),
      'gradientColors': [Color(0xFF4ECDC4), Color(0xFF96CEB4)],
      'emoji': '📚',
      'bigEmoji': '📝',
      'description': 'Master the art of words!',
      'topics': ['grammar', 'vocabulary', 'reading', 'writing'],
      'difficulty': 'Easy',
      'stars': 4.7,
    },
    {
      'key': 'history',
      'name': 'Time Machine 🕰️',
      'funkyName': 'Past Adventures',
      'color': Color(0xFFFFBE0B),
      'gradientColors': [Color(0xFFFFBE0B), Color(0xFFFB8500)],
      'emoji': '🏛️',
      'bigEmoji': '⚔️',
      'description': 'Travel through time!',
      'topics': ['ancient', 'medieval', 'modern', 'worldHistory'],
      'difficulty': 'Medium',
      'stars': 4.6,
    },
    {
      'key': 'geography',
      'name': 'Earth Explorer 🗺️',
      'funkyName': 'World Discovery',
      'color': Color(0xFF8338EC),
      'gradientColors': [Color(0xFF8338EC), Color(0xFFA663CC)],
      'emoji': '🌍',
      'bigEmoji': '🗾',
      'description': 'Explore our amazing planet!',
      'topics': ['physical', 'political', 'economic', 'environmental'],
      'difficulty': 'Easy',
      'stars': 4.5,
    },
    {
      'key': 'computerScience',
      'name': 'Code Ninjas 💻',
      'funkyName': 'Tech Wizards',
      'color': Color(0xFF3F37C9),
      'gradientColors': [Color(0xFF3F37C9), Color(0xFF7209B7)],
      'emoji': '💻',
      'bigEmoji': '🤖',
      'description': 'Build the future with code!',
      'topics': ['programming', 'algorithms', 'dataStructures', 'databases'],
      'difficulty': 'Hard',
      'stars': 4.9,
    },
    {
      'key': 'physics',
      'name': 'Physics Force ⚡',
      'funkyName': 'Universe Mechanics',
      'color': Color(0xFFE63946),
      'gradientColors': [Color(0xFFE63946), Color(0xFFF77F00)],
      'emoji': '⚛️',
      'bigEmoji': '⚡',
      'description': 'Unlock the secrets of motion!',
      'topics': ['mechanics', 'thermodynamics', 'electromagnetism', 'optics'],
      'difficulty': 'Hard',
      'stars': 4.8,
    },
    {
      'key': 'chemistry',
      'name': 'Chem Lab 🧪',
      'funkyName': 'Molecule Makers',
      'color': Color(0xFF06FFA5),
      'gradientColors': [Color(0xFF06FFA5), Color(0xFF00B4D8)],
      'emoji': '🧪',
      'bigEmoji': '💥',
      'description': 'Mix, react, and discover!',
      'topics': ['organic', 'inorganic', 'physical', 'analytical'],
      'difficulty': 'Hard',
      'stars': 4.7,
    },
    {
      'key': 'biology',
      'name': 'Life Science 🦠',
      'funkyName': 'Living World',
      'color': Color(0xFF2D6A4F),
      'gradientColors': [Color(0xFF2D6A4F), Color(0xFF52B788)],
      'emoji': '🌱',
      'bigEmoji': '🧬',
      'description': 'Discover the magic of life!',
      'topics': ['botany', 'zoology', 'genetics', 'ecology'],
      'difficulty': 'Medium',
      'stars': 4.6,
    },
    {
      'key': 'hindi',
      'name': 'Hindi Heroes 🇮🇳',
      'funkyName': 'भाषा मास्टर',
      'color': Color(0xFFFF9500),
      'gradientColors': [Color(0xFFFF9500), Color(0xFFFF6D00)],
      'emoji': '🔤',
      'bigEmoji': '📜',
      'description': 'Master the beautiful Hindi!',
      'topics': ['grammar', 'literature', 'poetry', 'essays'],
      'difficulty': 'Easy',
      'stars': 4.5,
    },
    {
      'key': 'socialStudies',
      'name': 'Society Squad 👥',
      'funkyName': 'Social Warriors',
      'color': Color(0xFF7209B7),
      'gradientColors': [Color(0xFF7209B7), Color(0xFFA663CC)],
      'emoji': '👥',
      'bigEmoji': '🏛️',
      'description': 'Understand our world together!',
      'topics': ['civics', 'economics', 'sociology', 'psychology'],
      'difficulty': 'Medium',
      'stars': 4.4,
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Create individual controllers for each card
    _cardControllers = List.generate(_subjects.length, (index) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)),
        vsync: this,
      );
      // Stagger the animations
      Future.delayed(Duration(milliseconds: 200 + (index * 150)), () {
        if (mounted) controller.forward();
      });
      return controller;
    });
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _slideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );
    
    _floatingAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      // Super Funky Header
                      SliverToBoxAdapter(
                        child: _buildFunkyHeader(l10n, languageProvider),
                      ),
                      
                      // Funky Subjects Grid
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.85,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= _subjects.length) return null;
                              return _buildFunkySubjectCard(context, index, l10n);
                            },
                            childCount: _subjects.length,
                          ),
                        ),
                      ),
                      
                      // Bottom fun section
                      SliverToBoxAdapter(
                        child: _buildBottomFunSection(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFunkyHeader(AppLocalizations l10n, LanguageProvider languageProvider) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Top row with back and language
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              _buildFunkyLanguageSelector(languageProvider),
            ],
          ),
          
          SizedBox(height: 30),
          
          // Super funky floating logo
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  math.sin(_floatingController.value * 2 * math.pi) * 8, 
                  _floatingAnimation.value
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFF6B6B),
                        Color(0xFF4ECDC4),
                        Color(0xFF45B7D1),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF6B6B).withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Center(
                          child: Text(
                            '🎓',
                            style: TextStyle(fontSize: 60),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          
          SizedBox(height: 30),
          
          // Super exciting title
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4), Color(0xFFFFE066)],
            ).createShader(bounds),
            child: Text(
              '🚀 CHOOSE YOUR ADVENTURE! 🚀',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(height: 15),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B6B).withValues(alpha: 0.2), Color(0xFF4ECDC4).withValues(alpha: 0.2)],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Pick your favorite subjects and start learning! 🎯',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFunkyLanguageSelector(LanguageProvider languageProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF6B6B).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        icon: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🌍', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                languageProvider.currentLanguageDisplayName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
        onSelected: (String languageCode) {
          languageProvider.changeLanguage(languageCode);
          HapticFeedback.mediumImpact();
        },
        itemBuilder: (BuildContext context) {
          return languageProvider.availableLanguages.map((language) {
            return PopupMenuItem<String>(
              value: language['code'],
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Text(
                      languageProvider.currentLocale.languageCode == language['code'] 
                        ? '🎆' : '🌍',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 12),
                    Text(
                      language['nativeName']!,
                      style: TextStyle(
                        fontWeight: languageProvider.currentLocale.languageCode == language['code'] 
                          ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildFunkySubjectCard(BuildContext context, int index, AppLocalizations l10n) {
    final subject = _subjects[index];
    
    return AnimatedBuilder(
      animation: _cardControllers[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _cardControllers[index].value,
          child: Transform.rotate(
            angle: (1 - _cardControllers[index].value) * 0.1,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                _cardControllers[index].reverse().then((_) {
                  _cardControllers[index].forward();
                });
                
                Future.delayed(Duration(milliseconds: 200), () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => 
                          TopicsPage(
                            subject: {
                              'name': subject['name'],
                              'key': subject['key'],
                              'color': subject['color'],
                              'emoji': subject['emoji'],
                              'topics': subject['topics'],
                            },
                          ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.elasticOut,
                          )),
                          child: child,
                        );
                      },
                    ),
                  );
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: subject['gradientColors'],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: subject['color'].withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    
                    // Main content
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Difficulty badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              subject['difficulty'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          Spacer(),
                          
                          // Big emoji
                          Center(
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1 + (math.sin(_pulseController.value * 2 * math.pi) * 0.1),
                                  child: Text(
                                    subject['bigEmoji'],
                                    style: TextStyle(fontSize: 45),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          SizedBox(height: 12),
                          
                          // Subject name
                          Text(
                            subject['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          SizedBox(height: 4),
                          
                          // Funky name
                          Text(
                            subject['funkyName'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          SizedBox(height: 8),
                          
                          // Bottom row with stars and topics
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Stars
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow, size: 14),
                                  SizedBox(width: 2),
                                  Text(
                                    subject['stars'].toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // Topics count
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${subject['topics'].length} topics',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
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
          ),
        );
      },
    );
  }

  Widget _buildBottomFunSection() {
    return Container(
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF6B6B).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '🎆 Ready to become a learning champion? 🎆',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Tap any subject above to start your exciting journey!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
