import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../theme_provider.dart';
import 'games_page.dart';

class TopicsPage extends StatefulWidget {
  final Map<String, dynamic> subject;
  
  const TopicsPage({super.key, required this.subject});

  @override
  _TopicsPageState createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;

  // Topic data with games for each topic
  final Map<String, Map<String, dynamic>> _topicGames = {
    // Mathematics topics
    'algebra': {
      'emoji': '🔢',
      'color': Color(0xFF4CAF50),
      'games': ['Linear Equations', 'Quadratic Solver', 'Factor Master', 'Variable Hunt']
    },
    'geometry': {
      'emoji': '📐',
      'color': Color(0xFF2196F3),
      'games': ['Shape Builder', 'Angle Hunter', 'Area Calculator', 'Perimeter Pro']
    },
    'arithmetic': {
      'emoji': '➕',
      'color': Color(0xFFFF9800),
      'games': ['Speed Math', 'Mental Calculator', 'Number Bonds', 'Fraction Fun']
    },
    'calculus': {
      'emoji': '📊',
      'color': Color(0xFF9C27B0),
      'games': ['Derivative Detective', 'Integral Master', 'Limit Finder', 'Graph Explorer']
    },
    'probability': {
      'emoji': '🎲',
      'color': Color(0xFFE91E63),
      'games': ['Dice Simulator', 'Card Probability', 'Random Events', 'Statistics Quiz']
    },
    'statistics': {
      'emoji': '📈',
      'color': Color(0xFF607D8B),
      'games': ['Data Analyzer', 'Mean Median Mode', 'Chart Builder', 'Survey Master']
    },
    
    // Science topics
    'physics': {
      'emoji': '⚛️',
      'color': Color(0xFF3F51B5),
      'games': ['Force Calculator', 'Motion Simulator', 'Energy Lab', 'Wave Explorer']
    },
    'chemistry': {
      'emoji': '🧪',
      'color': Color(0xFFE91E63),
      'games': ['Element Match', 'Reaction Predictor', 'Molecule Builder', 'pH Tester']
    },
    'biology': {
      'emoji': '🌱',
      'color': Color(0xFF4CAF50),
      'games': ['Cell Explorer', 'DNA Decoder', 'Ecosystem Builder', 'Body Systems']
    },
    
    // English topics
    'grammar': {
      'emoji': '📝',
      'color': Color(0xFF9C27B0),
      'games': ['Grammar Check', 'Sentence Builder', 'Parts of Speech', 'Tense Master']
    },
    'vocabulary': {
      'emoji': '📚',
      'color': Color(0xFF2196F3),
      'games': ['Word Builder', 'Synonym Match', 'Antonym Quest', 'Vocabulary Quiz']
    },
    'reading': {
      'emoji': '👁️',
      'color': Color(0xFF4CAF50),
      'games': ['Speed Reader', 'Comprehension Quiz', 'Story Builder', 'Reading Race']
    },
    'writing': {
      'emoji': '✍️',
      'color': Color(0xFFFF9800),
      'games': ['Essay Helper', 'Creative Writing', 'Letter Builder', 'Story Creator']
    },
    
    // History topics
    'ancient': {
      'emoji': '🏛️',
      'color': Color(0xFF795548),
      'games': ['Timeline Builder', 'Civilization Quiz', 'Ancient Explorer', 'Monument Match']
    },
    'medieval': {
      'emoji': '⚔️',
      'color': Color(0xFF607D8B),
      'games': ['Knight Quest', 'Castle Builder', 'Medieval Life', 'Battle Simulator']
    },
    'modern': {
      'emoji': '🏭',
      'color': Color(0xFF9C27B0),
      'games': ['Industrial Revolution', 'World Wars', 'Modern Leaders', 'Technology Timeline']
    },
    'worldHistory': {
      'emoji': '🌍',
      'color': Color(0xFF2196F3),
      'games': ['Global Explorer', 'Cultural Quiz', 'World Events', 'Historical Figures']
    },
    
    // Geography topics
    'physical': {
      'emoji': '🏔️',
      'color': Color(0xFF4CAF50),
      'games': ['Mountain Builder', 'River Flow', 'Weather Predictor', 'Landform Quiz']
    },
    'political': {
      'emoji': '🗺️',
      'color': Color(0xFF2196F3),
      'games': ['Country Quiz', 'Capital Cities', 'Flag Match', 'Border Game']
    },
    'economic': {
      'emoji': '💰',
      'color': Color(0xFFFF9800),
      'games': ['Trade Simulator', 'Resource Manager', 'Market Game', 'Economy Quiz']
    },
    'environmental': {
      'emoji': '🌿',
      'color': Color(0xFF4CAF50),
      'games': ['Eco Protector', 'Climate Quiz', 'Pollution Fighter', 'Green Energy']
    },
    
    // Default fallback
    'default': {
      'emoji': '🎮',
      'color': Color(0xFF607D8B),
      'games': ['Quiz Game', 'Memory Match', 'Word Search', 'Brain Teaser']
    }
  };

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  String _getLocalizedTopicName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'algebra': return l10n.algebra;
      case 'geometry': return l10n.geometry;
      case 'arithmetic': return l10n.arithmetic;
      case 'calculus': return l10n.calculus;
      case 'probability': return l10n.probability;
      case 'statistics': return l10n.statistics;
      default: return key.replaceAll('_', ' ').split(' ')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.white : Color(0xFF062863);
    final secondaryColor = isDarkMode ? Color(0xFF62D9FF) : Color(0xFF238FFF);
    final backgroundColor = isDarkMode ? Color(0xFF062863) : Color(0xFFD0F4FF);
    final cardColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;

