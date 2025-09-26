import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'login.dart';
import 'class_page.dart';
import 'subjects.dart';
import 'theme_provider.dart';
import 'database_helper.dart';

void main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }

  runApp(StudyFunApp());
}

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
                seedColor: Color(0xFF1B2E68),
                brightness: Brightness.light,
              ),
              fontFamily: 'PressStart2P',
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF1B2E68),
                brightness: Brightness.dark,
              ),
              fontFamily: 'PressStart2P',
              useMaterial3: true,
            ),
            themeMode: themeProvider.themeMode,
            home: FutureBuilder(
              future: _initializeDatabase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      backgroundColor: Color(0xFF1B2E68),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 48),
                            SizedBox(height: 16),
                            Text(
                              'Database Error',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return WelcomeScreen();
                }
                return Scaffold(
                  backgroundColor: Color(0xFF1B2E68),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Initializing Database...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  Future<void> _initializeDatabase() async {
    try {
      await DatabaseHelper().database;
      print('Database initialized successfully');
    } catch (e) {
      print('Database initialization failed: $e');
      rethrow;
    }
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Color(0xFFE5F1FF) : Color(0xFF1B2E68);

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1B2E68) : Color(0xFF88D8FF),
      body: Stack(
        children: [
          // Decorative circles - now with a pixelated retro aesthetic
          Positioned(left: -70, top: -60, child: AnimatedPixelatedSquare(color: Color(0xFFF3C7FF), size: 200)),
          Positioned(right: -50, top: 100, child: AnimatedPixelatedSquare(color: Color(0xFFFFE8A3), size: 120)),
          Positioned(left: 20, bottom: 30, child: AnimatedPixelatedSquare(color: Color(0xFFB5FFFC), size: 110)),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: IconButton(
                icon: Icon(Icons.settings, size: 32, color: primaryColor),
                onPressed: () {
                  _showSettingsPopup(context);
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
                      fontSize: 36, // Adjusted size
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
                        backgroundColor: Color(0xFFF3C7FF),
                      ),
                      child: Text(
                        "START",
                        style: TextStyle(
                          fontSize: 22, // Adjusted size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2E68),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInTransition(
                  delay: Duration(milliseconds: 900),
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        backgroundColor: Color(0xFFFFE8A3),
                      ),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 22, // Adjusted size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2E68),
                        ),
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

  void _showSettingsPopup(BuildContext context) {
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

// Reusable animated pixelated square
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
    final primaryColor = isDarkMode ? Color(0xFFE5F1FF) : Color(0xFF1B2E68);
    final cardColor = isDarkMode ? Color(0xFF1B2E68) : Color(0xFF88D8FF);
    final tileColor = isDarkMode ? Color(0xFF4C5D8B) : Colors.white.withOpacity(0.4);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: primaryColor, width: 4),
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
                tileColor: tileColor,
                primaryColor: primaryColor,
              ),
              SizedBox(height: 10),
              _buildSettingOption(
                context,
                icon: Icons.report_problem,
                title: "Report a Problem",
                tileColor: tileColor,
                primaryColor: primaryColor,
              ),
              SizedBox(height: 10),
              _buildSettingOption(
                context,
                icon: Icons.link,
                title: "Visit Developer Site",
                tileColor: tileColor,
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingOption(BuildContext context, {required IconData icon, required String title, required Color tileColor, required Color primaryColor}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor, width: 2),
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