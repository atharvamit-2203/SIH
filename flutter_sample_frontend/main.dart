import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'class_page.dart';
import 'subjects.dart';
import 'theme_provider.dart';

void main() => runApp(StudyFunApp());

class StudyFunApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'StudyFun!',
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF60AFFF),
                brightness: Brightness.light,
              ),
              fontFamily: 'Quicksand',
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF60AFFF),
                brightness: Brightness.dark,
              ),
              fontFamily: 'Quicksand',
              useMaterial3: true,
            ),
            themeMode: themeProvider.themeMode,
            home: WelcomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Color(0xFFB5FFFC) : Color(0xFF062863);

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF062863) : Color(0xFFD0F4FF),
      body: Stack(
        children: [
          // Decorative circles
          Positioned(left: -70, top: -60, child: AnimatedCircle(color: Color(0xFF62D9FF), size: 200)),
          Positioned(right: -50, top: 100, child: AnimatedCircle(color: Color(0xFFEBC5FF), size: 120)),
          Positioned(left: 20, bottom: 30, child: AnimatedCircle(color: Color(0xFFB5FFFC), size: 110)),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: IconButton(
                icon: Icon(Icons.settings, size: 32, color: primaryColor),
                onPressed: () {
                  _showSettingsPopup(context, themeProvider);
                },
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInTransition(
                  delay: Duration(milliseconds: 300),
                  child: Text(
                    'playFUN.',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                FadeInTransition(
                  delay: Duration(milliseconds: 700),
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ClassPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        backgroundColor: Color(0xFF62D9FF),
                      ),
                      child: Text(
                        "START",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF062863),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInTransition(
                  delay: Duration(milliseconds: 900),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "login",
                      style: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsPopup(BuildContext context, ThemeProvider themeProvider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Settings",
      transitionDuration: Duration(milliseconds: 400),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeOutQuad.transform(a1.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation a1, Animation a2) {
        return SettingsPopup();
      },
    );
  }
}

// Reusable animated circle
class AnimatedCircle extends StatelessWidget {
  final Color color;
  final double size;

  const AnimatedCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.45),
        shape: BoxShape.circle,
      ),
    );
  }
}

// Simple fade-in animation widget
class FadeInTransition extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInTransition({required this.child, this.delay = const Duration(milliseconds: 0)});

  @override
  _FadeInTransitionState createState() => _FadeInTransitionState();
}

class _FadeInTransitionState extends State<FadeInTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class SettingsPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.white : Color(0xFF062863);
    final cardColor = isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFC7EFFE);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 20),
              _buildSettingOption(
                context,
                icon: Icons.brightness_6,
                title: "Dark/Light Mode",
              ),
              SizedBox(height: 10),
              _buildSettingOption(
                context,
                icon: Icons.report_problem,
                title: "Report a Problem",
              ),
              SizedBox(height: 10),
              _buildSettingOption(
                context,
                icon: Icons.link,
                title: "Visit Developer Site",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingOption(BuildContext context, {required IconData icon, required String title}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.white : Color(0xFF062863);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: primaryColor,
              ),
            ),
          ),
          if (title == "Dark/Light Mode")
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: primaryColor,
            ),
        ],
      ),
    );
  }
}