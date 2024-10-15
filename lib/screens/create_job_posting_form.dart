import 'package:flutter/material.dart';
import '../models/job_posting.dart';
import '../utils/posting_helper.dart';
import 'job_provider_dashboard.dart';

class CreateJobPostingForm extends StatefulWidget {
  final JobPosting? job; // Pass job if in edit mode
  final String providerEmail; // Required parameter for provider's email

  CreateJobPostingForm({this.job, required this.providerEmail}); // Make providerEmail required

  @override
  _CreateJobPostingFormState createState() => _CreateJobPostingFormState();
}

class _CreateJobPostingFormState extends State<CreateJobPostingForm> {
  final _formKey = GlobalKey<FormState>();
  String jobTitle = '';
  String jobDescription = '';
  String requirements = '';
  String salary = '';
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    // Check if we're in edit mode
    if (widget.job != null) {
      isEditing = true;
      jobTitle = widget.job!.jobTitle;
      jobDescription = widget.job!.jobDescription;
      requirements = widget.job!.requirements;
      salary = widget.job!.salary;
    }
  }

  void _saveJobPosting() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String datePosted = DateTime.now().toIso8601String();

      JobPosting jobPosting = JobPosting(
        id: isEditing ? widget.job!.id : null, // retain the original ID for editing
        jobTitle: jobTitle,
        jobDescription: jobDescription,
        requirements: requirements,
        salary: salary,
        datePosted: datePosted,
        providerEmail: widget.providerEmail, // Use providerEmail from widget
      );

      try {
        if (isEditing) {
          // Update the existing job posting
          await PostingHelper().updateJobPosting(jobPosting);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Job posting updated successfully!')),
          );
        } else {
          // Create new job posting
          await PostingHelper().insertJobPosting(jobPosting);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Job posting created successfully!')),
          );
        }

        // Redirect to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => JobProviderDashboard(providerEmail: widget.providerEmail),
          ),
        );
      } catch (e) {
        print("Error saving job posting: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving job posting.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Job Posting' : 'Create Job Posting'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                labelText: 'Job Title',
                hintText: 'e.g., Software Engineer',
                initialValue: jobTitle,
                icon: Icons.work_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job title';
                  }
                  return null;
                },
                onSaved: (value) {
                  jobTitle = value!;
                },
              ),
              const SizedBox(height: 8),
              _buildTextFormField(
                labelText: 'Job Description',
                hintText: 'e.g., Develop and maintain software applications.',
                initialValue: jobDescription,
                icon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job description';
                  }
                  return null;
                },
                onSaved: (value) {
                  jobDescription = value!;
                },
              ),
              const SizedBox(height: 8),
              _buildTextFormField(
                labelText: 'Requirements',
                hintText: 'e.g., Bachelor\'s degree in Computer Science.',
                initialValue: requirements,
                icon: Icons.list_alt,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job requirements';
                  }
                  return null;
                },
                onSaved: (value) {
                  requirements = value!;
                },
              ),
              const SizedBox(height: 8),
              _buildTextFormField(
                labelText: 'Salary (in Rs.)',
                hintText: 'e.g., 50000',
                initialValue: salary,
                icon: Icons.money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the salary';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  salary = value!;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text(isEditing ? 'Update Job' : 'Post Job'),
                onPressed: _saveJobPosting,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
