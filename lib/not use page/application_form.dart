import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart'; // Import this
import '../utils/application_helper.dart';
import '../models/job_application.dart';

class JobApplicationsPage extends StatefulWidget {
  final String providerEmail;

  JobApplicationsPage({required this.providerEmail});

  @override
  _JobApplicationsPageState createState() => _JobApplicationsPageState();
}

enum ResultType {
  done,
  error,
  canceled,
}

class _JobApplicationsPageState extends State<JobApplicationsPage> {
  late Future<List<JobApplication>> _jobApplications;

  @override
  void initState() {
    super.initState();

    _jobApplications = _fetchJobApplications();
  }

  Future<List<JobApplication>> _fetchJobApplications() async {
    final applicationHelper = ApplicationHelper.instance;
    final jobApplications = await applicationHelper.getJobApplicationsByProviderEmail(widget.providerEmail);


    return jobApplications;
  }

  Future<void> _openFile(String path) async {
    final result = await OpenFile.open(path);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open file: ${result.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Applications'),
      ),
      body: FutureBuilder<List<JobApplication>>(
        future: _jobApplications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No job applications found.'));
          } else {
            final jobApplications = snapshot.data!;

            return ListView.builder(
              itemCount: jobApplications.length,
              itemBuilder: (context, index) {
                final application = jobApplications[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${application.jobId}', style: Theme.of(context).textTheme.titleMedium),
                        Text('Full Name: ${application.fullName}', style: Theme.of(context).textTheme.bodyLarge),
                        Text('Email: ${application.email}', style: Theme.of(context).textTheme.bodyLarge),
                        Text('Phone: ${application.phone}', style: Theme.of(context).textTheme.bodyLarge),
                        Text('Resume Path: ${application.resumePath}', style: Theme.of(context).textTheme.bodyLarge),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _openFile(application.resumePath),
                          child: Text('Open Resume'),
                        ),
                        Text('Education Level: ${application.educationLevel}', style: Theme.of(context).textTheme.bodyLarge),
                        Text('Work Experience: ${application.workExperience}', style: Theme.of(context).textTheme.bodyLarge),
                        Text('Skills: ${application.skills}', style: Theme.of(context).textTheme.bodyLarge),
                        Text('Consent Given: ${application.consentGiven ? 'Yes' : 'No'}', style: Theme.of(context).textTheme.bodyLarge),
                        Text('Job Provider Email: ${application.jobProviderEmail}', style: Theme.of(context).textTheme.bodyLarge),
                        Text('Job Title: ${application.jobTitle}', style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
