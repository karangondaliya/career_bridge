// utils/feedback_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/feedback.dart'; // Adjust this import to the new UserFeedback class

class FeedbackHelper {
  static final FeedbackHelper _instance = FeedbackHelper._internal();
  factory FeedbackHelper() => _instance;

  FeedbackHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'feedback.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE feedback(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            rating INTEGER,
            suggestions TEXT,
            userEmail TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertFeedback(UserFeedback feedback) async { // Adjust to UserFeedback
    final db = await database;
    await db.insert(
      'feedback',
      feedback.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserFeedback>> getFeedbacks() async { // Adjust to UserFeedback
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('feedback');

    return List.generate(maps.length, (i) {
      return UserFeedback.fromMap(maps[i]); // Adjust to UserFeedback
    });
  }
}
