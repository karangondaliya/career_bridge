import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/message_model.dart';

class MessageHelper {
  static final MessageHelper _instance = MessageHelper._internal();
  static Database? _database;

  MessageHelper._internal();

  static MessageHelper get instance => _instance;

  // Initialize the database
  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'messages.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE messages(id INTEGER PRIMARY KEY AUTOINCREMENT, fromEmail TEXT, toEmail TEXT, message TEXT, timestamp TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Retrieve messages for a specific email
  Future<List<MessageModel>> getMessagesForEmail(String email) async {
    final db = await database; // Await the database
    final List<Map<String, dynamic>> messages = await db.query(
      'messages',
      where: 'toEmail = ?', // Updated to match your column name
      whereArgs: [email],
    );

    // Convert the results to MessageModel objects and return
    return messages.map((msg) => MessageModel.fromMap(msg)).toList();
  }

  // Insert a message into the database
  Future<void> insertMessage(MessageModel message) async {
    final db = await database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all messages from the database
  Future<List<MessageModel>> getMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages');

    return List.generate(maps.length, (i) {
      return MessageModel.fromMap(maps[i]);
    });
  }

  // Delete a message
  Future<void> deleteMessage(int id) async {
    final db = await database;
    await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
