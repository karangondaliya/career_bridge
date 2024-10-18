import 'package:flutter/material.dart';

import '../screens/application_form_dialog.dart';

class JobDetailDialog extends StatelessWidget {
  final String jobTitle;
  final String jobDescription;
  final String requirements;
  final String salary;
  final String datePosted;
  final String providerEmail;

  const JobDetailDialog({
    Key? key,
    required this.jobTitle,
    required this.jobDescription,
    required this.requirements,
    required this.salary,
    required this.datePosted,
    required this.providerEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(jobTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: $jobDescription', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Requirements: $requirements', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Salary: $salary', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Posted on: $datePosted', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Provider Email: $providerEmail', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
          ),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _showApplicationForm(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  void _showApplicationForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ApplicationFormDialog(
        jobTitle: jobTitle,
        providerEmail: providerEmail,
      ),
    );
  }
}
