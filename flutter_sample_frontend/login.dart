import 'package:flutter/material.dart';
import 'class_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD0F4FF),
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Color(0xFF62D9FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // for now, just go to class page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ClassPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF62D9FF),
              ),
              child: Text("Submit", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF062863))),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text("Don't have an account? Sign Up here", style: TextStyle(color: Color(0xFF062863))),
            ),
          ],
        ),
      ),
    );
  }
}