    final subjectTopics = widget.subject['topics'] as List<String>;

    return Scaffold(
      backgroundColor: backgroundColor,
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
                      child: _buildHeader(l10n, primaryColor, secondaryColor, languageProvider),
                    ),
                    
                    // Topics Grid
                    SliverToBoxAdapter(
                      child: _buildTopicsGrid(l10n, subjectTopics, cardColor, primaryColor, secondaryColor),
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
    );
  }

  Widget _buildHeader(AppLocalizations l10n, Color primaryColor, Color secondaryColor, LanguageProvider languageProvider) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: primaryColor, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              _buildLanguageSelector(languageProvider, primaryColor, secondaryColor),
            ],
          ),
          SizedBox(height: 20),
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: widget.subject['color'].withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.subject['color'].withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.subject['emoji'],
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 30),
          Text(
            widget.subject['name'],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            l10n.selectTopic,
            style: TextStyle(
              fontSize: 18,
              color: secondaryColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(LanguageProvider languageProvider, Color primaryColor, Color secondaryColor) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: secondaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: secondaryColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: secondaryColor, size: 20),
            SizedBox(width: 4),
            Text(
              languageProvider.currentLanguageDisplayName,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      onSelected: (String languageCode) {
        languageProvider.changeLanguage(languageCode);
      },
      itemBuilder: (BuildContext context) {
        return languageProvider.availableLanguages.map((language) {
          return PopupMenuItem<String>(
            value: language['code'],
            child: Row(
              children: [
                Icon(
                  languageProvider.currentLocale.languageCode == language['code'] 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
                  color: secondaryColor,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(language['nativeName']!),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildTopicsGrid(AppLocalizations l10n, List<String> topics, Color cardColor, Color primaryColor, Color secondaryColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topicKey = topics[index];
          final topicData = _topicGames[topicKey] ?? _topicGames['default']!;
          final topicName = _getLocalizedTopicName(l10n, topicKey);
          
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => 
                      GamesPage(
                        topic: {
                          'name': topicName,
                          'key': topicKey,
                          'emoji': topicData['emoji'],
                          'color': topicData['color'],
                          'games': topicData['games'],
                        },
                        subject: widget.subject,
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
            child: Container(
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
                border: Border.all(
                  color: topicData['color'].withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: topicData['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        topicData['emoji'],
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    topicName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${topicData['games'].length} ${l10n.games.toLowerCase()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: topicData['color'],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}