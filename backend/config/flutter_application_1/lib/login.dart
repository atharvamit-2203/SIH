import 'package:flutter/material.dart';
import 'class_page.dart';
import 'signup.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.white : Color(0xFF062863);
    final secondaryColor = isDarkMode ? Color(0xFF62D9FF) : Color(0xFF238FFF);

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF062863) : Color(0xFFD0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Login to continue your adventure.",
                style: TextStyle(
                  fontSize: 18,
                  color: secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              TextField(
                controller: usernameController,
                style: TextStyle(color: primaryColor),
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: TextStyle(color: primaryColor.withOpacity(0.7)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(isDarkMode ? 0.2 : 0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                style: TextStyle(color: primaryColor),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: primaryColor.withOpacity(0.7)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(isDarkMode ? 0.2 : 0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ClassPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: StadiumBorder(),
                  backgroundColor: Color(0xFF62D9FF),
                ),
                child: Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062863),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    color: primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}