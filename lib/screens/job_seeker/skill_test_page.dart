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
  }) : assert(options.isNotEmpty, 'Options cannot be empty'); // Ensure options is not empty
}

// Sample skill tests with more questions
final List<SkillTest> skillTests = [
  SkillTest(
    name: 'General Knowledge',
    questions: [
      Question(
        questionText: 'What is the capital of France?',
        options: ['Berlin', 'Madrid', 'Paris', 'Rome'],
        correctAnswer: 'Paris',
      ),
      Question(
        questionText: 'What is the largest planet in our solar system?',
        options: ['Earth', 'Jupiter', 'Mars', 'Saturn'],
        correctAnswer: 'Jupiter',
      ),
      Question(
        questionText: 'Which element has the chemical symbol Au?',
        options: ['Gold', 'Silver', 'Iron', 'Lead'],
        correctAnswer: 'Gold',
      ),
      Question(
        questionText: 'Who wrote "To Kill a Mockingbird"?',
        options: ['Harper Lee', 'Mark Twain', 'Ernest Hemingway', 'F. Scott Fitzgerald'],
        correctAnswer: 'Harper Lee',
      ),
    ],
  ),
  SkillTest(
    name: 'Programming Fundamentals',
    questions: [
      Question(
        questionText: 'What is the time complexity of binary search?',
        options: ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'],
        correctAnswer: 'O(log n)',
      ),
      Question(
        questionText: 'Which programming language is known as the "mother of all languages"?',
        options: ['C', 'Java', 'Python', 'Assembly'],
        correctAnswer: 'C',
      ),
      Question(
        questionText: 'What does SQL stand for?',
        options: ['Structured Query Language', 'Sequential Query Language', 'Simple Query Language', 'Standard Query Language'],
        correctAnswer: 'Structured Query Language',
      ),
      Question(
        questionText: 'In object-oriented programming, what is the term for the process of hiding implementation details?',
        options: ['Abstraction', 'Encapsulation', 'Inheritance', 'Polymorphism'],
        correctAnswer: 'Encapsulation',
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

  @override
  void initState() {
    super.initState();
    // Automatically select the first skill test if available
    if (skillTests.isNotEmpty) {
      selectedTest = skillTests[0];
    }
  }

  void _submitTest() {
    if (selectedTest == null) return;

    int score = 0;
    for (int i = 0; i < selectedTest!.questions.length; i++) {
      if (answers[i] == selectedTest!.questions[i].correctAnswer) {
        score++;
      }
    }

    final feedback = score == selectedTest!.questions.length
        ? 'Excellent! You got all answers right.'
        : 'Good effort! You got $score out of ${selectedTest!.questions.length} correct.';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Test Results'),
          content: Text('Score: $score\nFeedback: $feedback'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skill Test'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedTest != null) ...[
              Text(
                'Test: ${selectedTest!.name}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedTest!.questions.length,
                  itemBuilder: (context, index) {
                    final question = selectedTest!.questions[index];
                    final options = question.options.isNotEmpty ? question.options : ['No options available'];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.questionText,
                              style: Theme.of(context).textTheme.titleMedium,
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _submitTest,
                  child: Text('Submit'),
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
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    home: SkillTestPage(),
  ));
}
