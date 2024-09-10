import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_profile.dart';

class UserProfileDatabaseHelper {
  static final _databaseName = "UserProfileDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'user_profiles';

  static final columnUserEmail = 'user_email';
  static final columnAddress = 'address';
  static final columnDateOfBirth = 'date_of_birth';
  static final columnBio = 'bio';
  static final columnProfilePictureUrl = 'profile_picture_url';
  static final columnGender = 'gender';
  static final columnLocation = 'location';
  static final columnSocialMediaLinks = 'social_media_links';
  static final columnSkills = 'skills';

  UserProfileDatabaseHelper._privateConstructor();
  static final UserProfileDatabaseHelper instance = UserProfileDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnUserEmail TEXT PRIMARY KEY,
        $columnAddress TEXT,
        $columnDateOfBirth TEXT,
        $columnBio TEXT,
        $columnProfilePictureUrl TEXT,
        $columnGender TEXT,
        $columnLocation TEXT,
        $columnSocialMediaLinks TEXT,
        $columnSkills TEXT
      )
    ''');
    print('User profiles table created');
  }

  Future<int> insertUserProfile(UserProfile profile) async {
    final db = await database;
    return await db.insert(table, profile.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserProfile?> getUserProfileByEmail(String email) async {
    final db = await database;
    final maps = await db.query(table, where: '$columnUserEmail = ?', whereArgs: [email]);

    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateUserProfile(UserProfile profile) async {
    final db = await database;
    return await db.update(
      table,
      profile.toMap(),
      where: '$columnUserEmail = ?',
      whereArgs: [profile.userEmail],
    );
  }

  Future<int> deleteUserProfile(String email) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnUserEmail = ?',
      whereArgs: [email],
    );
  }
}
