// message_model.dart
class MessageModel {
  final int? id; // Primary key (optional for auto-incrementing)
  final String fromEmail;
  final String toEmail;
  final String message;
  final String timestamp;

  MessageModel({
    this.id,
    required this.fromEmail,
    required this.toEmail,
    required this.message,
    required this.timestamp,
  });

  // Convert a MessageModel into a Map (for storing in database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromEmail': fromEmail,
      'toEmail': toEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }

  // Create a MessageModel from a Map (for retrieving from database)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      fromEmail: map['fromEmail'],
      toEmail: map['toEmail'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
