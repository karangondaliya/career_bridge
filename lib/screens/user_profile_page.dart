import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/database_helper.dart';

class UserProfilePage extends StatefulWidget {
  final String email; // Pass email as a parameter

  const UserProfilePage({required this.email, super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isEditing = false; // To toggle between view and edit modes

  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    // Fetch user data
    _userFuture = _fetchUser();
  }

  @override
  void dispose() {
    // Dispose controllers
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
    }

    return user;
  }

  Future<void> _updateUser() async {
    final updatedUser = User(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: '', // Do not update password
      username: '', // Not used here
      role: '', // Not used here
    );

    final dbHelper = DatabaseHelper();
    try {
      await dbHelper.updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      setState(() {
        _isEditing = false; // Switch back to view mode
      });
    } catch (e) {
      print("Error updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  Future<void> _deleteUser() async {
    final dbHelper = DatabaseHelper();
    try {
      await dbHelper.deleteUserByEmail(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile deleted successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/login'); // Redirect to login page
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting profile: $e')),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete your profile? This action cannot be undone.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteUser(); // Proceed with deletion
              },
            ),
          ],
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
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true; // Switch to edit mode
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _updateUser,
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isEditing = false; // Switch back to view mode
                });
                _fetchUser(); // Refresh data to discard unsaved changes
              },
            ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final user = snapshot.data;

          if (user == null) {
            return Center(child: Text('No user data found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'User Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                  readOnly: !_isEditing, // Toggle editability
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  readOnly: !_isEditing, // Toggle editability
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                  readOnly: !_isEditing, // Toggle editability
                ),
                SizedBox(height: 32),

                if (!_isEditing) // Red "Delete Profile" button
                  SizedBox(height: 16), // Add some space before the button
                if (!_isEditing)
                  ElevatedButton(
                    onPressed: _confirmDelete, // Show delete confirmation dialog
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Set button color to red
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text('Delete Profile'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
