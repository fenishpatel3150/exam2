import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/attendencmodel.dart';

class SQLiteService {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db == null) {
      String path = join(await getDatabasesPath(), 'attendance.db');
      _db = await openDatabase(path, onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE attendance(
            id TEXT PRIMARY KEY,
            studentName TEXT,
            date TEXT,
            isPresent INTEGER
          )
        ''');
      }, version: 1);
    }
    return _db!;
  }

  Future<void> addRecord(AttendanceRecord record) async {
    final db = await getDatabase();
    await db.insert('attendance', record.toMap());
  }

  Future<List<AttendanceRecord>> getRecords() async {
    final db = await getDatabase();
    final maps = await db.query('attendance');
    return maps.map((map) => AttendanceRecord.fromMap(map)).toList();
  }

  Future<void> updateRecord(AttendanceRecord record) async {
    final db = await getDatabase();
    await db.update('attendance', record.toMap(), where: 'id = ?', whereArgs: [record.id]);
  }

  Future<void> deleteRecord(String id) async {
    final db = await getDatabase();
    await db.delete('attendance', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<AttendanceRecord>> filterRecordsByDate(DateTime date) async {
    final db = await getDatabase();
    final maps = await db.query(
      'attendance',
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );
    return maps.map((map) => AttendanceRecord.fromMap(map)).toList();
  }
}
