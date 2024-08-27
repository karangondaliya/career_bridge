// import 'package:flutter/material.dart';
// import '../models/job_posting.dart';
// import '../utils/posting_helper.dart';
//
// class CreateJobPostingForm extends StatefulWidget {
//   @override
//   _CreateJobPostingFormState createState() => _CreateJobPostingFormState();
// }
//
// class _CreateJobPostingFormState extends State<CreateJobPostingForm> {
//   final _formKey = GlobalKey<FormState>();
//   String jobTitle = '';
//   String jobDescription = '';
//   String requirements = '';
//   String salary = '';
//
//   void _saveJobPosting() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       String datePosted = DateTime.now().toIso8601String();
//
//       JobPosting newJobPosting = JobPosting(
//         jobTitle: jobTitle,
//         jobDescription: jobDescription,
//         requirements: requirements,
//         salary: salary,
//         datePosted: datePosted,
//       );
//
//       try {
//         await PostingHelper().insertJobPosting(newJobPosting);
//
//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Job posting uploaded successfully!')),
//         );
//
//         // Redirect to dashboard after a short delay
//         Future.delayed(Duration(seconds: 1), () {
//           Navigator.pushReplacementNamed(context, '/dashboard');
//         });
//       } catch (e) {
//         print('Error saving job posting: $e');
//
//         // Show error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to upload job posting')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Job Posting'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Job Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the job title';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   jobTitle = value!;
//                 },
//               ),
//               SizedBox(height: 8),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Job Description'),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the job description';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   jobDescription = value!;
//                 },
//               ),
//               SizedBox(height: 8),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Requirements'),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the job requirements';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   requirements = value!;
//                 },
//               ),
//               SizedBox(height: 8),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Salary(Per Year(Rs.))'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the salary';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   salary = value!;
//                 },
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _saveJobPosting,
//                 child: Text('Post Job'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../models/job_posting.dart';
import '../utils/posting_helper.dart';

class CreateJobPostingForm extends StatefulWidget {
  @override
  _CreateJobPostingFormState createState() => _CreateJobPostingFormState();
}

class _CreateJobPostingFormState extends State<CreateJobPostingForm> {
  final _formKey = GlobalKey<FormState>();
  String jobTitle = '';
  String jobDescription = '';
  String requirements = '';
  String salary = '';

  void _saveJobPosting() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String datePosted = DateTime.now().toIso8601String();

      JobPosting newJobPosting = JobPosting(
        jobTitle: jobTitle,
        jobDescription: jobDescription,
        requirements: requirements,
        salary: salary,
        datePosted: datePosted,
      );

      try {
        await PostingHelper().insertJobPosting(newJobPosting);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Job posting uploaded successfully!')),
        );

        Future.delayed(Duration(milliseconds: 1), () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        });
      } catch (e) {
        print('Error saving job posting: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload job posting')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Job Posting'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildStepper(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.send),
                label: Text('Post Job'),
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

  Widget _buildStepper() {
    return Column(
      children: [
        Text(
          'Step 1 of 4',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          labelText: 'Job Title',
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
          icon: Icons.description,
          maxLines: 3,
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
        _buildSalaryField(),
      ],
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    required IconData icon,
    int maxLines = 1,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildSalaryField() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildTextFormField(
            labelText: 'Salary (in Rs.)',
            icon: Icons.money,
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
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {
              // Optional: Implement a slider or stepper for salary
            },
            child: Text('Auto-Fill'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

