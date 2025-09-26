import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'equation_shooter.dart'; // Import the new game file

class MathsGamesPage extends StatelessWidget {
  final List<String> mathsGames = [
    "Equation Shooter", // Updated game title
    "Subtraction Sprint",
    "Multiplication Mayhem",
    "Division Dash",
    "Fraction Frenzy",
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
        title: Text(
          "MATHS GAMES",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose your game!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: mathsGames.length,
                separatorBuilder: (_, __) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return GameCard(
                    title: mathsGames[index],
                    emoji: _getEmojiForGame(mathsGames[index]),
                    onTap: mathsGames[index] == 'Equation Shooter'
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EquationShooterGameWidget(),
                              ),
                            );
                          }
                        : () {
                            // Dummy score-saving for other games
                            final dummyScore = {
                              'user_id': 1,
                              'game_name': mathsGames[index],
                              'score': (index + 1) * 100,
                            };
                            DatabaseHelper().insertScore(dummyScore);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${mathsGames[index]} score saved!')),
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
  }

  String _getEmojiForGame(String gameTitle) {
    switch (gameTitle) {
      case "Equation Shooter":
        return "🔫";
      case "Subtraction Sprint":
        return "➖";
      case "Multiplication Mayhem":
        return "✖️";
      case "Division Dash":
        return "➗";
      case "Fraction Frenzy":
        return "1/2";
      default:
        return "🎲";
    }
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String emoji;
  final VoidCallback? onTap;

  const GameCard({required this.title, required this.emoji, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Color(0xFF1B2E68) : Color(0xFF1B2E68);
    final shadowColor = isDarkMode ? Color(0xFF238FFF) : Color(0xFF9EE7FF);

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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
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
}