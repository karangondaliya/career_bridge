import 'package:flutter/material.dart';

// Define the Question and SkillTest models
class SkillTest {
  final String name;
  final List<Question> questions;

  SkillTest({required this.name, required this.questions});
}

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  }) : assert(options.isNotEmpty, 'Options cannot be empty'); // Ensure options are not empty
}

// Sample skill tests with aptitude questions
final List<SkillTest> skillTests = [
  SkillTest(
    name: 'Aptitude Test',
    questions: [
      Question(
        questionText: 'What is 25% of 200?',
        options: ['25', '50', '75', '100'],
        correctAnswer: '50',
      ),
      Question(
        questionText: 'If a train travels 60 km in 1 hour, how far will it travel in 3 hours?',
        options: ['120 km', '180 km', '240 km', '300 km'],
        correctAnswer: '180 km',
      ),
      Question(
        questionText: 'If the cost of 5 apples is \$10, what is the cost of 8 apples?',
        options: ['\$12', '\$14', '\$16', '\$18'],
        correctAnswer: '\$16',
      ),
      Question(
        questionText: 'Which number is the smallest prime number?',
        options: ['1', '2', '3', '5'],
        correctAnswer: '2',
      ),
      Question(
        questionText: 'Find the missing number: 3, 6, 9, 12, ?',
        options: ['14', '15', '16', '18'],
        correctAnswer: '15',
      ),
      Question(
        questionText: 'How many sides does a heptagon have?',
        options: ['5', '6', '7', '8'],
        correctAnswer: '7',
      ),
      Question(
        questionText: 'The average of 5, 10, and 15 is:',
        options: ['10', '12', '15', '20'],
        correctAnswer: '10',
      ),
      Question(
        questionText: 'What is the square root of 81?',
        options: ['7', '8', '9', '10'],
        correctAnswer: '9',
      ),
      Question(
        questionText: 'If the perimeter of a square is 40 units, what is the length of one side?',
        options: ['5', '8', '10', '12'],
        correctAnswer: '10',
      ),
      Question(
        questionText: 'If a bag contains 3 red, 4 blue, and 5 green balls, what is the probability of picking a blue ball?',
        options: ['1/4', '1/3', '1/2', '2/3'],
        correctAnswer: '1/3',
      ),
    ],
  ),
];

class SkillTestPage extends StatefulWidget {
  @override
  _SkillTestPageState createState() => _SkillTestPageState();
}

class _SkillTestPageState extends State<SkillTestPage> {
  SkillTest? selectedTest;
  Map<int, String?> answers = {};
  bool showResults = false;
  List<int> incorrectQuestions = [];

  @override
  void initState() {
    super.initState();
    if (skillTests.isNotEmpty) {
      selectedTest = skillTests[0]; // Automatically select the first skill test
    }
  }

  void _submitTest() {
    if (selectedTest == null) return;

    int score = 0;
    incorrectQuestions.clear();

    for (int i = 0; i < selectedTest!.questions.length; i++) {
      if (answers[i] == selectedTest!.questions[i].correctAnswer) {
        score++;
      } else {
        incorrectQuestions.add(i); // Track incorrect answers
      }
    }

    setState(() {
      showResults = true; // Trigger UI update to show results
    });

    // Show feedback in a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Test Results'),
          content: Text('Score: $score/${selectedTest!.questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionCard(int index, Question question) {
    final options = question.options.isNotEmpty ? question.options : ['No options available'];
    bool isIncorrect = incorrectQuestions.contains(index);

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: isIncorrect ? Colors.red[50] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ${question.questionText}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            ...options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: answers[index],
                onChanged: (value) {
                  setState(() {
                    answers[index] = value;
                  });
                },
              );
            }).toList(),
            if (showResults && isIncorrect) ...[
              SizedBox(height: 10),
              Text(
                'Correct Answer: ${question.correctAnswer}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aptitude Test'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedTest != null) ...[
              Text(
                'Test: ${selectedTest!.name}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedTest!.questions.length,
                  itemBuilder: (context, index) {
                    final question = selectedTest!.questions[index];
                    return _buildQuestionCard(index, question);
                  },
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _submitTest,
                  child: Text('Submit Test'),
                ),
              ),
            ] else ...[
              Center(child: Text('No test available.')),
            ],
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      textTheme: TextTheme(
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    home: SkillTestPage(),
  ));
}
