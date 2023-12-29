import 'package:qr_scanner/models/qrcode.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:path/path.dart';

class QrCodeDatabase{
  static final QrCodeDatabase instance = QrCodeDatabase._init();

  static Database? _database;

  QrCodeDatabase._init();

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDatabase("qrcode.db");
    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableQrCodes (
    ${QrCodeFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${QrCodeFields.text} TEXT,
    ${QrCodeFields.creationTime} TEXT NOT NULL,
    ${QrCodeFields.type} TEXT NOT NULL
    )
    ''');
  }

  Future<int> create (QrCode qrCode) async {
    final db = await instance.database;
    final id = await db.insert(tableQrCodes, qrCode.toJson());
    return id;
  }

  Future<List<QrCode>> readAllQrCodes() async {
    final db = await instance.database;
    final result = await db.query(tableQrCodes, orderBy: "${QrCodeFields.creationTime} DESC");
    return result.map((json) => QrCode.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}