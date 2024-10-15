import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/job_application.dart';

class ApplicationHelper {
  static final ApplicationHelper instance = ApplicationHelper._init();
  static Database? _database;

  ApplicationHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jobApplications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const jobIdType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL'; // Store consentGiven as 0/1 for SQLite

    await db.execute(''' 
      CREATE TABLE jobApplications (
        jobId $jobIdType,
        fullName $textType,
        email $textType,
        phone $textType,
        resumePath $textType,
        educationLevel $textType,
        workExperience $textType,
        skills $textType,
        consentGiven $boolType,
        jobProviderEmail $textType,
        jobTitle $textType
      )
    ''');
  }

  // Insert a new job application
  Future<int> insertJobApplication(JobApplication application) async {
    final db = await instance.database;
    return await db.insert('jobApplications', application.toMap());
  }

  // Fetch job applications by jobTitle
  Future<List<JobApplication>> getJobApplicationsByJobTitle(String jobTitle) async {
    final db = await instance.database;

    final result = await db.query(
      'jobApplications',
      where: 'jobTitle = ?',
      whereArgs: [jobTitle],
    );

    return result.map((map) => JobApplication.fromMap(map)).toList();
  }

  Future<List<JobApplication>> getAllJobApplications() async {
    final db = await instance.database;

    final result = await db.query('jobApplications');

    return result.map((map) => JobApplication.fromMap(map)).toList();
  }
  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<JobApplication>> getJobApplicationsByProviderEmail(String providerEmail) async {
    final db = await instance.database;

    final result = await db.query(
      'jobApplications',
      where: 'jobProviderEmail = ?',
      whereArgs: [providerEmail],
    );

    return result.map((map) => JobApplication.fromMap(map)).toList();
  }
}
