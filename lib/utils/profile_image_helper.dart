import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_profile_image.dart';
import 'dart:typed_data';

class ProfileImageHelper {
  static final ProfileImageHelper _instance = ProfileImageHelper._internal();
  static Database? _database;

  ProfileImageHelper._internal();

  static ProfileImageHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'profile_images.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE profile_images(email TEXT PRIMARY KEY, imageData BLOB)',
        );
      },
      version: 1,
    );
  }

  Future<List<UserProfileImage>> getAllProfileImages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profile_images');

    return List.generate(maps.length, (i) {
      return UserProfileImage.fromMap(maps[i]);
    });
  }

  Future<void> insertProfileImage(UserProfileImage userProfileImage) async {
    final db = await database;
    await db.insert(
      'profile_images',
      userProfileImage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserProfileImage?> getProfileImageByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'profile_images',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserProfileImage.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
