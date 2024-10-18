import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/job_posting.dart';

class PostingHelper {
  static final PostingHelper _instance = PostingHelper._internal();

  factory PostingHelper() => _instance;

  PostingHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'job_postings.db');




    // Create a new database with the updated schema
    return openDatabase(
      path,
      version: 1, // Set to 1 since we’re not handling upgrades
      onCreate: (db, version) async {
        await db.execute(
            '''
          CREATE TABLE job_postings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            jobTitle TEXT,
            jobDescription TEXT,
            requirements TEXT,
            salary TEXT,
            datePosted TEXT,
            providerEmail TEXT
          )
          '''
        );
        print('Job postings table created');
      },
    );
  }

  Future<int> insertJobPosting(JobPosting jobPosting) async {
    final db = await database;
    try {
      return await db.insert(
        'job_postings',
        jobPosting.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting job posting: $e");
      rethrow;
    }
  }

  Future<List<JobPosting>> getJobPostings() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('job_postings');
      return List.generate(maps.length, (i) {
        return JobPosting.fromMap(maps[i]);
      });
    } catch (e) {
      print("Error retrieving job postings: $e");
      return [];
    }
  }

  Future<int> updateJobPosting(JobPosting jobPosting) async {
    final db = await database;
    try {
      return await db.update(
        'job_postings',
        jobPosting.toMap(),
        where: 'id = ?',
        whereArgs: [jobPosting.id],
      );
    } catch (e) {
      print("Error updating job posting: $e");
      rethrow;
    }
  }

  Future<int> deleteJobPosting(int id) async {
    final db = await database;
    try {
      return await db.delete(
        'job_postings',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting job posting: $e");
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await database;
    try {
      await db.close();
      _database = null; // Ensure the reference is cleared after closing
    } catch (e) {
      print("Error closing database: $e");
      rethrow;
    }
  }

  Future<List<JobPosting>> getJobPostingsByProvider(String providerEmail) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'job_postings',
        where: 'providerEmail = ?',
        whereArgs: [providerEmail],
      );
      return List.generate(maps.length, (i) {
        return JobPosting.fromMap(maps[i]);
      });
    } catch (e) {
      print("Error retrieving job postings by provider: $e");
      return [];
    }
  }
}
