import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class GraficasScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const GraficasScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<GraficasScreen> createState() => _GraficasScreenState();
}

class _GraficasScreenState extends State<GraficasScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  String _filtroSeleccionado = 'Dia'; // Dia, Semana, Mes, Año

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return WillPopScope(
      onWillPop: () async {
        widget.onNavigate('home');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.green[600],
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(isTablet ? 24 : 16),
                  padding: EdgeInsets.all(isTablet ? 32 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isTablet ? 32 : 20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header con filtros
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Ganancias por $_filtroSeleccionado',
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ),

                          Text(
                            'Ver por:',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isTablet ? 20 : 16),

                      // Botones de filtro
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterButton('Dia', isTablet),
                            SizedBox(width: 8),
                            _buildFilterButton('Semana', isTablet),
                            SizedBox(width: 8),
                            _buildFilterButton('Mes', isTablet),
                            SizedBox(width: 8),
                            _buildFilterButton('Año', isTablet),
                          ],
                        ),
                      ),

                      SizedBox(height: isTablet ? 40 : 30),

                      // Gráfica
                      Expanded(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: _getIngresosDatos(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              print(
                                'Error en gráficas: ${snapshot.error}',
                              ); // Debug
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: Colors.red[300],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Error al cargar datos',
                                      style: TextStyle(color: Colors.red[600]),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Es posible que necesites agregar algunos datos primero',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }

                            final ingresosDatos = snapshot.data ?? [];

                            if (ingresosDatos.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bar_chart,
                                      size: isTablet ? 80 : 64,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No hay datos disponibles',
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Agrega algunas solicitudes o gastos para ver las gráficas',
                                      style: TextStyle(
                                        fontSize: isTablet ? 14 : 12,
                                        color: Colors.grey[500],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }

                            return _buildIngresosChart(ingresosDatos, isTablet);
                          },
                        ),
                      ),

                      SizedBox(height: isTablet ? 20 : 16),

                      // Resumen
                      _buildResumen(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String texto, bool isTablet) {
    final isSelected = _filtroSeleccionado == texto;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filtroSeleccionado = texto;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[600] : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.green[600]! : Colors.grey[400]!,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

 Widget _buildIngresosChart(List<Map<String, dynamic>> datos, bool isTablet) {
  final maxIngreso = datos.fold<double>(0.0, (max, item) {
    final ingreso = (item['ingreso'] as num?)?.toDouble() ?? 0.0;
    return ingreso.abs() > max ? ingreso.abs() : max;
  });

  final chartHeight = isTablet ? 300.0 : 250.0;

  return Container(
    height: chartHeight,
    child: Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: datos.map((item) {
                final ingreso = (item['ingreso'] as num?)?.toDouble() ?? 0.0;
                final barHeight = maxIngreso > 0
                    ? (ingreso.abs() / maxIngreso) * (chartHeight - 120)
                    : 10.0;
                return Expanded(
                  child: _buildIngresoBar(barHeight, ingreso, isTablet),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: datos.map((item) {
              return Expanded(
                child: Text(
                  item['label'] ?? '',
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

// El widget que construye la barra de ingresos
Widget _buildIngresoBar(double height, double valor, bool isTablet) {
  final isNegative = valor < 0;

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      // Valor encima de la barra
      Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isNegative ? Colors.red[600] : Colors.green[600],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '\$${valor.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: isTablet ? 11 : 9,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      SizedBox(height: 8),
      // Barra
      Container(
        // Eliminamos el 'width' para que se ajuste automáticamente.
        // Ahora el ancho lo gestiona el Expanded padre
        height: height.clamp(10.0, double.infinity),
        width: 20, // Agregamos un ancho fijo mínimo para evitar que desaparezca
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: isNegative
                ? [Colors.red[400]!, Colors.red[600]!]
                : [Colors.green[400]!, Colors.green[600]!],
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(isTablet ? 8 : 6),
          ),
          boxShadow: [
            BoxShadow(
              color: (isNegative ? Colors.red : Colors.green).withOpacity(
                0.3,
              ),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildResumen() {
    return FutureBuilder<double>(
      key: ValueKey(_filtroSeleccionado), // ✅ Esto fuerza la actualización
      future: _getTotalIngresos(),
      builder: (context, snapshot) {
        final total = snapshot.data ?? 0.0;
        final isNegative = total < 0;

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isNegative ? Colors.red[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isNegative ? Colors.red[200]! : Colors.green[200]!,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isNegative
                    ? 'Pérdida ${_filtroSeleccionado}:'
                    : 'Ganancia ${_filtroSeleccionado}:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isNegative ? Colors.red[700] : Colors.green[700],
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isNegative ? Colors.red[700] : Colors.green[700],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Función auxiliar para verificar si una tabla existe
  Future<bool> _tableExists(String tableName) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery("""
        SELECT name FROM sqlite_master 
        WHERE type='table' AND name='$tableName'
      """);
      return result.isNotEmpty;
    } catch (e) {
      print('Error verificando tabla $tableName: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> _getIngresosDatos() async {
    try {
      final db = await _dbHelper.database;
      List<Map<String, dynamic>> ingresosDatos = [];

      switch (_filtroSeleccionado) {
        case 'Dia':
          try {
            bool solicitudesExists = await _tableExists('solicitudes');
            bool gastosExists = await _tableExists('gastos');

            Map<String, double> ingresosPorFecha = {};
            Map<String, double> gastosPorFecha = {};

            if (solicitudesExists) {
              // CAMBIO CLAVE: Incluir TODAS las solicitudes, no solo las finalizadas
              final ingresosQuery = await db.rawQuery('''
        SELECT 
          date(fecha_solicitud) as fecha,
          COALESCE(SUM(ingreso_total), 0) as ingresos,
          COUNT(*) as cantidad
        FROM solicitudes 
        WHERE date(fecha_solicitud) >= date('now', '-6 days')
        GROUP BY date(fecha_solicitud)
        ORDER BY fecha DESC
      ''');

             
              for (var ingreso in ingresosQuery) {
                ingresosPorFecha[ingreso['fecha'] as String] =
                    (ingreso['ingresos'] as num).toDouble();
              }
            }

            if (gastosExists) {
              final gastosQuery = await db.rawQuery('''
        SELECT fecha, COALESCE(SUM(monto), 0) as gastos
        FROM gastos 
        WHERE fecha >= date('now', '-6 days')
        GROUP BY fecha
        ORDER BY fecha DESC
      ''');

              for (var gasto in gastosQuery) {
                gastosPorFecha[gasto['fecha'] as String] =
                    (gasto['gastos'] as num).toDouble();
              }
            }

            // Generar últimos 7 días
            for (int i = 6; i >= 0; i--) {
              final fecha = DateTime.now().subtract(Duration(days: i));
              final fechaStr =
                  "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
              final ingresos = ingresosPorFecha[fechaStr] ?? 0.0;
              final gastos = gastosPorFecha[fechaStr] ?? 0.0;
              final ganancia = ingresos - gastos;

              ingresosDatos.add({
                'label': '${fecha.day}/${fecha.month}',
                'ingreso': ganancia,
              });
            }
          } catch (e) {
            print('Error en datos diarios: $e');

            // Crear datos vacíos para los últimos 7 días
            for (int i = 6; i >= 0; i--) {
              final fecha = DateTime.now().subtract(Duration(days: i));
              ingresosDatos.add({
                'label': '${fecha.day}/${fecha.month}',
                'ingreso': 0.0,
              });
            }
          }
          break;

        case 'Semana':
          try {
            // Verificar si el método y tablas existen
            bool gastosExists = await _tableExists('gastos');

            final semanas = await _dbHelper.getIngresosSemanales(
              ultimasSemanas: 6,
            );

            for (var semana in semanas) {
              final fechaInicio = semana['fecha_inicio']?.toString() ?? '';
              final fechaFin = semana['fecha_fin']?.toString() ?? '';

              double gastos = 0.0;
              if (fechaInicio.isNotEmpty &&
                  fechaFin.isNotEmpty &&
                  gastosExists) {
                final gastosSemanales = await db.rawQuery(
                  '''
                  SELECT COALESCE(SUM(monto), 0) as total_gastos
                  FROM gastos 
                  WHERE fecha BETWEEN ? AND ?
                ''',
                  [fechaInicio, fechaFin],
                );

                gastos =
                    (gastosSemanales.isNotEmpty &&
                        gastosSemanales[0]['total_gastos'] != null)
                    ? (gastosSemanales[0]['total_gastos'] as num).toDouble()
                    : 0.0;
              }

              final ingresos = (semana['total_ingresos'] != null)
                  ? (semana['total_ingresos'] as num).toDouble()
                  : 0.0;

              if (fechaInicio.isNotEmpty && fechaFin.isNotEmpty) {
                final fechaInicio_dt = DateTime.parse(fechaInicio);
                final fechaFin_dt = DateTime.parse(fechaFin);

                ingresosDatos.add({
                  'label':
                      '${fechaInicio_dt.day}/${fechaInicio_dt.month}\n${fechaFin_dt.day}/${fechaFin_dt.month}',
                  'ingreso': ingresos - gastos,
                });
              }
            }

            // Si no hay datos, crear datos vacíos
            if (ingresosDatos.isEmpty) {
              for (int i = 5; i >= 0; i--) {
                final fechaFin = DateTime.now().subtract(Duration(days: i * 7));
                final fechaInicio = fechaFin.subtract(Duration(days: 6));

                ingresosDatos.add({
                  'label':
                      '${fechaInicio.day}/${fechaInicio.month}\n${fechaFin.day}/${fechaFin.month}',
                  'ingreso': 0.0,
                });
              }
            }
          } catch (e) {
            print('Error en datos semanales: $e');
            // Crear datos vacíos para las últimas 6 semanas
            for (int i = 5; i >= 0; i--) {
              final fechaFin = DateTime.now().subtract(Duration(days: i * 7));
              final fechaInicio = fechaFin.subtract(Duration(days: 6));

              ingresosDatos.add({
                'label':
                    '${fechaInicio.day}/${fechaInicio.month}\n${fechaFin.day}/${fechaFin.month}',
                'ingreso': 0.0,
              });
            }
          }
          break;

        case 'Mes':
          try {
            bool estadisticasExists = await _tableExists(
              'estadisticas_mensuales',
            );

            if (estadisticasExists) {
              final meses = await db.rawQuery('''
                SELECT mes, anio, total_ingresos, total_gastos
                FROM estadisticas_mensuales 
                WHERE (anio * 12 + mes) >= (strftime('%Y', 'now') * 12 + strftime('%m', 'now') - 5)
                ORDER BY anio ASC, mes ASC
              ''');

              ingresosDatos = meses.map((m) {
                final mesNombre = _getNombreMes((m['mes'] as num).toInt());
                final ingresos =
                    (m['total_ingresos'] as num?)?.toDouble() ?? 0.0;
                final gastos = (m['total_gastos'] as num?)?.toDouble() ?? 0.0;
                return {
                  'label': '$mesNombre\n${m['anio']}',
                  'ingreso': ingresos - gastos,
                };
              }).toList();
            }

            // Si no hay datos, crear datos vacíos para los últimos 6 meses
            if (ingresosDatos.isEmpty) {
              final ahora = DateTime.now();
              for (int i = 5; i >= 0; i--) {
                final fecha = DateTime(ahora.year, ahora.month - i, 1);
                final mesNombre = _getNombreMes(fecha.month);
                ingresosDatos.add({
                  'label': '$mesNombre\n${fecha.year}',
                  'ingreso': 0.0,
                });
              }
            }
          } catch (e) {
            print('Error en datos mensuales: $e');
            // Crear datos vacíos para los últimos 6 meses
            final ahora = DateTime.now();
            for (int i = 5; i >= 0; i--) {
              final fecha = DateTime(ahora.year, ahora.month - i, 1);
              final mesNombre = _getNombreMes(fecha.month);
              ingresosDatos.add({
                'label': '$mesNombre\n${fecha.year}',
                'ingreso': 0.0,
              });
            }
          }
          break;

        case 'Año':
          try {
            bool estadisticasExists = await _tableExists(
              'estadisticas_mensuales',
            );

            if (estadisticasExists) {
              final anios = await db.rawQuery('''
                SELECT anio, SUM(total_ingresos) as ingresos_anuales, SUM(total_gastos) as gastos_anuales
                FROM estadisticas_mensuales 
                GROUP BY anio
                ORDER BY anio ASC
                LIMIT 6
              ''');

              ingresosDatos = anios.map((a) {
                final ingresos =
                    (a['ingresos_anuales'] as num?)?.toDouble() ?? 0.0;
                final gastos = (a['gastos_anuales'] as num?)?.toDouble() ?? 0.0;
                return {
                  'label': a['anio'].toString(),
                  'ingreso': ingresos - gastos,
                };
              }).toList();
            }

            // Si no hay datos, crear al menos el año actual
            if (ingresosDatos.isEmpty) {
              final anioActual = DateTime.now().year;
              ingresosDatos.add({
                'label': anioActual.toString(),
                'ingreso': 0.0,
              });
            }
          } catch (e) {
            print('Error en datos anuales: $e');
            // Crear datos vacíos para el año actual
            final anioActual = DateTime.now().year;
            ingresosDatos.add({'label': anioActual.toString(), 'ingreso': 0.0});
          }
          break;
      }

      return ingresosDatos;
    } catch (e) {
      print('Error general en _getIngresosDatos: $e');
      // Retornar datos vacíos para evitar crash
      return [];
    }
  }

  Future<double> _getTotalIngresos() async {
    try {
      final datos = await _getIngresosDatos();
      return datos.fold<double>(0.0, (sum, item) {
        return sum + ((item['ingreso'] as num?)?.toDouble() ?? 0.0);
      });
    } catch (e) {
      print('Error calculando total de ingresos: $e');
      return 0.0;
    }
  }

  String _getNombreMes(int mes) {
    const meses = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return (mes >= 1 && mes <= 12) ? meses[mes] : mes.toString();
  }
}
