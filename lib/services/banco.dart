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
      version: 3,
      onCreate: criarBanco,
      onUpgrade: atualizarBanco,
    );
  }

  Future<void> criarBanco(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE compras (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        valor REAL NOT NULL,
        data TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE itens_compra (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        compra_id INTEGER NOT NULL,
        produto TEXT NOT NULL,
        valor REAL NOT NULL,
        FOREIGN KEY (compra_id) REFERENCES compras(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        categoria TEXT NOT NULL,
        descricao TEXT NOT NULL,
        preco REAL NOT NULL
      )
    ''');
  }

  Future<void> atualizarBanco(
    Database db,
    int versaoAntiga,
    int versaoNova,
  ) async {
    if (versaoAntiga < 2) {
      await db.execute('''
        ALTER TABLE compras RENAME TO compras_antigas
      ''');

      await db.execute('''
        CREATE TABLE compras (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          valor REAL NOT NULL,
          data TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE itens_compra (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          compra_id INTEGER NOT NULL,
          produto TEXT NOT NULL,
          valor REAL NOT NULL,
          FOREIGN KEY (compra_id) REFERENCES compras(id)
        )
      ''');

      final comprasAntigas = await db.query('compras_antigas');

      for (var compra in comprasAntigas) {
        final compraId = await db.insert(
          'compras',
          {
            'valor': compra['valor'],
            'data': compra['data'],
          },
        );

        await db.insert(
          'itens_compra',
          {
            'compra_id': compraId,
            'produto': compra['produto'],
            'valor': compra['valor'],
          },
        );
      }

      await db.execute('DROP TABLE compras_antigas');
    }

    if (versaoAntiga < 3) {
      await db.execute('''
        CREATE TABLE produtos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          categoria TEXT NOT NULL,
          descricao TEXT NOT NULL,
          preco REAL NOT NULL
        )
      ''');
    }
  }

  Future<void> adicionarCompra(
    List itens,
    double total,
  ) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      final compraId = await txn.insert(
        'compras',
        {
          'valor': total,
          'data': DateTime.now().toString(),
        },
      );

      for (var item in itens) {
        await txn.insert(
          'itens_compra',
          {
            'compra_id': compraId,
            'produto': item['produto'],
            'valor': item['valor'],
          },
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> listarCompras() async {
    final db = await instance.database;

    final compras = await db.query(
      'compras',
      orderBy: 'id DESC',
    );

    List<Map<String, dynamic>> resultado = [];

    for (var compra in compras) {
      final itens = await db.query(
        'itens_compra',
        where: 'compra_id = ?',
        whereArgs: [compra['id']],
      );

      resultado.add({
        ...compra,
        'itens': itens,
      });
    }

    return resultado;
  }
 // PRODUTOS

  // CREATE
  Future<void> adicionarProduto(
    String nome,
    String categoria,
    String descricao,
    double preco,
  ) async {
    final db = await instance.database;

    await db.insert(
      'produtos',
      {
        'nome': nome,
        'categoria': categoria,
        'descricao': descricao,
        'preco': preco,
      },
    );
  }

  // READ
  Future<List<Map<String, dynamic>>> listarProdutos() async {
    final db = await instance.database;

    return await db.query(
      'produtos',
      orderBy: 'id DESC',
    );
  }

  // UPDATE
  Future<void> editarProduto(
    int id,
    String nome,
    String categoria,
    String descricao,
    double preco,
  ) async {
    final db = await instance.database;

    await db.update(
      'produtos',
      {
        'nome': nome,
        'categoria': categoria,
        'descricao': descricao,
        'preco': preco,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<void> excluirProduto(
    int id,
  ) async {
    final db = await instance.database;

    await db.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}