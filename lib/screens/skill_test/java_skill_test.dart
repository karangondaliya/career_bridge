import 'package:flutter/material.dart';

class JavaSkillTestPage extends StatefulWidget {
  @override
  _JavaSkillTestPageState createState() => _JavaSkillTestPageState();
}

class _JavaSkillTestPageState extends State<JavaSkillTestPage> {
  final List<Question> questions = [
    Question(
      questionText: 'What is the size of an int variable in Java?',
      options: ['16 bits', '32 bits', '64 bits', '128 bits'],
      correctAnswer: '32 bits',
    ),
    Question(
      questionText: 'Which of the following is not a Java keyword?',
      options: ['new', 'try', 'goto', 'return'],
      correctAnswer: 'goto',
    ),
    Question(
      questionText: 'Which method is used to start a thread in Java?',
      options: ['run()', 'start()', 'begin()', 'init()'],
      correctAnswer: 'start()',
    ),
    Question(
      questionText: 'What is the default value of a boolean variable in Java?',
      options: ['true', 'false', '0', 'null'],
      correctAnswer: 'false',
    ),
    Question(
      questionText: 'What is the purpose of the "final" keyword in Java?',
      options: [
        'To define constants',
        'To prevent method overriding',
        'To prevent inheritance',
        'All of the above'
      ],
      correctAnswer: 'All of the above',
    ),
    Question(
      questionText: 'Which of the following is used to handle exceptions in Java?',
      options: ['try-catch block', 'if-else block', 'for loop', 'switch case'],
      correctAnswer: 'try-catch block',
    ),
    Question(
      questionText: 'What is the output of the following code: System.out.println(2 + 3 + "5");?',
      options: ['25', '55', '10', '7'],
      correctAnswer: '55',
    ),
    Question(
      questionText: 'Which of the following is not a primitive data type in Java?',
      options: ['int', 'float', 'String', 'boolean'],
      correctAnswer: 'String',
    ),
    Question(
      questionText: 'What is the correct way to create a new array in Java?',
      options: [
        'int arr[] = new int[5];',
        'int arr = new int[5];',
        'int[] arr = int[5];',
        'array int arr = new int[5];'
      ],
      correctAnswer: 'int arr[] = new int[5];',
    ),
    Question(
      questionText: 'Which keyword is used to inherit a class in Java?',
      options: ['extends', 'implements', 'inherits', 'import'],
      correctAnswer: 'extends',
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
        title: Text('Java Skill Test'), // Display Java test name
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
