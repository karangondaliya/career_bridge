import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../../utils/application_helper.dart';
import '../../models/job_application.dart';

class JobApplicationsPage extends StatefulWidget {
  final String providerEmail; // Add this to accept email

  JobApplicationsPage({required this.providerEmail}); // Constructor accepting email

  @override
  _JobApplicationsPageState createState() => _JobApplicationsPageState();
}

// This is a must in the code
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
    // Pass the email to fetch only the relevant applications
    _jobApplications = _fetchJobApplications(widget.providerEmail);
  }

  Future<List<JobApplication>> _fetchJobApplications(String providerEmail) async {
    final applicationHelper = ApplicationHelper.instance;
    final allApplications = await applicationHelper.getAllJobApplications();

    // Filter applications by provider email
    return allApplications.where((application) => application.jobProviderEmail == providerEmail).toList();
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
        title: Text('Job Applications', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<JobApplication>>(
        future: _jobApplications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red, fontSize: 16)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No job applications found for ${widget.providerEmail}.', style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          } else {
            final jobApplications = snapshot.data!;

            return ListView.builder(
              itemCount: jobApplications.length,
              itemBuilder: (context, index) {
                final application = jobApplications[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              application.jobTitle,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.work_outline, color: Colors.deepPurple),
                          ],
                        ),
                        Divider(thickness: 1, height: 20),

                        // Name and Contact Information
                        _buildInfoRow(Icons.person, 'Full Name', application.fullName),
                        _buildInfoRow(Icons.email, 'Email', application.email),
                        _buildInfoRow(Icons.phone, 'Phone', application.phone),

                        // Resume and Opening Button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onTap: () => _openFile(application.resumePath),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Open Resume',
                                    style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.picture_as_pdf, color: Colors.deepPurple),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Education, Skills and Other Details
                        _buildInfoRow(Icons.school, 'Education Level', application.educationLevel),
                        _buildInfoRow(Icons.work, 'Work Experience', application.workExperience),
                        _buildInfoRow(Icons.star, 'Skills', application.skills),
                        _buildInfoRow(Icons.check_circle_outline, 'Consent Given', application.consentGiven == 1 ? 'Yes' : 'No'),
                        _buildInfoRow(Icons.email_outlined, 'Job Provider Email', application.jobProviderEmail),
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

  // Helper method to build rows for the job application details
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
