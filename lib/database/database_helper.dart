import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart'; // logger 패키지 import

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final logger = Logger(); // logger 인스턴스 생성

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            number TEXT NOT NULL UNIQUE
          )
          ''');
      },
    );
  }

  Future<void> insertContact(Map<String, dynamic> contact) async {
    final db = await instance.database;
    try {
      await db.insert('contacts', contact);
    } catch (e) {
      logger.e('데이터 삽입 오류: $e'); // logger 사용
      throw Exception('데이터 삽입 실패');
    }
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await instance.database;
    return await db.query('contacts');
  }

  Future<void> deleteContact(int id) async {
    final db = await instance.database;
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> searchContacts(String query) async {
    final db = await instance.database;
    return await db.query(
      'contacts',
      where: 'name LIKE ? OR number LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
  }
}
