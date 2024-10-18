class JobPosting {
  final int? id;
  final String jobTitle;
  final String jobDescription;
  final String requirements;
  final String salary;
  final String datePosted;
  final String providerEmail; // Add this field to track the provider

  JobPosting({
    this.id,
    required this.jobTitle,
    required this.jobDescription,
    required this.requirements,
    required this.salary,
    required this.datePosted,
    required this.providerEmail, // Make this required
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'requirements': requirements,
      'salary': salary,
      'datePosted': datePosted,
      'providerEmail': providerEmail, // Include the provider's email
    };
  }

  factory JobPosting.fromMap(Map<String, dynamic> map) {
    return JobPosting(
      id: map['id'],
      jobTitle: map['jobTitle'],
      jobDescription: map['jobDescription'],
      requirements: map['requirements'],
      salary: map['salary'],
      datePosted: map['datePosted'],
      providerEmail: map['providerEmail'], // Parse the email from map
    );
  }
}
