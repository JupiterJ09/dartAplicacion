import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;
  
  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hotel.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, fileName);
    return await openDatabase(
      path,
      version: 2, // Incrementa versión para actualizaciones
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Crear tablas con mejor estructura
    await db.execute('''
      CREATE TABLE tipohabitacion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL UNIQUE,
        descripcion TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    await db.execute('''
      CREATE TABLE cuartos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero TEXT NOT NULL UNIQUE,
        tipohabitacion_id INTEGER NOT NULL,
        disponible INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(tipohabitacion_id) REFERENCES tipohabitacion(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE precios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipohabitacion_id INTEGER NOT NULL,
        por_hora REAL NOT NULL CHECK(por_hora > 0),
        por_dia REAL NOT NULL CHECK(por_dia > 0),
        activo INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(tipohabitacion_id) REFERENCES tipohabitacion(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE solicitudes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cuarto_id INTEGER NOT NULL,
        tipohabitacion_id INTEGER NOT NULL,
        precio_usado REAL NOT NULL,
        horas_totales INTEGER NOT NULL CHECK(horas_totales > 0),
        ingreso_total REAL NOT NULL,
        fecha_inicio TEXT NOT NULL,
        fecha_fin TEXT,
        fecha_solicitud TEXT DEFAULT CURRENT_TIMESTAMP,
        estado TEXT DEFAULT 'activa' CHECK(estado IN ('activa', 'finalizada', 'cancelada')),
        observaciones TEXT,
        FOREIGN KEY(cuarto_id) REFERENCES cuartos(id) ON DELETE CASCADE,
        FOREIGN KEY(tipohabitacion_id) REFERENCES tipohabitacion(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE mantenimiento_historial (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cuarto_id INTEGER NOT NULL,
        fecha_mantenimiento TEXT NOT NULL,
        tipo_mantenimiento TEXT DEFAULT 'general',
        observaciones TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(cuarto_id) REFERENCES cuartos(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE gastos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monto REAL NOT NULL CHECK(monto > 0),
        descripcion TEXT NOT NULL,
        fecha TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    await db.execute('''
      CREATE TABLE ingresos_diarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT UNIQUE NOT NULL,
        total_ingresos REAL DEFAULT 0,
        total_solicitudes INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    await db.execute('''
      CREATE TABLE estadisticas_mensuales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mes TEXT UNIQUE NOT NULL,
        anio INTEGER NOT NULL,
        total_ingresos REAL DEFAULT 0,
        total_gastos REAL DEFAULT 0,
        utilidad REAL GENERATED ALWAYS AS (total_ingresos - total_gastos) STORED,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    // Crear índices para mejor rendimiento
    await db.execute('CREATE INDEX idx_cuartos_disponible ON cuartos(disponible);');
    await db.execute('CREATE INDEX idx_solicitudes_estado ON solicitudes(estado);');
    await db.execute('CREATE INDEX idx_solicitudes_fecha ON solicitudes(fecha_solicitud);');
    await db.execute('CREATE INDEX idx_ingresos_fecha ON ingresos_diarios(fecha);');
    
    // Insertar datos iniciales
    await _insertInitialData(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Manejar actualizaciones de esquema
    if (oldVersion < 2) {
      // Agregar columnas nuevas si es necesario
      try {
        await db.execute('ALTER TABLE cuartos ADD COLUMN created_at TEXT DEFAULT CURRENT_TIMESTAMP;');
        await db.execute('ALTER TABLE solicitudes ADD COLUMN observaciones TEXT;');
      } catch (e) {
        print('Error upgrading database: $e');
      }
    }
  }

  Future<void> _insertInitialData(Database db) async {
    // Insertar tipos de habitación por defecto
    await db.insert('tipohabitacion', {
      'nombre': 'Cabaña',
      'descripcion': 'Cabaña independiente con mayor privacidad'
    });
    
    await db.insert('tipohabitacion', {
      'nombre': 'Cuarto',
      'descripcion': 'Habitación estándar en edificio principal'
    });
  }

  // Método para cerrar la base de datos
  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Método para obtener información de la base de datos
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    final db = await database;
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
    );
    return {
      'path': db.path,
      'version': await db.getVersion(),
      'tables': tables.map((t) => t['name']).toList(),
    };
  }
}