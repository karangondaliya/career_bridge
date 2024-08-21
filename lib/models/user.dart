class User {
  final String email;
  final String password;
  final String name;
  final String username;
  final String phone;
  final String role;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.username,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'username': username,
      'phone': phone,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
      name: map['name'],
      username: map['username'],
      phone: map['phone'],
      role: map['role'],
    );
  }
}
