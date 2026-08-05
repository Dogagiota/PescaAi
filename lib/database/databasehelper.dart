import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();


  Future<Database> get database async {

    if (_database != null) return _database!;

    _database = await _initDB('pescai.db');

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

    await db.execute('''
      CREATE TABLE carrinho (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produto TEXT NOT NULL,
        valor REAL NOT NULL
      )
    ''');

  }


  Future<void> adicionarProduto(
      String produto,
      double valor
  ) async {

    final db = await instance.database;

    await db.insert(
      'carrinho',
      {
        'produto': produto,
        'valor': valor,
      },
    );

  }


  Future<List<Map<String,dynamic>>> pegarCarrinho() async {

    final db = await instance.database;

    return await db.query('carrinho');

  }


  Future<void> limparCarrinho() async {

    final db = await instance.database;

    await db.delete('carrinho');

  }

}