import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_provider.dart';
import 'package:provider/provider.dart';

class GamesListPage extends StatefulWidget {
  final Map<String, dynamic> subject;
  final String? topic;

  const GamesListPage({super.key, required this.subject, this.topic});

  @override
  _GamesListPageState createState() => _GamesListPageState();
}

class _GamesListPageState extends State<GamesListPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;
  
  String _selectedDifficulty = 'All';
  String _selectedType = 'All';
  
  final List<String> _difficulties = ['All', 'Easy', 'Medium', 'Hard'];
  final List<String> _gameTypes = ['All', 'Quiz', 'Puzzle', 'Action', 'Strategy', 'Memory'];
  
  // Sample games data - replace with actual API calls
  final Map<String, List<Map<String, dynamic>>> _gamesByTopic = {
    'Algebra': [
      {
        'name': 'Equation Explorer',
        'description': 'Solve linear equations in a fun adventure game',
        'difficulty': 'Easy',
        'type': 'Puzzle',
        'duration': '15 min',
        'rating': 4.5,
        'players': 1250,
        'icon': Icons.calculate,
        'color': Color(0xFF4CAF50),
        'isNew': true,
        'isFavorite': false,
      },
      {
        'name': 'Algebra Rush',
        'description': 'Fast-paced equation solving game',
        'difficulty': 'Medium',
        'type': 'Action',
        'duration': '10 min',
        'rating': 4.2,
        'players': 890,
        'icon': Icons.speed,
        'color': Color(0xFFFF9800),
        'isNew': false,
        'isFavorite': true,
      },
      {
        'name': 'Variable Quest',
        'description': 'Adventure game with algebraic challenges',
        'difficulty': 'Hard',
        'type': 'Strategy',
        'duration': '25 min',
        'rating': 4.8,
        'players': 2100,
        'icon': Icons.explore,
        'color': Color(0xFF9C27B0),
        'isNew': false,
        'isFavorite': false,
      },
    ],
    'Geometry': [
      {
        'name': 'Shape Master',
        'description': 'Learn about shapes and their properties',
        'difficulty': 'Easy',
        'type': 'Quiz',
        'duration': '12 min',
        'rating': 4.3,
        'players': 1500,
        'icon': Icons.architecture,
        'color': Color(0xFF2196F3),
        'isNew': false,
        'isFavorite': true,
      },
      {
        'name': 'Angle Warriors',
        'description': 'Battle with angles and triangles',
        'difficulty': 'Medium',
        'type': 'Action',
        'duration': '18 min',
        'rating': 4.6,
        'players': 980,
        'icon': Icons.change_history,
        'color': Color(0xFFE91E63),
        'isNew': true,
        'isFavorite': false,
      },
    ],
    'Statistics': [
      {
        'name': 'Data Detective',
        'description': 'Solve mysteries using statistical analysis',
        'difficulty': 'Medium',
        'type': 'Strategy',
        'duration': '20 min',
        'rating': 4.4,
        'players': 1100,
        'icon': Icons.bar_chart,
        'color': Color(0xFF607D8B),
        'isNew': false,
        'isFavorite': false,
      },
      {
        'name': 'Chart Champions',
        'description': 'Create and interpret various charts',
        'difficulty': 'Easy',
        'type': 'Puzzle',
        'duration': '15 min',
        'rating': 4.1,
        'players': 750,
        'icon': Icons.pie_chart,
        'color': Color(0xFF795548),
        'isNew': true,
        'isFavorite': true,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _floatingAnimation = Tween<double>(begin: -2, end: 2).animate(
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

  List<Map<String, dynamic>> _getFilteredGames() {
    List<Map<String, dynamic>> allGames = [];
    
    if (widget.topic != null) {
      // Show games for specific topic
      allGames = _gamesByTopic[widget.topic] ?? [];
    } else {
      // Show all games for the subject
      for (var games in _gamesByTopic.values) {
        allGames.addAll(games);
      }
    }
    
    // Apply filters
    return allGames.where((game) {
      final difficultyMatch = _selectedDifficulty == 'All' || game['difficulty'] == _selectedDifficulty;
      final typeMatch = _selectedType == 'All' || game['type'] == _selectedType;
      return difficultyMatch && typeMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.white : Color(0xFF062863);
    final cardColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final subjectColor = widget.subject['color'] as Color;
    
    final filteredGames = _getFilteredGames();
    
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF062863) : Color(0xFFD0F4FF),
      appBar: AppBar(
        backgroundColor: subjectColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.topic ?? '${widget.subject['name']} Games',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.topic != null)
              Text(
                widget.subject['name'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterBottomSheet(),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Column(
                children: [
                  // Filter chips
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: [
                        _buildFilterChip('All Games', _selectedDifficulty == 'All' && _selectedType == 'All'),
                        ..._difficulties.skip(1).map((diff) => _buildFilterChip(diff, _selectedDifficulty == diff)),
                        ..._gameTypes.skip(1).map((type) => _buildFilterChip(type, _selectedType == type)),
                      ],
                    ),
                  ),
                  
                  // Games count
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          '${filteredGames.length} games found',
                          style: TextStyle(
                            color: primaryColor.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.grid_view, color: primaryColor),
                          onPressed: () {
                            // Toggle grid/list view
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // Games list
                  Expanded(
                    child: filteredGames.isEmpty
                        ? _buildEmptyState(primaryColor)
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            itemCount: filteredGames.length,
                            itemBuilder: (context, index) {
                              final game = filteredGames[index];
                              return AnimatedBuilder(
                                animation: _floatingController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatingAnimation.value * (index % 2 == 0 ? 1 : -1)),
                                    child: _buildGameCard(game, cardColor, primaryColor, subjectColor),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRandomGameDialog(),
        backgroundColor: subjectColor,
        tooltip: 'Random Game',
        child: Icon(Icons.shuffle, color: Colors.white),
      ),
    );
  }
  
  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (label == 'All Games') {
              _selectedDifficulty = 'All';
              _selectedType = 'All';
            } else if (_difficulties.contains(label)) {
              _selectedDifficulty = selected ? label : 'All';
            } else if (_gameTypes.contains(label)) {
              _selectedType = selected ? label : 'All';
            }
          });
        },
        selectedColor: Color(0xFF62D9FF).withOpacity(0.3),
        backgroundColor: Colors.white.withOpacity(0.1),
        labelStyle: TextStyle(
          color: isSelected ? Color(0xFF062863) : Colors.white.withOpacity(0.8),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  
  Widget _buildGameCard(Map<String, dynamic> game, Color cardColor, Color primaryColor, Color subjectColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        color: cardColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _launchGame(game),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            game['color'].withOpacity(0.8),
                            game['color'].withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        game['icon'],
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  game['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              if (game['isNew'])
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _toggleFavorite(game),
                                child: Icon(
                                  game['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                  color: game['isFavorite'] ? Colors.red : primaryColor.withOpacity(0.5),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            game['description'],
                            style: TextStyle(
                              color: primaryColor.withOpacity(0.7),
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Game stats
                Row(
                  children: [
                    _buildStatChip(Icons.timer, game['duration'], Colors.blue),
                    SizedBox(width: 8),
                    _buildStatChip(Icons.star, '${game['rating']}', Colors.orange),
                    SizedBox(width: 8),
                    _buildStatChip(Icons.people, '${game['players']}', Colors.green),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(game['difficulty']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        game['difficulty'],
                        style: TextStyle(
                          color: _getDifficultyColor(game['difficulty']),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Play button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _launchGame(game),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subjectColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Play Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.games,
            size: 64,
            color: primaryColor.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'No games found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedDifficulty = 'All';
                _selectedType = 'All';
              });
            },
            child: Text('Clear Filters'),
          ),
        ],
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
  
  void _launchGame(Map<String, dynamic> game) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(game['icon'], color: game['color']),
            SizedBox(width: 8),
            Expanded(child: Text(game['name'])),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(game['description']),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                Text('Duration: ${game['duration']}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.signal_cellular_alt, size: 16, color: _getDifficultyColor(game['difficulty'])),
                SizedBox(width: 4),
                Text('Difficulty: ${game['difficulty']}'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Actually launch the game
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Launching ${game['name']}...'),
                  backgroundColor: game['color'],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: game['color'],
              foregroundColor: Colors.white,
            ),
            child: Text('Play'),
          ),
        ],
      ),
    );
  }
  
  void _toggleFavorite(Map<String, dynamic> game) {
    setState(() {
      game['isFavorite'] = !game['isFavorite'];
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          game['isFavorite'] 
              ? 'Added to favorites!' 
              : 'Removed from favorites',
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }
  
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Difficulty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _difficulties.map((diff) => FilterChip(
                  label: Text(diff),
                  selected: _selectedDifficulty == diff,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDifficulty = selected ? diff : 'All';
                    });
                  },
                )).toList(),
              ),
              SizedBox(height: 16),
              Text('Game Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _gameTypes.map((type) => FilterChip(
                  label: Text(type),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? type : 'All';
                    });
                  },
                )).toList(),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDifficulty = 'All';
                          _selectedType = 'All';
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Clear'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Games'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter game name...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            // TODO: Implement search
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Search feature coming soon!')),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _showRandomGameDialog() {
    final games = _getFilteredGames();
    if (games.isEmpty) return;
    
    final randomGame = games[DateTime.now().millisecondsSinceEpoch % games.length];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.shuffle, color: Colors.orange),
            SizedBox(width: 8),
            Text('Random Game'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: randomGame['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                randomGame['icon'],
                color: randomGame['color'],
                size: 40,
              ),
            ),
            SizedBox(height: 16),
            Text(
              randomGame['name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              randomGame['description'],
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchGame(randomGame);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: randomGame['color'],
              foregroundColor: Colors.white,
            ),
            child: Text('Play'),
          ),
        ],
      ),
    );
  }
}