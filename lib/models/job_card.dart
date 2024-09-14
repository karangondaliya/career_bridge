// models/job_card.dart

import 'package:flutter/material.dart';
import 'job_detail_dialog.dart';

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String company;
  final String location;
  final String jobDescription;
  final String requirements;
  final String salary;
  final String datePosted;
  final String providerEmail;

  const JobCard({
    Key? key,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.jobDescription,
    required this.requirements,
    required this.salary,
    required this.datePosted,
    required this.providerEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.lightBlueAccent, width: 1),
      ),
      elevation: 8,
      child: ListTile(
        leading: const Icon(Icons.work, color: Colors.lightBlueAccent),
        title: Text(jobTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text('$company - $location'),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => JobDetailDialog(
              jobTitle: jobTitle,
              jobDescription: jobDescription,
              requirements: requirements,
              salary: salary,
              datePosted: datePosted,
              providerEmail: providerEmail,
            ),
          );
        },
      ),
    );
  }
}
