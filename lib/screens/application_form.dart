import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ApplicationForm extends StatefulWidget {
  final int jobId; // The ID of the job posting the user is applying for

  const ApplicationForm({Key? key, required this.jobId}) : super(key: key);

  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phone = '';
  String coverLetter = '';

  void _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get the current date and time
      String dateApplied = DateTime.now().toIso8601String();

      // Create the application data map
      Map<String, dynamic> applicationData = {
        'name': name,
        'email': email,
        'phone': phone,
        'coverLetter': coverLetter,
        'dateApplied': dateApplied,
        'jobId': widget.jobId, // Reference the job post
      };

      // Save the application to the database
      await _saveApplication(applicationData);

      // Show success message
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Application submitted successfully!')),
      );

      // Go back to the previous screen after a short delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context as BuildContext);
      });
    }
  }

  Future<void> _saveApplication(Map<String, dynamic> applicationData) async {
    // Open the database
    final database = await openDatabase(
      join(await getDatabasesPath(), 'applications.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            '''
          CREATE TABLE applications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            phone TEXT,
            coverLetter TEXT,
            dateApplied TEXT,
            jobId INTEGER
          )
          '''
        );
      },
    );

    // Insert the application data into the database
    await database.insert(
      'applications',
      applicationData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Close the database
    await database.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Job'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  phone = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cover Letter'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your cover letter';
                  }
                  return null;
                },
                onSaved: (value) {
                  coverLetter = value!;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitApplication,
                child: Text('Apply'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  textStyle: TextStyle(fontSize: 16),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
