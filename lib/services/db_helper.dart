import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    String path = join(await getDatabasesPath(), 'app.db');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);

    return _database!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos (
        id INTEGER PRIMARY KEY,
        clave TEXT,
        tendencia TEXT,
        familiaOlfativa TEXT,
        notaPrincipal TEXT,
        diaNoche TEXT,
        genero TEXT,
        estatus TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE categoria (
        id INTEGER PRIMARY KEY,
        idvariable INTEGER,
        nombre TEXT,
        ruta TEXT,
        estatus TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE pedidos (
        id INTEGER PRIMARY KEY,
        idTicket INTEGER,
        idproducto INTEGER,
        clave TEXT,
        tendencia TEXT,
        presentacion TEXT,
        genero TEXT,
        cantidad INTEGER,
        precio REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE ticket (
        id INTEGER PRIMARY KEY,
        idTicket INTEGER,
        idpedido INTEGER,
        cantidad INTEGER,
        precioUnitario REAL,
        subtotal REAL,
        total REAL
      )
    ''');
  }

  //CREATE
  static Future<void> clearAndInsertProd(List<dynamic> varia) async {
    final db = await database;

    // Borrar los datos actuales
    await db.delete('productos');

    // Insertar nuevos datos
    for (var prod in varia) {
      await db.insert('productos', {
        'id': prod['id'],
        'clave': prod['clave'],
        'tendencia': prod['tendencia'],
        'familiaOlfativa': prod['familiaOlfativa'],
        'notaPrincipal': prod['notaPrincipal'],
        'diaNoche': prod['diaNoche'],
        'genero': prod['genero'],
        'estatus': prod['estatus'],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<void> AddPedido(List<dynamic> pedido, int idTicket) async {
    final db = await database;
    // Insertar nuevos datos
    for (var ac in pedido) {
      await db.insert('pedidos', {
        'idTicket': idTicket,
        'idproducto': ac['idproducto'],
        'clave': ac['clave'],
        'tendencia': ac['tendencia'],
        'presentacion': ac['presentacion'],
        'genero': ac['genero'],
        'cantidad': ac['cantidad'],
        'precio': ac['precio'],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<int> AddTicket(int cantidad, double st, double total) async {
    final db = await database;

    final id = await db.insert('ticket', {
      'cantidad': cantidad,
      'precioUnitario': 0,
      'subtotal': st,
      'total': total,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    return id; // 👈 aquí regresas el ID insertado
  }

  //READ
  static Future<List<Map<String, dynamic>>> getProductosDB() async {
    final db = await database;
    return await db.query('productos');
  }

  static Future<Map<String, dynamic>?> getVariableById(int id) async {
    final db = await database;

    final result = await db.query(
      'variables',
      columns: ['nombre', 'icono'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first; // contiene {'nombre': ..., 'icono': ...}
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getPedidosDB() async {
    final db = await database;
    final result = await db.query(
      'pedidos',
      columns: [
        'id',
        'idproducto',
        'clave',
        'tendencia',
        'presentacion',
        'genero',
        'cantidad',
        'precio',
      ],
    );
    return result; // devuelve la lista completa
  }

  static Future<List<Map<String, dynamic>>> getTicketDB() async {
    final db = await database;
    final result = await db.query(
      'ticket',
      columns: ['id', 'cantidad', 'total'],
    );
    return result; // devuelve la lista completa
  }

  static Future<int> deletePedido(int id) async {
    final db = await database;
    return await db.delete('pedidos', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteAllPedidos() async {
    final db = await database;
    return await db.delete('pedidos');
  }

  //DELETE
  static Future<void> borrarTablasLocales() async {
    // Abre la base de datos
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'app.db'); // Usa el mismo nombre de tu DB
    final db = await openDatabase(path);

    // Borra todas las tablas
    await db.execute('DROP TABLE IF EXISTS productos');
    await db.execute('DROP TABLE IF EXISTS categorias');

    // Si quieres volver a crearlas vacías, vuelve a crearlas aquí:

    await db.execute('''
    CREATE TABLE productos (
      id INTEGER PRIMARY KEY,
      clave TEXT,
      tendencia TEXT,
      familia_olfativa TEXT,
      nota_principal TEXT,
      dia_noche TEXT,
      genero TEXT,
      estatus TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE categorias (
      id INTEGER PRIMARY KEY,
      idvariable INTEGER,
      nombre TEXT,
      ruta TEXT,
      estatus TEXT
    )
  ''');

    await db.close(); // Cierra la DB
  }
}
