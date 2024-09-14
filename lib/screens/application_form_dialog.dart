import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import '../utils/application_helper.dart';
import '../models/job_application.dart';

class ApplicationFormDialog extends StatefulWidget {
  final String jobTitle;
  final String providerEmail;

  const ApplicationFormDialog({
    Key? key,
    required this.jobTitle,
    required this.providerEmail,
  }) : super(key: key);

  @override
  _ApplicationFormDialogState createState() => _ApplicationFormDialogState();
}

enum ResultType {
  done,
  error,
  canceled,
}

class _ApplicationFormDialogState extends State<ApplicationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _resumePath;
  String? _educationLevel;
  final _workExperienceController = TextEditingController();
  final _skillsController = TextEditingController();
  bool _consentGiven = false;

  final List<String> _educationLevels = [
    '10th Pass',
    '12th Pass',
    'BTech',
    'MTech',
    'PhD',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Apply for Job'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Applying for: ${widget.jobTitle}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _fullNameController,
                label: 'Full Name',
                validator: (value) => value == null || value.isEmpty ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _emailController,
                label: 'Email Address',
                validator: (value) => value == null || value.isEmpty ? 'Please enter your email address' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _phoneController,
                label: 'Phone Number',
                validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 16),
              _buildFilePicker(
                label: 'Resume',
                filePath: _resumePath,
                onFilePicked: (String? path) {
                  setState(() {
                    _resumePath = path;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _educationLevel,
                hint: const Text('Select Highest Level of Education'),
                items: _educationLevels.map((level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _educationLevel = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select your highest level of education' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _workExperienceController,
                label: 'Work Experience',
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your work experience' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _skillsController,
                label: 'Skills',
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your key skills' : null,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _consentGiven,
                    onChanged: (bool? value) {
                      setState(() {
                        _consentGiven = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'I agree to the terms and conditions and consent to store my information',
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (_consentGiven) {
                _submitApplication();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please agree to the terms and conditions')),
                );
              }
            }
          },
          child: const Text('Submit'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }

  Widget _buildFilePicker({
    required String label,
    required String? filePath,
    required void Function(String?) onFilePicked,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                if (result != null && result.files.isNotEmpty) {
                  onFilePicked(result.files.single.path);
                }
              },
              child: const Text('Choose File'),
            ),
          ],
        ),
        if (filePath != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () async {
                final result = await OpenFile.open(filePath!);
                if (result.type == ResultType.done) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('File opened successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to open file: ${result.message}')),
                  );
                }
              },
              child: Text(
                'Selected file: ${filePath.split('/').last}',
                style: const TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ),
      ],
    );
  }

  void _submitApplication() async {
    final fullName = _fullNameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final resumePath = _resumePath;
    final educationLevel = _educationLevel;
    final workExperience = _workExperienceController.text;
    final skills = _skillsController.text;

    if (resumePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a resume')),
      );
      return;
    }

    final newApplication = JobApplication(
      fullName: fullName,
      email: email,
      phone: phone,
      resumePath: resumePath!,
      educationLevel: educationLevel!,
      workExperience: workExperience,
      skills: skills,
      consentGiven: _consentGiven,
      jobProviderEmail: widget.providerEmail,
      jobTitle: widget.jobTitle, // Updated here
    );

    // Insert into the database
    await ApplicationHelper.instance.insertJobApplication(newApplication);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Application submitted for ${widget.jobTitle}')),
    );
    Navigator.of(context).pop();
  }
}
