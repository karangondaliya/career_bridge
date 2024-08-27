class JobPosting {
  final int? id;
  final String jobTitle;
  final String jobDescription;
  final String requirements;
  final String salary;
  final String datePosted;

  JobPosting({
    this.id,
    required this.jobTitle,
    required this.jobDescription,
    required this.requirements,
    required this.salary,
    required this.datePosted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'requirements': requirements,
      'salary': salary,
      'datePosted': datePosted,
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
    );
  }
}
