import 'package:flutter/material.dart';
import 'class_page.dart';
import 'login.dart';
import 'database_helper.dart'; // Import the database helper

class SignupPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Color(0xFFE5F1FF) : Color(0xFF1B2E68);
    final secondaryColor = isDarkMode ? Color(0xFF62D9FF) : Color(0xFF238FFF);
    final backgroundColor = isDarkMode ? Color(0xFF1B2E68) : Color(0xFF88D8FF);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                "Join the Fun!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Create an account to start your adventure.",
                style: TextStyle(
                  fontSize: 12,
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
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                style: TextStyle(color: primaryColor),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
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
                onPressed: () async {
                  if (passwordController.text == confirmPasswordController.text) {
                    final dbHelper = DatabaseHelper();
                    final user = {
                      'email': usernameController.text,
                      'password': passwordController.text,
                    };
                    await dbHelper.insertUser(user);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Account created successfully!')),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ClassPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Passwords do not match')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: StadiumBorder(),
                  backgroundColor: Color(0xFF62D9FF),
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2E68),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Already have an account? Login",
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