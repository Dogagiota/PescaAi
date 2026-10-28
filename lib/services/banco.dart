import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    final caminho = join(caminhoBanco, arquivo);

    return openDatabase(
      caminho,
      version: 2,
      onCreate: criarBanco,
      onUpgrade: (db, versaoAntiga, versaoNova) async {
        if (versaoAntiga < 2) {
          await db.execute('''
        CREATE TABLE IF NOT EXISTS usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          email TEXT NOT NULL COLLATE NOCASE UNIQUE,
          senha_hash TEXT NOT NULL,
          salt TEXT NOT NULL,
          tipo TEXT NOT NULL
            CHECK (tipo IN ('cliente', 'vendedor'))
        )
      ''');
        }
      },
    );
  }

  Future<void> criarBanco(Database db, int version) async {
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

    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL COLLATE NOCASE UNIQUE,
        senha_hash TEXT NOT NULL,
        salt TEXT NOT NULL,
        tipo TEXT NOT NULL
          CHECK (tipo IN ('cliente', 'vendedor'))
      )
    ''');
  }

  String _gerarSalt() {
    final random = Random.secure();

    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    return base64UrlEncode(bytes);
  }

  String _hashSenha(String senha, String salt) {
    return sha256.convert(utf8.encode('$salt:$senha')).toString();
  }

  Future<int> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String tipo,
  }) async {
    if (tipo != 'cliente' && tipo != 'vendedor') {
      throw ArgumentError('Tipo de conta inválido.');
    }

    final db = await database;
    final salt = _gerarSalt();

    return db.insert('usuarios', {
      'nome': nome.trim(),
      'email': email.trim().toLowerCase(),
      'senha_hash': _hashSenha(senha, salt),
      'salt': salt,
      'tipo': tipo,
    });
  }

  Future<Map<String, dynamic>?> autenticarUsuario({
    required String email,
    required String senha,
    required String tipo,
  }) async {
    final db = await database;

    final usuarios = await db.query(
      'usuarios',
      where: 'email = ? AND tipo = ?',
      whereArgs: [email.trim().toLowerCase(), tipo],
      limit: 1,
    );

    if (usuarios.isEmpty) return null;

    final usuario = usuarios.first;
    final salt = usuario['salt'] as String;
    final hashSalvo = usuario['senha_hash'] as String;
    final hashInformado = _hashSenha(senha, salt);

    if (hashInformado != hashSalvo) return null;

    return {
      'id': usuario['id'],
      'nome': usuario['nome'],
      'email': usuario['email'],
      'tipo': usuario['tipo'],
    };
  }

  Future<void> adicionarCompra(List itens, double total) async {
    final db = await database;

    await db.transaction((txn) async {
      final compraId = await txn.insert('compras', {
        'valor': total,
        'data': DateTime.now().toString(),
      });

      for (final item in itens) {
        await txn.insert('itens_compra', {
          'compra_id': compraId,
          'produto': item['produto'],
          'valor': item['valor'],
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> listarCompras() async {
    final db = await database;

    final compras = await db.query('compras', orderBy: 'id DESC');

    final resultado = <Map<String, dynamic>>[];

    for (final compra in compras) {
      final itens = await db.query(
        'itens_compra',
        where: 'compra_id = ?',
        whereArgs: [compra['id']],
      );

      resultado.add({...compra, 'itens': itens});
    }

    return resultado;
  }

  Future<void> adicionarProduto(
    String nome,
    String categoria,
    String descricao,
    double preco,
  ) async {
    final db = await database;

    await db.insert('produtos', {
      'nome': nome,
      'categoria': categoria,
      'descricao': descricao,
      'preco': preco,
    });
  }

  Future<List<Map<String, dynamic>>> listarProdutos() async {
    final db = await database;

    return db.query('produtos', orderBy: 'id DESC');
  }

  Future<void> editarProduto(
    int id,
    String nome,
    String categoria,
    String descricao,
    double preco,
  ) async {
    final db = await database;

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

  Future<void> excluirProduto(int id) async {
    final db = await database;

    await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }
}
