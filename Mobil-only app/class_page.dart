import 'package:flutter/material.dart';
import 'subjects.dart';

class ClassPage extends StatelessWidget {
  final List<String> classes = const ["6th Grade", "7th Grade", "8th Grade", "9th Grade", "10th Grade", "11th Grade", "12th Grade"];

  const ClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Color(0xFFE5F1FF) : Color(0xFF1B2E68);
    final secondaryColor = isDarkMode ? Color(0xFF238FFF) : Color(0xFF88D8FF);
    final backgroundColor = isDarkMode ? Color(0xFF1B2E68) : Color(0xFF88D8FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "SELECT CLASS",
          style: TextStyle(
            fontSize: 18,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: secondaryColor,
        elevation: 4,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: ListView.separated(
          itemCount: classes.length,
          separatorBuilder: (_, __) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            return ClassCard(
              label: classes[index],
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectsPage()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ClassCard({super.key, 
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final shadowColor = isDarkMode ? Color(0xFF238FFF) : Color(0xFF9EE7FF);
    final textColor = isDarkMode ? Color(0xFF1B2E68) : Color(0xFF1B2E68);

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(22),
      shadowColor: shadowColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
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
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
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

  const AnimatedPixelatedSquare({super.key, required this.color, required this.size});

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