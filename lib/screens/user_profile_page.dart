import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';
import '../models/user_profile_image.dart';
import '../utils/database_helper.dart';
import '../utils/profile_image_helper.dart';
import 'login_page.dart';

class UserProfilePage extends StatefulWidget {
  final String email;

  const UserProfilePage({required this.email, super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isEditing = false;
  late Future<User?> _userFuture;
  late Future<UserProfileImage?> _profileImageFuture;

  String? _password;
  String? _username;
  String? _role;
  Uint8List? _profileImageData;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    _userFuture = _fetchUser();
    _profileImageFuture = _fetchProfileImage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<User?> _fetchUser() async {
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getUserByEmail(widget.email);

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _password = user.password;
      _username = user.username;
      _role = user.role;
    }

    return user;
  }

  Future<UserProfileImage?> _fetchProfileImage() async {
    final profileImage = await ProfileImageHelper.instance.getProfileImageByEmail(widget.email);
    if (profileImage != null) {
      setState(() {
        _profileImageData = profileImage.imageData; // Store image data
      });
    }
    return profileImage;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImageData = bytes; // Store the image data as bytes
      });
    }
  }

  Future<void> _updateUser() async {
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getUserByEmail(widget.email);

    if (user != null) {
      final updatedUser = User(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _password ?? user.password,
        username: _username ?? user.username,
        role: _role ?? user.role,
      );

      try {
        await dbHelper.updateUser(updatedUser);
        if (_profileImageData != null) {
          await ProfileImageHelper.instance.insertProfileImage(
            UserProfileImage(email: widget.email, imageData: _profileImageData!),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        setState(() {
          _isEditing = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }
  Future<void> _deleteUser() async {
    final dbHelper = DatabaseHelper();
    try {
      await dbHelper.deleteUserByEmail(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile deleted successfully!')),
      );
      // Redirect to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting profile: $e')),
      );
    }
  }
  void _confirmDeleteUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete your profile? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _deleteUser(); // Call the delete user function
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _updateUser,
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
                _fetchUser();
                _fetchProfileImage(); // Refresh image
              },
            ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('No user data found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'User Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    _showImagePicker(context);
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _profileImageData != null
                        ? MemoryImage(_profileImageData!)
                        : null,
                    child: _profileImageData == null
                        ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                  readOnly: !_isEditing,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  readOnly: !_isEditing,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                  readOnly: !_isEditing,
                ),
                const SizedBox(height: 32),
                if (!_isEditing)
                  ElevatedButton(
                    onPressed: _confirmDeleteUser, // Call confirm delete
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Delete Account'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
