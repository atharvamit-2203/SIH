import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../theme_provider.dart';

class GamesPage extends StatefulWidget {
  final Map<String, dynamic> topic;
  final Map<String, dynamic> subject;
  
  const GamesPage({super.key, required this.topic, required this.subject});

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;

  // Game difficulty and type data
  final Map<String, List<String>> _gameDifficulties = {
    'easy': ['🟢', 'Beginner'],
    'medium': ['🟡', 'Intermediate'], 
    'hard': ['🔴', 'Advanced'],
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

  void _playGame(String gameName, String difficulty) {
    HapticFeedback.mediumImpact();
    
    // Show a dialog for now - in a real app, this would launch the actual game
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.games, color: widget.topic['color']),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  gameName,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.difficulty}: $difficulty'),
              SizedBox(height: 8),
              Text('${widget.subject['name']} > ${widget.topic['name']}'),
              SizedBox(height: 16),
              Text('Game will launch here!', 
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Launching $gameName...'),
                    backgroundColor: widget.topic['color'],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.topic['color'],
              ),
              child: Text(l10n.play),
            ),
          ],
        );
      },
    );
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

    final games = widget.topic['games'] as List<String>;

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
                    
                    // Games List
                    SliverToBoxAdapter(
                      child: _buildGamesList(l10n, games, cardColor, primaryColor, secondaryColor),
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
          
          // Breadcrumb navigation
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.subject['name'],
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: primaryColor.withOpacity(0.5),
                  size: 16,
                ),
                Text(
                  widget.topic['name'],
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
                    color: widget.topic['color'].withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.topic['color'].withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.topic['emoji'],
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 30),
          Text(
            '${widget.topic['name']} ${l10n.games}',
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
            'Choose a game to play and learn!',
            style: TextStyle(
              fontSize: 16,
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
          color: secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: secondaryColor.withOpacity(0.3)),
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

  Widget _buildGamesList(AppLocalizations l10n, List<String> games, Color cardColor, Color primaryColor, Color secondaryColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: games.asMap().entries.map((entry) {
          final index = entry.key;
          final gameName = entry.value;
          
          return Container(
            margin: EdgeInsets.only(bottom: 16),
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
              border: Border.all(
                color: widget.topic['color'].withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                // Game header
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: widget.topic['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.games,
                            color: widget.topic['color'],
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gameName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Interactive learning game',
                              style: TextStyle(
                                fontSize: 14,
                                color: primaryColor.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.topic['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Game ${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.topic['color'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Difficulty buttons
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      Text(
                        '${l10n.difficulty}:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          children: _gameDifficulties.entries.map((difficultyEntry) {
                            final difficultyKey = difficultyEntry.key;
                            final difficultyData = difficultyEntry.value;
                            final emoji = difficultyData[0];
                            final label = difficultyData[1];
                            
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(
                                  onPressed: () => _playGame(gameName, label),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _getDifficultyColor(difficultyKey).withOpacity(0.1),
                                    foregroundColor: _getDifficultyColor(difficultyKey),
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: _getDifficultyColor(difficultyKey).withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        emoji,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        _getLocalizedDifficulty(l10n, difficultyKey),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
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

  String _getLocalizedDifficulty(AppLocalizations l10n, String difficulty) {
    switch (difficulty) {
      case 'easy':
        return l10n.easy;
      case 'medium':
        return l10n.medium;
      case 'hard':
        return l10n.hard;
      default:
        return difficulty;
    }
  }
}