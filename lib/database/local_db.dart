import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  final tableName = "vehicles";
  LocalDatabase._();

  static final LocalDatabase instance = LocalDatabase._();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _init();

    return _db!;
  }

  Future<Database> _init() async {
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "fleet_local.sqlite");

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        name        TEXT    NOT NULL,
        plate       TEXT    NOT NULL UNIQUE,
        status      TEXT    NOT NULL DEFAULT 'active',
        created_at  TEXT    NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // implement conditions that is needed when you want to get upgrade db on published application
    }
  }

  Future<int> insertVehicle(Map<String, dynamic> vehicle) async {
    final db = await database;

    return db.insert(
      tableName,
      vehicle,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllVehicles() async {
    final db = await database;

    return db.query(tableName, orderBy: "expiring_soon");
  }

  Future<Map<String, dynamic>?> getVehicleById(int id) async {
    final db = await database;
    final rows = await db.query('vehicles', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<int> updateVehicleById(int id, Map<String, dynamic> data) async {
    final db = await database;
    return db.update('vehicles', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteVehicleById(int id) async {
    final db = await database;
    return db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}
