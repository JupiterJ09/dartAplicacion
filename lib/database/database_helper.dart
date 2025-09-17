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
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');

    // TABLA CUARTOS SIMPLIFICADA
    await db.execute('''
      CREATE TABLE cuartos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero TEXT NOT NULL UNIQUE,
        tipo_habitacion TEXT NOT NULL CHECK(tipo_habitacion IN ('cabaña', 'cuarto')),
        precio_por_hora REAL NOT NULL CHECK(precio_por_hora > 0),
        precio_por_dia REAL NOT NULL CHECK(precio_por_dia > 0),
        estado TEXT DEFAULT 'disponible' CHECK(estado IN ('disponible', 'ocupado', 'mantenimiento', 'limpieza')),
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    // TABLA SOLICITUDES SIMPLIFICADA
    await db.execute('''
      CREATE TABLE solicitudes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cuarto_id INTEGER NOT NULL,
        modalidad_pago TEXT NOT NULL CHECK(modalidad_pago IN ('por_hora', 'por_dia', 'personalizado')),
        precio_aplicado REAL NOT NULL CHECK(precio_aplicado > 0),
        horas_totales INTEGER CHECK(horas_totales > 0),
        dias_totales INTEGER CHECK(dias_totales > 0),
        ingreso_total REAL NOT NULL CHECK(ingreso_total > 0),
        fecha_inicio TEXT NOT NULL,
        fecha_fin TEXT,
        fecha_solicitud TEXT DEFAULT CURRENT_TIMESTAMP,
        estado TEXT DEFAULT 'activa' CHECK(estado IN ('activa', 'finalizada')),
        FOREIGN KEY(cuarto_id) REFERENCES cuartos(id) ON DELETE CASCADE
      );
    ''');

    // TABLA MANTENIMIENTO
    await db.execute('''
      CREATE TABLE mantenimiento_historial (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cuarto_id INTEGER NOT NULL,
        fecha_mantenimiento TEXT NOT NULL,
        tipo_mantenimiento TEXT DEFAULT 'general' CHECK(tipo_mantenimiento IN ('general', 'limpieza', 'reparacion', 'preventivo')),
        descripcion TEXT,
        costo REAL DEFAULT 0 CHECK(costo >= 0),
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(cuarto_id) REFERENCES cuartos(id) ON DELETE CASCADE
      );
    ''');

    // TABLA GASTOS
    await db.execute('''
      CREATE TABLE gastos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monto REAL NOT NULL CHECK(monto > 0),
        descripcion TEXT NOT NULL,
        fecha TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    // TABLA INGRESOS DIARIOS
    await db.execute('''
      CREATE TABLE ingresos_diarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT UNIQUE NOT NULL,
        total_ingresos REAL DEFAULT 0 CHECK(total_ingresos >= 0),
        total_solicitudes INTEGER DEFAULT 0 CHECK(total_solicitudes >= 0),
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    // TABLA INGRESOS SEMANALES
    await db.execute('''
      CREATE TABLE ingresos_semanales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        anio INTEGER NOT NULL,
        semana INTEGER NOT NULL,
        fecha_inicio TEXT NOT NULL,
        fecha_fin TEXT NOT NULL,
        total_ingresos REAL DEFAULT 0,
        total_solicitudes INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(anio, semana)
      );
    ''');

    // TABLA ESTADÍSTICAS MENSUALES
    await db.execute('''
      CREATE TABLE estadisticas_mensuales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mes INTEGER NOT NULL CHECK(mes BETWEEN 1 AND 12),
        anio INTEGER NOT NULL CHECK(anio > 2020),
        total_ingresos REAL DEFAULT 0 CHECK(total_ingresos >= 0),
        total_gastos REAL DEFAULT 0 CHECK(total_gastos >= 0),
        utilidad REAL GENERATED ALWAYS AS (total_ingresos - total_gastos) STORED,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(mes, anio)
      );
    ''');

    // ÍNDICES ESENCIALES
    await db.execute('CREATE INDEX idx_cuartos_estado ON cuartos(estado);');
    await db.execute('CREATE INDEX idx_cuartos_tipo ON cuartos(tipo_habitacion);');
    await db.execute('CREATE INDEX idx_solicitudes_estado ON solicitudes(estado);');
    await db.execute('CREATE INDEX idx_solicitudes_cuarto ON solicitudes(cuarto_id);');
    await db.execute('CREATE INDEX idx_solicitudes_fecha ON solicitudes(fecha_solicitud);');

    // INSERTAR DATOS DE PRUEBA
    await _insertTestData(db);
  }

  Future<void> _insertTestData(Database db) async {
    // Cuartos con precios diferenciados
    final cuartos = [
      {'numero': '1', 'tipo': 'cuarto', 'precio_hora': 50.0, 'precio_dia': 400.0, 'estado': 'ocupado'},
      {'numero': '2', 'tipo': 'cuarto', 'precio_hora': 50.0, 'precio_dia': 400.0, 'estado': 'disponible'},
      {'numero': '3', 'tipo': 'cuarto', 'precio_hora': 55.0, 'precio_dia': 450.0, 'estado': 'disponible'},
      {'numero': '4', 'tipo': 'cabaña', 'precio_hora': 80.0, 'precio_dia': 600.0, 'estado': 'disponible'},
      {'numero': '5', 'tipo': 'cabaña', 'precio_hora': 85.0, 'precio_dia': 650.0, 'estado': 'mantenimiento'},
    ];

    for (var cuarto in cuartos) {
      await db.execute('''
        INSERT INTO cuartos (numero, tipo_habitacion, precio_por_hora, precio_por_dia, estado) 
        VALUES (?, ?, ?, ?, ?)
      ''', [
        cuarto['numero'], 
        cuarto['tipo'], 
        cuarto['precio_hora'], 
        cuarto['precio_dia'], 
        cuarto['estado']
      ]);
    }

    // Solicitudes de ejemplo
    await db.execute('''
      INSERT INTO solicitudes (cuarto_id, modalidad_pago, precio_aplicado, horas_totales, ingreso_total, fecha_inicio, estado) 
      VALUES (1, 'por_hora', 50.0, 3, 150.0, datetime('now', '-2 hours'), 'activa')
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE cuartos ADD COLUMN precio_por_dia REAL DEFAULT 400.0;');
        await db.execute('ALTER TABLE solicitudes ADD COLUMN modalidad_pago TEXT DEFAULT \'por_hora\';');
      } catch (e) {
        print('Error upgrading database: $e');
      }
    }
    
    if (oldVersion < 3) {
      try {
        // Crear tabla temporal con nuevo constraint
        await db.execute('''
          CREATE TABLE cuartos_temp (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            numero TEXT NOT NULL UNIQUE,
            tipo_habitacion TEXT NOT NULL CHECK(tipo_habitacion IN ('cabaña', 'cuarto')),
            precio_por_hora REAL NOT NULL CHECK(precio_por_hora > 0),
            precio_por_dia REAL NOT NULL CHECK(precio_por_dia > 0),
            estado TEXT DEFAULT 'disponible' CHECK(estado IN ('disponible', 'ocupado', 'mantenimiento', 'limpieza')),
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
          );
        ''');
        
        // Copiar datos existentes
        await db.execute('''
          INSERT INTO cuartos_temp (id, numero, tipo_habitacion, precio_por_hora, precio_por_dia, estado, created_at)
          SELECT id, numero, tipo_habitacion, precio_por_hora, precio_por_dia, estado, created_at FROM cuartos;
        ''');
        
        // Eliminar tabla antigua y renombrar
        await db.execute('DROP TABLE cuartos;');
        await db.execute('ALTER TABLE cuartos_temp RENAME TO cuartos;');
        
        // Recrear índices
        await db.execute('CREATE INDEX idx_cuartos_estado ON cuartos(estado);');
        await db.execute('CREATE INDEX idx_cuartos_tipo ON cuartos(tipo_habitacion);');
        
        // Crear tabla de ingresos semanales
        await db.execute('''
          CREATE TABLE ingresos_semanales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            anio INTEGER NOT NULL,
            semana INTEGER NOT NULL,
            fecha_inicio TEXT NOT NULL,
            fecha_fin TEXT NOT NULL,
            total_ingresos REAL DEFAULT 0,
            total_solicitudes INTEGER DEFAULT 0,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(anio, semana)
          );
        ''');
      } catch (e) {
        print('Error upgrading database to version 3: $e');
      }
    }
  }

  // FUNCIONES CORREGIDAS QUE USAN DatabaseExecutor
  Future<void> _actualizarIngresosDiarios(DatabaseExecutor db, String fecha) async {
    final ingresos = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(ingreso_total), 0) as total_ingresos,
        COUNT(*) as total_solicitudes
      FROM solicitudes 
      WHERE date(fecha_solicitud) = date(?)
      AND estado = 'finalizada'
    ''', [fecha]);
    
    final totalIngresos = (ingresos[0]['total_ingresos'] as num).toDouble();
    final totalSolicitudes = (ingresos[0]['total_solicitudes'] as num).toInt();
    
    await db.execute('''
      INSERT OR REPLACE INTO ingresos_diarios (fecha, total_ingresos, total_solicitudes)
      VALUES (date(?), ?, ?)
    ''', [fecha, totalIngresos, totalSolicitudes]);
  }

  Future<void> _actualizarIngresosSemanales(DatabaseExecutor db, DateTime fecha) async {
    final fechaDate = DateTime(fecha.year, fecha.month, fecha.day);
    final inicioSemana = fechaDate.subtract(Duration(days: fechaDate.weekday - 1));
    final finSemana = inicioSemana.add(Duration(days: 6));
    
    final primerDiaAnio = DateTime(fecha.year, 1, 1);
    final diferenciaDias = inicioSemana.difference(primerDiaAnio).inDays;
    final numeroSemana = (diferenciaDias / 7).ceil() + 1;
    
    final ingresos = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(ingreso_total), 0) as total_ingresos,
        COUNT(*) as total_solicitudes
      FROM solicitudes 
      WHERE date(fecha_solicitud) BETWEEN date(?) AND date(?)
      AND estado = 'finalizada'
    ''', [
      inicioSemana.toIso8601String().split('T')[0],
      finSemana.toIso8601String().split('T')[0]
    ]);
    
    final totalIngresos = (ingresos[0]['total_ingresos'] as num).toDouble();
    final totalSolicitudes = (ingresos[0]['total_solicitudes'] as num).toInt();
    
    await db.execute('''
      INSERT OR REPLACE INTO ingresos_semanales 
      (anio, semana, fecha_inicio, fecha_fin, total_ingresos, total_solicitudes)
      VALUES (?, ?, ?, ?, ?, ?)
    ''', [
      fecha.year,
      numeroSemana,
      inicioSemana.toIso8601String().split('T')[0],
      finSemana.toIso8601String().split('T')[0],
      totalIngresos,
      totalSolicitudes
    ]);
  }

  Future<void> _actualizarEstadisticasMensuales(DatabaseExecutor db, DateTime fecha) async {
    final mes = fecha.month;
    final anio = fecha.year;
    
    final ingresos = await db.rawQuery('''
      SELECT COALESCE(SUM(ingreso_total), 0) as total
      FROM solicitudes 
      WHERE strftime('%m', fecha_solicitud) = ? 
      AND strftime('%Y', fecha_solicitud) = ?
      AND estado = 'finalizada'
    ''', [mes.toString().padLeft(2, '0'), anio.toString()]);
    
    final gastos = await db.rawQuery('''
      SELECT COALESCE(SUM(monto), 0) as total
      FROM gastos 
      WHERE strftime('%m', fecha) = ? 
      AND strftime('%Y', fecha) = ?
    ''', [mes.toString().padLeft(2, '0'), anio.toString()]);
    
    final totalIngresos = (ingresos[0]['total'] as num).toDouble();
    final totalGastos = (gastos[0]['total'] as num).toDouble();
    
    await db.execute('''
      INSERT OR REPLACE INTO estadisticas_mensuales (mes, anio, total_ingresos, total_gastos)
      VALUES (?, ?, ?, ?)
    ''', [mes, anio, totalIngresos, totalGastos]);
  }

  // FUNCIÓN SIMPLE PARA CALCULAR PRECIOS
  Future<double> calcularPrecio({
    required int cuartoId,
    required String modalidad,
    int? horas,
    int? dias,
    double? precioPersonalizado,
  }) async {
    final db = await database;
    
    final cuarto = await db.query('cuartos', where: 'id = ?', whereArgs: [cuartoId]);
    if (cuarto.isEmpty) throw Exception('Cuarto no encontrado');
    
    final precioPorHora = cuarto[0]['precio_por_hora'] as double;
    final precioPorDia = cuarto[0]['precio_por_dia'] as double;
    
    switch (modalidad) {
      case 'por_hora':
        if (horas == null || horas <= 0) throw Exception('Especificar horas válidas');
        return precioPorHora * horas;
        
      case 'por_dia':
        if (dias == null || dias <= 0) throw Exception('Especificar días válidos');
        return precioPorDia * dias;
        
      case 'personalizado':
        if (precioPersonalizado == null || precioPersonalizado <= 0) {
          throw Exception('Especificar precio personalizado válido');
        }
        if (horas != null && horas > 0) {
          return precioPersonalizado * horas;
        } else if (dias != null && dias > 0) {
          return precioPersonalizado * dias;
        } else {
          return precioPersonalizado;
        }
        
      default:
        throw Exception('Modalidad no válida');
    }
  }

  // CREAR SOLICITUD CON ACTUALIZACIÓN AUTOMÁTICA
  Future<int> createSolicitud({
    required int cuartoId,
    required String modalidad,
    int? horas,
    int? dias,
    double? precioPersonalizado,
  }) async {
    final db = await database;
    
    final ingresoTotal = await calcularPrecio(
      cuartoId: cuartoId,
      modalidad: modalidad,
      horas: horas,
      dias: dias,
      precioPersonalizado: precioPersonalizado,
    );
    
    double precioAplicado;
    if (modalidad == 'personalizado') {
      precioAplicado = precioPersonalizado!;
    } else {
      final cuarto = await db.query('cuartos', where: 'id = ?', whereArgs: [cuartoId]);
      precioAplicado = modalidad == 'por_hora' 
          ? cuarto[0]['precio_por_hora'] as double
          : cuarto[0]['precio_por_dia'] as double;
    }
    
    return await db.transaction((txn) async {
      final solicitudId = await txn.insert('solicitudes', {
        'cuarto_id': cuartoId,
        'modalidad_pago': modalidad,
        'precio_aplicado': precioAplicado,
        'horas_totales': horas,
        'dias_totales': dias,
        'ingreso_total': ingresoTotal,
        'fecha_inicio': DateTime.now().toIso8601String(),
      });
      
      await txn.update(
        'cuartos',
        {'estado': 'ocupado'},
        where: 'id = ?',
        whereArgs: [cuartoId],
      );
      
      return solicitudId;
    });
  }

  // FINALIZAR SOLICITUD CON ACTUALIZACIÓN AUTOMÁTICA - CORREGIDO
  Future<void> finalizarSolicitud(int solicitudId) async {
    final db = await database;
    
    await db.transaction((txn) async {
      final solicitud = await txn.query('solicitudes', where: 'id = ?', whereArgs: [solicitudId]);
      
      if (solicitud.isNotEmpty) {
        final cuartoId = solicitud[0]['cuarto_id'];
        final fechaActual = DateTime.now().toIso8601String();
        
        await txn.update(
          'solicitudes',
          {'estado': 'finalizada', 'fecha_fin': fechaActual},
          where: 'id = ?',
          whereArgs: [solicitudId],
        );
        
        await txn.update(
          'cuartos',
          {'estado': 'limpieza'},
          where: 'id = ?',
          whereArgs: [cuartoId],
        );
        
        // AHORA txn ES UN DatabaseExecutor - FUNCIONA CORRECTAMENTE
        final fechaHoy = DateTime.now().toIso8601String().split('T')[0];
        await _actualizarIngresosDiarios(txn, fechaHoy);
        await _actualizarIngresosSemanales(txn, DateTime.now());
        await _actualizarEstadisticasMensuales(txn, DateTime.now());
      }
    });
  }

  // CREAR GASTO CON ACTUALIZACIÓN AUTOMÁTICA - CORREGIDO
  Future<int> createGasto({
    required double monto,
    required String descripcion,
    String? fecha,
  }) async {
    final db = await database;
    
    final fechaGasto = fecha ?? DateTime.now().toIso8601String().split('T')[0];
    
    return await db.transaction((txn) async {
      final gastoId = await txn.insert('gastos', {
        'monto': monto,
        'descripcion': descripcion,
        'fecha': fechaGasto,
      });
      
      // AHORA txn ES UN DatabaseExecutor - FUNCIONA CORRECTAMENTE
      final fechaDateTime = DateTime.parse(fechaGasto + 'T00:00:00');
      await _actualizarEstadisticasMensuales(txn, fechaDateTime);
      
      return gastoId;
    });
  }

  // CONSULTAS PARA OBTENER LAS ESTADÍSTICAS
  Future<List<Map<String, dynamic>>> getIngresosDiarios({int? ultimosDias}) async {
    final db = await database;
    
    String whereClause = '';
    if (ultimosDias != null) {
      whereClause = "WHERE fecha >= date('now', '-$ultimosDias days')";
    }
    
    return await db.rawQuery('''
      SELECT * FROM ingresos_diarios 
      $whereClause
      ORDER BY fecha DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getIngresosSemanales({int? ultimasSemanas}) async {
    final db = await database;
    
    String whereClause = '';
    if (ultimasSemanas != null) {
      whereClause = "WHERE fecha_inicio >= date('now', '-${ultimasSemanas * 7} days')";
    }
    
    return await db.rawQuery('''
      SELECT * FROM ingresos_semanales 
      $whereClause
      ORDER BY anio DESC, semana DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getEstadisticasMensuales({int? ultimosMeses}) async {
    final db = await database;
    
    String whereClause = '';
    if (ultimosMeses != null) {
      whereClause = '''
        WHERE (anio * 12 + mes) >= (
          strftime('%Y', 'now') * 12 + strftime('%m', 'now') - $ultimosMeses
        )
      ''';
    }
    
    return await db.rawQuery('''
      SELECT * FROM estadisticas_mensuales 
      $whereClause
      ORDER BY anio DESC, mes DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getCuartosDisponibles() async {
    final db = await database;
    return await db.query(
      'cuartos',
      where: 'estado = ?',
      whereArgs: ['disponible'],
      orderBy: 'CAST(numero AS INTEGER)',
    );
  }

Future<List<Map<String, dynamic>>> getCuartosEnUso() async {
  final db = await database;
  return await db.rawQuery('''
    SELECT c.*, 
           s.fecha_inicio, 
           s.horas_totales, 
           s.dias_totales, 
           s.ingreso_total, 
           s.modalidad_pago,
           s.id as solicitud_id
    FROM cuartos c 
    LEFT JOIN solicitudes s ON c.id = s.cuarto_id AND s.estado = 'activa'
    WHERE c.estado = 'ocupado'
    ORDER BY CAST(c.numero AS INTEGER)
  ''');
}

  Future<List<Map<String, dynamic>>> getSolicitudesActivas() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT s.*, c.numero, c.tipo_habitacion
      FROM solicitudes s
      JOIN cuartos c ON s.cuarto_id = c.id
      WHERE s.estado = 'activa'
      ORDER BY s.fecha_inicio DESC
    ''');
  }

  Future<void> finalizarLimpiezaMantenimiento(int cuartoId) async {
    final db = await database;
    
    await db.update(
      'cuartos',
      {'estado': 'disponible'},
      where: 'id = ?',
      whereArgs: [cuartoId],
    );
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

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