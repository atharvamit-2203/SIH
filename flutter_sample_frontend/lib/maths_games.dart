import 'package:flutter/material.dart';

class MathsGamesPage extends StatelessWidget {
  final List<String> mathsGames = [
    "Addition Adventure",
    "Subtraction Sprint",
    "Multiplication Mayhem",
    "Division Dash",
    "Fraction Frenzy",
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.white : Color(0xFF062863);
    final secondaryColor = isDarkMode ? Color(0xFF62D9FF) : Color(0xFF238FFF);
    final backgroundColor = isDarkMode ? Color(0xFF062863) : Color(0xFFD0F4FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Maths Games",
          style: TextStyle(
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
                fontSize: 24,
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
      case "Addition Adventure":
        return "➕";
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

  const GameCard({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Color(0xFF062863) : Color(0xFF062863);
    final shadowColor = isDarkMode ? Color(0xFF238FFF) : Color(0xFF9EE7FF);

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(22),
      shadowColor: shadowColor,
      child: InkWell(
        onTap: () {
          // Add game navigation logic here later
        },
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? const LinearGradient(
                    colors: [Color(0xFF238FFF), Color(0xFF62D9FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFF81F0FF), Color(0xFFC7EFFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
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