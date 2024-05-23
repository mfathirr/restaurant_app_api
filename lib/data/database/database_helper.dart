import 'package:path/path.dart';
import 'package:restaurant_app_api/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(join(path, 'restaurant_db.db'),
        onCreate: (db, version) async {
      await db.execute(
        '''CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL)''',
      );
    }, version: 1);
    return db;
  }

  Future<void> insertFavorite(RestaurantElement note) async {
    final Database db = await database;
    await db.insert(_tableName, note.toJson());
    print('Data saved');
  }

  Future<List<RestaurantElement>> getFavorites() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => RestaurantElement.fromJson(res)).toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results =
        await db.query(_tableName, where: 'id=?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> deleteFavorite(String id) async {
    final Database db = await database;

    await db.delete(_tableName, where: 'id=?', whereArgs: [id]);
    print('delete success');
  }
}
