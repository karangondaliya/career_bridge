// models/feedback.dart
class UserFeedback {
  final int? id; // Auto-incremented ID
  final int rating;
  final String suggestions;
  final String userEmail;

  UserFeedback({
    this.id,
    required this.rating,
    required this.suggestions,
    required this.userEmail,
  });

  // Convert a UserFeedback object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'suggestions': suggestions,
      'userEmail': userEmail,
    };
  }

  // Convert a Map object into a UserFeedback object
  factory UserFeedback.fromMap(Map<String, dynamic> map) {
    return UserFeedback(
      id: map['id'],
      rating: map['rating'],
      suggestions: map['suggestions'],
      userEmail: map['userEmail'],
    );
  }
}
