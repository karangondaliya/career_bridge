class UserProfile {
  final String userEmail;
  final String? address;
  final String? dateOfBirth;
  final String? bio;
  final String? profilePictureUrl;
  final String? gender;
  final String? location;
  final Map<String, String>? socialMediaLinks;
  final String? skills;

  UserProfile({
    required this.userEmail,
    this.address,
    this.dateOfBirth,
    this.bio,
    this.profilePictureUrl,
    this.gender,
    this.location,
    this.socialMediaLinks,
    this.skills,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_email': userEmail,
      'address': address,
      'date_of_birth': dateOfBirth,
      'bio': bio,
      'profile_picture_url': profilePictureUrl,
      'gender': gender,
      'location': location,
      'social_media_links': socialMediaLinks != null
          ? socialMediaLinks!.entries.map((e) => '${e.key}: ${e.value}').join(', ')
          : null,
      'skills': skills,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userEmail: map['user_email'],
      address: map['address'],
      dateOfBirth: map['date_of_birth'],
      bio: map['bio'],
      profilePictureUrl: map['profile_picture_url'],
      gender: map['gender'],
      location: map['location'],
      socialMediaLinks: map['social_media_links'] != null
          ? map['social_media_links'].split(', ').asMap().map((i, v) {
        final parts = v.split(': ');
        return MapEntry(parts[0], parts[1]);
      })
          : null,
      skills: map['skills'],
    );
  }
}