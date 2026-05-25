import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity.dart';
import '../models/sport_category.dart';

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
    await _initializeDefaultCategories();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gps_tracker.db');

    return openDatabase(
      path,
      version: 2,
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

        await db.execute('''
          CREATE TABLE sport_categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            emoji TEXT NOT NULL,
            isCustom INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS sport_categories(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE,
              emoji TEXT NOT NULL,
              isCustom INTEGER NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<void> _initializeDefaultCategories() async {
    final existing = await getAllSportCategories();
    if (existing.isEmpty) {
      final defaultCategories = [
        SportCategory(name: 'Running', emoji: '🏃', isCustom: false),
        SportCategory(name: 'Cycling', emoji: '🚴', isCustom: false),
        SportCategory(name: 'Walking', emoji: '🚶', isCustom: false),
      ];
      for (var category in defaultCategories) {
        await insertSportCategory(category);
      }
    }
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

  // Sport Category methods
  Future<int> insertSportCategory(SportCategory category) async {
    final db = await database;
    try {
      return await db.insert('sport_categories', category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      // Category might already exist
      return 0;
    }
  }

  Future<List<SportCategory>> getAllSportCategories() async {
    final db = await database;
    final result = await db.query('sport_categories', orderBy: 'isCustom ASC, name ASC');
    return result.map((map) => SportCategory.fromMap(map)).toList();
  }

  Future<SportCategory?> getSportCategory(String name) async {
    final db = await database;
    final result = await db.query(
      'sport_categories',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty ? SportCategory.fromMap(result.first) : null;
  }

  Future<void> deleteSportCategory(int id) async {
    final db = await database;
    await db.delete('sport_categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateSportCategory(SportCategory category) async {
    final db = await database;
    await db.update(
      'sport_categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
}
