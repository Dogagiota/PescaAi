import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Banco {

  static final Banco instance = Banco._init();

  static Database? _database;


  Banco._init();



  Future<Database> get database async {

    if (_database != null) return _database!;

    _database = await _initDB('pescai.db');

    return _database!;

  }

  Future<Database> _initDB(String arquivo) async {

    final caminhoBanco = await getDatabasesPath();

    final caminho = join(
      caminhoBanco,
      arquivo,
    );


    return await openDatabase(

      caminho,

      version: 1,

      onCreate: criarBanco,

    );

  }



  Future<void> criarBanco(
    Database db,
    int version,
  ) async {


    await db.execute('''

      CREATE TABLE compras (

        id INTEGER PRIMARY KEY AUTOINCREMENT,

        produto TEXT NOT NULL,

        valor REAL NOT NULL,

        data TEXT NOT NULL

      )

    ''');


  }



  Future<void> adicionarCompra(
    String produto,
    double valor,
  ) async {


    final db = await instance.database;


    await db.insert(

      'compras',

      {

        'produto': produto,

        'valor': valor,

        'data': DateTime.now().toString(),

      },

    );


  }



  Future<List<Map<String,dynamic>>> listarCompras() async {

    final db = await instance.database;


    return await db.query(

      'compras',

      orderBy: 'id DESC',

    );

  }


}