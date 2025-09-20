import 'package:flutter/material.dart';

// Subjects page (formerly HomeScreen)
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
    return Scaffold(
      backgroundColor: const Color(0xFFD0F4FF),
      body: Stack(
        children: [
          // Decorative background circles
          const Positioned(left: -70, top: -60, child: AnimatedCircle(color: Color(0xFF62D9FF), size: 200)),
          const Positioned(right: -50, top: 100, child: AnimatedCircle(color: Color(0xFFEBC5FF), size: 120)),
          const Positioned(left: 20, bottom: 30, child: AnimatedCircle(color: Color(0xFFB5FFFC), size: 110)),

          // App content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Welcome to StudyFun!',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062863),
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 6),
                child: Text(
                  'Let\'s play, learn and win!',
                  style: TextStyle(fontSize: 20, color: Color(0xFF238FFF)),
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
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFF62D9FF),
                  ),
                  icon: const Icon(Icons.play_arrow, color: Color(0xFF062863), size: 28),
                  label: const Text(
                    "Start Adventure!",
                    style: TextStyle(fontSize: 22, color: Color(0xFF062863), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
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

  const SubjectCard({super.key, required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(22),
      shadowColor: const Color(0xFF9EE7FF),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {},
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF81F0FF), Color(0xFFC7EFFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 44)),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF062863)),
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
class AnimatedCircle extends StatelessWidget {
  final Color color;
  final double size;

  const AnimatedCircle({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.45),
        shape: BoxShape.circle,
      ),
    );
  }
}
