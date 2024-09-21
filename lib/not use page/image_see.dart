import 'package:flutter/material.dart';
import '../utils/profile_image_helper.dart';
import '../models/user_profile_image.dart';

class ImageSeePage extends StatelessWidget {
  const ImageSeePage({Key? key}) : super(key: key);

  Future<List<UserProfileImage>> _fetchProfileImages() async {
    final profileImageHelper = ProfileImageHelper.instance;
    return await profileImageHelper.getAllProfileImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Images'),
      ),
      body: FutureBuilder<List<UserProfileImage>>(
        future: _fetchProfileImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final images = snapshot.data;

          if (images == null || images.isEmpty) {
            return const Center(child: Text('No images found.'));
          }

          return ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              return ListTile(
                title: Text(image.email),
                leading: CircleAvatar(
                  backgroundImage: MemoryImage(image.imageData),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
