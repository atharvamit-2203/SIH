import 'package:flutter/material.dart';
import 'class_page.dart';
import 'signup.dart';
import 'database_helper.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Login to continue your adventure.",
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
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  // Validate input fields
                  if (usernameController.text.trim().isEmpty || 
                      passwordController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  try {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(child: CircularProgressIndicator());
                      },
                    );

                    // Check if a user with the provided email exists
                    final user = await DatabaseHelper().getUser(usernameController.text.trim());
                    
                    // Hide loading indicator
                    Navigator.of(context).pop();
                    
                    if (user != null && user['password'] == passwordController.text) {
                      // Successful login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ClassPage()),
                      );
                    } else {
                      // Invalid credentials
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invalid username or password'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    // Hide loading indicator if still showing
                    Navigator.of(context).pop();
                    
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    print('Login error: $e'); // For debugging
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: StadiumBorder(),
                  backgroundColor: Color(0xFF62D9FF),
                ),
                child: Text(
                  "Log In",
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