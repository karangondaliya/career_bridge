class JobApplication {
  final int? jobId; // jobId is nullable as it will be auto-generated in the database
  final String fullName;
  final String email;
  final String phone;
  final String resumePath;
  final String educationLevel;
  final String workExperience;
  final String skills;
  final bool consentGiven;
  final String jobProviderEmail; // Job provider's email
  final String jobTitle; // Job title instead of postId

  JobApplication({
    this.jobId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.resumePath,
    required this.educationLevel,
    required this.workExperience,
    required this.skills,
    required this.consentGiven,
    required this.jobProviderEmail,
    required this.jobTitle,
  });

  // Convert a JobApplication object into a Map object for storage
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'resumePath': resumePath,
      'educationLevel': educationLevel,
      'workExperience': workExperience,
      'skills': skills,
      'consentGiven': consentGiven ? 1 : 0,
      'jobProviderEmail': jobProviderEmail,
      'jobTitle': jobTitle, // Updated here
    };
  }

  // Convert a Map object back into a JobApplication object
  factory JobApplication.fromMap(Map<String, dynamic> map) {
    return JobApplication(
      jobId: map['jobId'],
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      resumePath: map['resumePath'],
      educationLevel: map['educationLevel'],
      workExperience: map['workExperience'],
      skills: map['skills'],
      consentGiven: map['consentGiven'] == 1,
      jobProviderEmail: map['jobProviderEmail'],
      jobTitle: map['jobTitle'], // Updated here
    );
  }
}
