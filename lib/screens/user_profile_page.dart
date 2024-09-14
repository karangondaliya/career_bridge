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

  bool _isEditing = false; // View and edit modes
  late Future<User?> _userFuture;

  // Variables to store password, username, and role
  String? _password;
  String? _username;
  String? _role;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    // Fetch user data when the widget is initialized
    _userFuture = _fetchUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Fetch user data from the database
  Future<User?> _fetchUser() async {
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getUserByEmail(widget.email);

    if (user != null) {
      // Populate the controllers and store additional user info
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _password = user.password;
      _username = user.username;
      _role = user.role;
    }

    return user;
  }

  // Update the user's data
  Future<void> _updateUser() async {
    final dbHelper = DatabaseHelper();

    // Fetch the existing user to ensure current data is available
    final user = await dbHelper.getUserByEmail(widget.email);

    if (user != null) {
      final updatedUser = User(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _password ?? user.password, // Retain original password
        username: _username ?? user.username, // Retain original username
        role: _role ?? user.role,             // Retain original role
      );

      try {
        await dbHelper.updateUser(updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        setState(() {
          _isEditing = false; // Switch back to view mode after update
        });
      } catch (e) {
        print("Error updating user: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  // Delete the user from the database
  Future<void> _deleteUser() async {
    final dbHelper = DatabaseHelper();
    try {
      await dbHelper.deleteUserByEmail(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile deleted successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/login'); // Redirect to login page
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting profile: $e')),
      );
    }
  }

  // Confirm deletion with an AlertDialog
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete your profile? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
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
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true; // Enable editing mode
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _updateUser, // Save updated data
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isEditing = false; // Cancel editing
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
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                  readOnly: !_isEditing, // Toggle editability
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  readOnly: !_isEditing, // Toggle editability
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                  readOnly: !_isEditing, // Toggle editability
                ),
                const SizedBox(height: 32),

                if (!_isEditing) // Red "Delete Profile" button when not editing
                  const SizedBox(height: 16), // Add space before the button
                if (!_isEditing)
                  ElevatedButton(
                    onPressed: _confirmDelete, // Show delete confirmation dialog
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Set button color to red
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Delete Profile'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
