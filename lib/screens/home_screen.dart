import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const HomeScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      color: Colors.green[600],
      width: double.infinity,
      height: size.height,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(isTablet ? 24 : 20),
                padding: EdgeInsets.all(isTablet ? 32 : 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isTablet ? 32 : 24),
                ),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _getResumenDatos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final datos =
                        snapshot.data ??
                        {
                          'en_uso': 0,
                          'libres': 0,
                          'mantenimiento': 0,
                          'ingresos_hoy': 0.0,
                        };

                    final cardHeight = isTablet ? 120.0 : 100.0;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: isTablet ? 20 : 16),

                          // Primera fila - 2 columnas
                          Row(
                            children: [
                              Expanded(
                                child: _buildHomeCard(
                                  Icons.people,
                                  'En uso: ${datos['en_uso']}',
                                  Colors.green[100]!,
                                  double.infinity,
                                  cardHeight,
                                  isTablet,
                                  () => widget.onNavigate('en_uso'),
                                ),
                              ),
                              SizedBox(width: isTablet ? 16 : 12),
                              Expanded(
                                child: _buildHomeCard(
                                  Icons.bed,
                                  'Libres: ${datos['libres']}',
                                  Colors.green[100]!,
                                  double.infinity,
                                  cardHeight,
                                  isTablet,
                                  () => widget.onNavigate('libres'),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isTablet ? 24 : 16),

                          // Segunda fila - 2 columnas
                          Row(
                            children: [
                              Expanded(
                                child: _buildHomeCard(
                                  Icons.build,
                                  'Mantenimiento: ${datos['mantenimiento']}',
                                  Colors.green[100]!,
                                  double.infinity,
                                  cardHeight,
                                  isTablet,
                                  () => widget.onNavigate('mantenimiento'),
                                ),
                              ),
                              SizedBox(width: isTablet ? 16 : 12),
                              Expanded(
                                child: _buildHomeCard(
                                  Icons.attach_money,
                                  'Ganancias hoy\n\$${datos['ganancias_hoy'].toStringAsFixed(0)}',
                                  Colors.green[100]!,
                                  double.infinity,
                                  cardHeight,
                                  isTablet,
                                  () => widget.onNavigate('graficas'),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isTablet ? 24 : 16),

                          // Tercera fila - 2 columnas
                          Row(
                            children: [
                              Expanded(
                                child: _buildHomeCard(
                                  Icons.history,
                                  'Historial',
                                  Colors.green[100]!,
                                  double.infinity,
                                  cardHeight,
                                  isTablet,
                                  () => widget.onNavigate('historial'),
                                ),
                              ),
                              SizedBox(width: isTablet ? 16 : 12),
                              Expanded(
                                child: _buildHomeCard(
                                  Icons.receipt_long,
                                  'Gastos',
                                  Colors.green[100]!,
                                  double.infinity,
                                  cardHeight,
                                  isTablet,
                                  () => widget.onNavigate('costos'),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isTablet ? 40 : 32),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getResumenDatos() async {
    final db = await _dbHelper.database;

    // Contar cuartos por estado
    final estadoCuartos = await db.rawQuery('''
    SELECT estado, COUNT(*) as cantidad
    FROM cuartos 
    GROUP BY estado
  ''');

    // Obtener ingresos de hoy
    final ingresosHoy = await db.rawQuery('''
    SELECT COALESCE(SUM(ingreso_total), 0) as total_ingresos
    FROM solicitudes 
    WHERE date(fecha_solicitud) = date('now') 
  ''');

    // Obtener gastos de hoy
    final gastosHoy = await db.rawQuery('''
    SELECT COALESCE(SUM(monto), 0) as total_gastos
    FROM gastos 
    WHERE fecha = date('now')
  ''');

    // DEBUG - Agregar estos prints temporalmente
    print('DEBUG - Fecha actual: ${DateTime.now()}');
    print('DEBUG - Ingresos hoy: ${ingresosHoy}');
    print('DEBUG - Gastos hoy: ${gastosHoy}');

    int enUso = 0;
    int libres = 0;
    int mantenimiento = 0;

    for (var estado in estadoCuartos) {
      final cantidad = (estado['cantidad'] as num).toInt();
      switch (estado['estado']) {
        case 'ocupado':
          enUso = cantidad;
          break;
        case 'disponible':
          libres = cantidad;
          break;
        case 'mantenimiento':
        case 'limpieza':
          mantenimiento += cantidad;
          break;
      }
    }

    final ingresosDiarios = (ingresosHoy[0]['total_ingresos'] as num)
        .toDouble();
    final gastosDiarios = (gastosHoy[0]['total_gastos'] as num).toDouble();

    // DEBUG - Más prints
    print('DEBUG - Ingresos calculados: $ingresosDiarios');
    print('DEBUG - Gastos calculados: $gastosDiarios');
    print('DEBUG - Ganancia final: ${ingresosDiarios - gastosDiarios}');

    return {
      'en_uso': enUso,
      'libres': libres,
      'mantenimiento': mantenimiento,
      'ganancias_hoy': ingresosDiarios - gastosDiarios,
    };
  }

  Widget _buildHomeCard(
    IconData icon,
    String text,
    Color color,
    double width,
    double height,
    bool isTablet,
    VoidCallback? onTap,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          child: Container(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: isTablet ? 40 : 32, color: Colors.green[700]),
                SizedBox(height: isTablet ? 12 : 8),
                FittedBox(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
