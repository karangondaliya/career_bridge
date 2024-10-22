import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import '../utils/application_helper.dart';
import '../models/job_application.dart';
import '../utils/database_helper.dart';
import 'job_provider/job_applications_page.dart'; // Import your DatabaseHelper


enum ResultType {
  done,
  error,
  canceled,
}
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

  String? _emailErrorMessage; // To store error message for email validation
  FocusNode _emailFocusNode = FocusNode(); // Focus node for email field

  final List<String> _educationLevels = [
    '10th Pass',
    '12th Pass',
    'BTech',
    'MTech',
    'PhD',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    // Add a listener to the email focus node to detect when the email field loses focus
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _validateEmail();
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _workExperienceController.dispose();
    _skillsController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

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
                focusNode: _emailFocusNode, // Attach the focus node to the email field
                errorMessage: _emailErrorMessage, // Display the error message if any
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
                  Expanded( // Wrap the Text widget with Expanded to prevent overflow
                    child: Text(
                      'I agree to the terms and conditions and consent to store my information',
                      softWrap: true, // Ensures text wraps to the next line
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
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (_consentGiven) {
                _checkEmailAndSubmit(); // Validate email before submitting
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please agree to the terms and conditions')),
                );
              }
            }
          },
          child: const Text('Submit'),
        ),

      ],
    );
  }

  // Check email existence and proceed with submission
  Future<void> _validateEmail() async {
    final email = _emailController.text;

    // Access database to check email
    final user = await DatabaseHelper().getUserByEmail(email);

    setState(() {
      if (user == null) {
        _emailErrorMessage = 'Please use a valid Career Bridge email.';
      } else {
        _emailErrorMessage = null;
      }
    });
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? errorMessage, // Error message to be displayed
    FocusNode? focusNode, // Optional focus node
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          focusNode: focusNode, // Attach the focus node if provided
          decoration: InputDecoration(
            labelText: label,
            errorText: errorMessage, // Display error message if present
          ),
          validator: validator,
          maxLines: maxLines,
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
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

  void _checkEmailAndSubmit() async {
    final email = _emailController.text;

    // Access database to check email
    final user = await DatabaseHelper().getUserByEmail(email);

    if (user == null) {
      // Email not found, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please use an application email to submit your application.')),
      );
    } else {
      // Email found, proceed with application submission
      _submitApplication();
    }
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
      jobTitle: widget.jobTitle,
    );

    // Insert into the database
    await ApplicationHelper.instance.insertJobApplication(newApplication);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Application submitted for ${widget.jobTitle}')),
    );
    Navigator.of(context).pop();
  }
}
