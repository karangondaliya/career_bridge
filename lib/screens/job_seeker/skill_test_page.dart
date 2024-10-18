import 'package:flutter/material.dart';
import '../skill_test/cpp_skill_test.dart';
import '../skill_test/java_skill_test.dart';

class SkillTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Skill Test'),
        backgroundColor: Colors.lightBlue[300], // Set AppBar color to light blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Center the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the buttons vertically
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[400], // Set button color to light blue
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Make text white for contrast
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CppSkillTestPage()), // Redirect to C++ Test
                  );
                },
                child: Text('C++ Skill Test'),
              ),
              SizedBox(height: 20), // Spacing between buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[400], // Set button color to light blue
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Make text white for contrast
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JavaSkillTestPage()), // Redirect to Java Test
                  );
                },
                child: Text('Java Skill Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
