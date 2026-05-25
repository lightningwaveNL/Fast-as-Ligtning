import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<void> init() async {
    await database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gps_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE activities(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            startTime TEXT NOT NULL,
            endTime TEXT,
            totalDistance REAL NOT NULL,
            averageSpeed REAL NOT NULL,
            caloriesBurned INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertActivity(Activity activity) async {
    final db = await database;
    return await db.insert('activities', activity.toMap());
  }

  Future<List<Activity>> getAllActivities() async {
    final db = await database;
    final result = await db.query('activities', orderBy: 'startTime DESC');
    return result.map((map) => Activity.fromMap(map)).toList();
  }

  Future<Activity?> getActivity(int id) async {
    final db = await database;
    final result = await db.query(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Activity.fromMap(result.first) : null;
  }

  Future<void> deleteActivity(int id) async {
    final db = await database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('activities');
  }
}
