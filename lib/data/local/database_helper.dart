import 'package:flutter_task/models/post_model.dart';
import 'package:flutter_task/utils/constants/database_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();

    batch.execute('''
  CREATE TABLE ${DatabaseConstants.postsTable} (
    ${DatabaseConstants.id} INTEGER PRIMARY KEY,
    ${DatabaseConstants.userId} INTEGER NOT NULL,
    ${DatabaseConstants.title} TEXT NOT NULL UNIQUE,
    ${DatabaseConstants.body} TEXT NOT NULL,
    ${DatabaseConstants.isRead} INTEGER NOT NULL DEFAULT 0,
    ${DatabaseConstants.remainingTime} INTEGER NOT NULL
  )
''');

    await batch.commit(noResult: true);
  }

  Future<void> insertPost(PostModel post) async {
    final db = await database;
    await db.insert(
      DatabaseConstants.postsTable,
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPosts(List<PostModel> posts) async {
    final db = await database;
    final batch = db.batch();

    for (var post in posts) {
      batch.insert(
        DatabaseConstants.postsTable,
        post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<PostModel>> getAllPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.postsTable,
    );

    return List.generate(maps.length, (i) {
      return PostModel.fromMap(maps[i]);
    });
  }

  Future<PostModel?> getPost(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.postsTable,
      where: '${DatabaseConstants.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return PostModel.fromMap(maps.first);
  }

  Future<void> updatePost(PostModel post) async {
    final db = await database;
    await db.update(
      DatabaseConstants.postsTable,
      post.toMap(),
      where: '${DatabaseConstants.id} = ?',
      whereArgs: [post.id],
    );
  }

  Future<void> markPostAsRead(int postId) async {
    final db = await database;
    await db.update(
      DatabaseConstants.postsTable,
      {DatabaseConstants.isRead: 1},
      where: '${DatabaseConstants.id} = ?',
      whereArgs: [postId],
    );
  }

  Future<void> updateRemainingTime(int postId, int remainingTime) async {
    final db = await database;
    await db.update(
      DatabaseConstants.postsTable,
      {DatabaseConstants.remainingTime: remainingTime},
      where: '${DatabaseConstants.id} = ?',
      whereArgs: [postId],
    );
  }

  Future<void> clearAllPosts() async {
    final db = await database;
    await db.delete(DatabaseConstants.postsTable);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

