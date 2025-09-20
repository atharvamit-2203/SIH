import 'package:flutter/material.dart';
import 'subjects.dart';

class ClassPage extends StatelessWidget {
  final List<String> classes = ["6th Grade", "7th Grade", "8th Grade", "9th Grade", "10th Grade", "11th Grade", "12th Grade"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD0F4FF),
      appBar: AppBar(
        title: Text("Select Your Class"),
        backgroundColor: Color(0xFF62D9FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.separated(
          itemCount: classes.length,
          separatorBuilder: (_, __) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                backgroundColor: Color(0xFF81F0FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              ),
              child: Text(classes[index], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF062863))),
            );
          },
        ),
      ),
    );
  }
}
