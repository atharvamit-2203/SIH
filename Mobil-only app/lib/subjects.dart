import 'package:flutter/material.dart';
import 'maths_games.dart';

// Subjects page
class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  final List<Map<String, String>> subjects = const [
    {'label': 'Maths', 'emoji': '➗'},
    {'label': 'Science', 'emoji': '🔬'},
    {'label': 'English', 'emoji': '📚'},
    {'label': 'History', 'emoji': '🏰'},
    {'label': 'Geography', 'emoji': '🌍'},
    {'label': 'Comp Sci', 'emoji': '💻'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Color(0xFFE5F1FF) : Color(0xFF1B2E68);
    final secondaryColor = isDarkMode ? Color(0xFF238FFF) : Color(0xFF88D8FF);
    final backgroundColor = isDarkMode ? Color(0xFF1B2E68) : Color(0xFF88D8FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 4,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          "SUBJECTS",
          style: TextStyle(
            fontSize: 18,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Decorative background circles
          const Positioned(left: -70, top: -60, child: AnimatedPixelatedSquare(color: Color(0xFFF3C7FF), size: 200)),
          const Positioned(right: -50, top: 100, child: AnimatedPixelatedSquare(color: Color(0xFFFFE8A3), size: 120)),
          const Positioned(left: 20, bottom: 30, child: AnimatedPixelatedSquare(color: Color(0xFFB5FFFC), size: 110)),

          // App content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'PLAY, LEARN & WIN!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  children: subjects.map((s) {
                    return SubjectCard(
                      label: s['label']!,
                      emoji: s['emoji']!,
                      onTap: s['label'] == 'Maths'
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MathsGamesPage()),
                              );
                            }
                          : null,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

// Subject card widget
class SubjectCard extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback? onTap;

  const SubjectCard({super.key, required this.label, required this.emoji, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Color(0xFF1B2E68) : Color(0xFF1B2E68);

    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(22),
      shadowColor: isDarkMode ? Color(0xFF238FFF) : Color(0xFF9EE7FF),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? const LinearGradient(
                    colors: [Color(0xFFF3C7FF), Color(0xFFFFE8A3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFFF3C7FF), Color(0xFFFFE8A3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 44)),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Decorative animated circle
class AnimatedPixelatedSquare extends StatelessWidget {
  final Color color;
  final double size;

  const AnimatedPixelatedSquare({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.45),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}