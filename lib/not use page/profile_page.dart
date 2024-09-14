// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class ProfilePage extends StatefulWidget {
//   final String userEmail;
//
//   const ProfilePage({Key? key, required this.userEmail}) : super(key: key);
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Or ImageSource.camera
//
//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         backgroundColor: Colors.lightBlueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 CircleAvatar(
//                   radius: 80,
//                   backgroundImage: _profileImage != null
//                       ? FileImage(_profileImage!)
//                       : AssetImage('assets/default_profile.png') as ImageProvider,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.edit, color: Colors.blueAccent),
//                   onPressed: _pickImage,
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Text(
//               widget.userEmail,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
