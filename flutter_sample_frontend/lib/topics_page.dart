import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TopicsPage extends StatefulWidget {
  final String subjectName;
  final String subjectEmoji;
  final int subjectId;
  final int? boardId;
  final int? classId;

  const TopicsPage({
    Key? key,
    required this.subjectName,
    required this.subjectEmoji,
    required this.subjectId,
    this.boardId,
    this.classId,
  }) : super(key: key);

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  List<Map<String, dynamic>> topics = [];
  bool isLoading = true;
  String? error;
  String selectedDifficulty = 'all';

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Build URL with query parameters
      String url = 'http://localhost:5000/api/topics/by-subject/${widget.subjectId}?';
      if (widget.boardId != null) url += 'board_id=${widget.boardId}&';
      if (widget.classId != null) url += 'class_id=${widget.classId}&';
      if (selectedDifficulty != 'all') url += 'difficulty=$selectedDifficulty';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            topics = List<Map<String, dynamic>>.from(data['topics']);
            isLoading = false;
          });
        } else {
          setState(() {
            error = data['error'] ?? 'Failed to load topics';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to connect to server';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color chipColor;
    Color textColor = Colors.white;
    IconData icon;
    
    switch (difficulty) {
      case 'basic':
        chipColor = Colors.green;
        icon = Icons.circle;
        break;
      case 'intermediate':
        chipColor = Colors.orange;
        icon = Icons.adjust;
        break;
      case 'advanced':
        chipColor = Colors.red;
        icon = Icons.star;
        break;
      default:
        chipColor = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            difficulty.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showTopicDetails(topic);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      topic['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF062863),
                      ),
                    ),
                  ),
                  if (topic['difficulty'] != null)
                    _buildDifficultyChip(topic['difficulty']),
                ],
              ),
              const SizedBox(height: 8),
              if (topic['description'] != null)
                Text(
                  topic['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (topic['estimated_hours'] != null) ...[
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${topic['estimated_hours']} hours',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Icon(Icons.play_circle_outline, size: 16, color: Colors.blue[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Start Learning',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
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

  void _showTopicDetails(Map<String, dynamic> topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    topic['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF062863),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (topic['difficulty'] != null) ...[
              Row(
                children: [
                  const Text('Difficulty: '),
                  _buildDifficultyChip(topic['difficulty']),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (topic['description'] != null) ...[
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                topic['description'],
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],
            if (topic['estimated_hours'] != null) ...[
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text('Estimated Study Time: ${topic['estimated_hours']} hours'),
                ],
              ),
              const SizedBox(height: 24),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to games/activities for this topic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF62D9FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.play_arrow, color: Color(0xFF062863)),
                label: const Text(
                  'Start Learning',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062863),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Basic', 'basic'),
          const SizedBox(width: 8),
          _buildFilterChip('Intermediate', 'intermediate'),
          const SizedBox(width: 8),
          _buildFilterChip('Advanced', 'advanced'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    bool isSelected = selectedDifficulty == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedDifficulty = value;
        });
        fetchTopics();
      },
      selectedColor: const Color(0xFF62D9FF),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF062863) : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.white : const Color(0xFF062863);
    final backgroundColor = isDarkMode ? const Color(0xFF062863) : const Color(0xFFD0F4FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF238FFF),
        elevation: 4,
        iconTheme: IconThemeData(color: primaryColor),
        title: Row(
          children: [
            Text(
              widget.subjectEmoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${widget.subjectName} Topics',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildDifficultyFilter(),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: fetchTopics,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : topics.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.subjectEmoji,
                                  style: const TextStyle(fontSize: 64),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No topics found for this subject.',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Topics may not be available for your current board and class selection.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: topics.length,
                            itemBuilder: (context, index) {
                              return _buildTopicCard(topics[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}