import 'package:flutter/material.dart';
import 'login.dart';
import 'class_page.dart';
import 'subjects.dart';

void main() => runApp(StudyFunApp());

class StudyFunApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD0F4FF),
      body: Stack(
        children: [
          // Decorative circles
          Positioned(left: -70, top: -60, child: AnimatedCircle(color: Color(0xFF62D9FF), size: 200)),
          Positioned(right: -50, top: 100, child: AnimatedCircle(color: Color(0xFFEBC5FF), size: 120)),
          Positioned(left: 20, bottom: 30, child: AnimatedCircle(color: Color(0xFFB5FFFC), size: 110)),

          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.settings, size: 32, color: Color(0xFF062863)),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ClassPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      backgroundColor: Color(0xFF62D9FF),
                    ),
                    child: Text(
                      "Start",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF062863)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      backgroundColor: Color(0xFFEBC5FF),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF062863)),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          )
        ],
      ),
    );
  }
}

// Reusing your AnimatedCircle from before
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
