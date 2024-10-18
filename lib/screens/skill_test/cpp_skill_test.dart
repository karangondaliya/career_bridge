import 'package:flutter/material.dart';

class CppSkillTestPage extends StatefulWidget {
  @override
  _CppSkillTestPageState createState() => _CppSkillTestPageState();
}

class _CppSkillTestPageState extends State<CppSkillTestPage> {
  final List<Question> questions = [
    Question(
      questionText: 'What is the output of the following C++ code: cout << 2 + 3 * 2;?',
      options: ['8', '10', '6', '12'],
      correctAnswer: '8',
    ),
    Question(
      questionText: 'Which of the following is the correct syntax to create an object in C++?',
      options: ['ClassName obj;', 'Class obj;', 'Object obj;', 'obj = new Class();'],
      correctAnswer: 'ClassName obj;',
    ),
    Question(
      questionText: 'Which operator is used to allocate memory dynamically in C++?',
      options: ['malloc', 'new', 'alloc', 'calloc'],
      correctAnswer: 'new',
    ),
    Question(
      questionText: 'What is the size of an int data type in C++?',
      options: ['2 bytes', '4 bytes', '8 bytes', 'Depends on system'],
      correctAnswer: 'Depends on system',
    ),
    Question(
      questionText: 'Which of the following is a correct way to declare a pointer in C++?',
      options: ['int* p;', 'int p*;', 'int p;', 'pointer int p;'],
      correctAnswer: 'int* p;',
    ),
    Question(
      questionText: 'What is the purpose of the "this" pointer in C++?',
      options: ['To refer to the base class', 'To refer to the current object', 'To refer to the parent class', 'None of the above'],
      correctAnswer: 'To refer to the current object',
    ),
    Question(
      questionText: 'Which of the following is the correct syntax for a destructor in C++?',
      options: ['~ClassName();', 'ClassName~();', 'ClassName();', 'Destructor ClassName();'],
      correctAnswer: '~ClassName();',
    ),
    Question(
      questionText: 'What does the "const" keyword signify in C++?',
      options: ['The variable is constant and cannot change', 'The variable can change', 'The variable can be modified by a pointer', 'None of the above'],
      correctAnswer: 'The variable is constant and cannot change',
    ),
    Question(
      questionText: 'Which of the following is not a feature of Object-Oriented Programming in C++?',
      options: ['Inheritance', 'Polymorphism', 'Encapsulation', 'Compilation'],
      correctAnswer: 'Compilation',
    ),
    Question(
      questionText: 'Which of the following is the correct syntax for a for loop in C++?',
      options: ['for(int i = 0; i < n; i++)', 'for i = 0; i < n; i++', 'for(int i < n; i++)', 'for(int i = 0; i < n)'],
      correctAnswer: 'for(int i = 0; i < n; i++)',
    ),
  ];

  Map<int, String?> answers = {};
  bool showResults = false;
  List<int> incorrectQuestions = [];

  void _submitTest() {
    int score = 0;
    incorrectQuestions.clear();

    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].correctAnswer) {
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
          content: Text('Score: $score/${questions.length}'),
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
        title: Text('C++ Skill Test'), // Display C++ test name
        backgroundColor: Colors.lightBlue[300], // Set AppBar color to light blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionCard(index, questions[index]);
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[400], // Set button color to light blue
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: _submitTest,
                child: Text('Submit Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Define the Question model
class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });
}
