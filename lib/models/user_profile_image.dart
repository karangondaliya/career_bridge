// models/user_profile_image.dart
import 'dart:typed_data';

class UserProfileImage {
  final String email;
  final Uint8List imageData; // Store the image as bytes

  UserProfileImage({required this.email, required this.imageData});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'imageData': imageData,
    };
  }

  static UserProfileImage fromMap(Map<String, dynamic> map) {
    return UserProfileImage(
      email: map['email'],
      imageData: map['imageData'],
    );
  }
}
