import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ListaGastosScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const ListaGastosScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<ListaGastosScreen> createState() => _ListaGastosScreenState();
}

class _ListaGastosScreenState extends State<ListaGastosScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.orange[600],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => widget.onNavigate('costos'),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: isTablet ? 32 : 24,
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 8),
                  Expanded(
                    child: Text(
                      'Lista de Gastos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 28 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Botón para agregar nuevo gasto
                  ElevatedButton.icon(
                    onPressed: () => widget.onNavigate('costos'),
                    icon: Icon(
                      Icons.add,
                      size: isTablet ? 20 : 18,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Nuevo Gasto',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.green[200],
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 16 : 12,
                        vertical: isTablet ? 12 : 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      setState(() {}); // Refrescar datos
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: isTablet ? 32 : 24,
                    ),
                  ),
                ],
              ),
            ),

            // Estadísticas rápidas
            Container(
              margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.orange[400],
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              ),
              child: FutureBuilder<Map<String, dynamic>>(
                future: _getEstadisticasGastos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final stats = snapshot.data!;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          'Total Gastos',
                          '${stats['total']}',
                          Icons.receipt_long,
                          isTablet,
                        ),
                        _buildStatItem(
                          'Monto Total',
                          '\$${stats['monto_total'].toStringAsFixed(0)}',
                          Icons.attach_money,
                          isTablet,
                        ),
                        _buildStatItem(
                          'Promedio',
                          '\$${stats['promedio'].toStringAsFixed(0)}',
                          Icons.analytics,
                          isTablet,
                        ),
                      ],
                    );
                  }
                  return SizedBox(height: 50);
                },
              ),
            ),

            SizedBox(height: isTablet ? 16 : 12),

            // Header de la tabla
            Container(
              margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.orange[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isTablet ? 16 : 12),
                  topRight: Radius.circular(isTablet ? 16 : 12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Fecha',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Descripción',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Monto',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Lista de gastos
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  isTablet ? 24 : 16,
                  0,
                  isTablet ? 24 : 16,
                  isTablet ? 24 : 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isTablet ? 16 : 12),
                    bottomRight: Radius.circular(isTablet ? 16 : 12),
                  ),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getTodosLosGastos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: isTablet ? 64 : 48,
                              color: Colors.red[300],
                            ),
                            SizedBox(height: isTablet ? 16 : 12),
                            Text(
                              'Error al cargar gastos',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                color: Colors.red[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Intenta refrescar la pantalla',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                color: Colors.red[400],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    final gastos = snapshot.data ?? [];

                    if (gastos.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: isTablet ? 80 : 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: isTablet ? 24 : 16),
                            Text(
                              'No hay gastos registrados',
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                            Text(
                              'Presiona "Nuevo Gasto" para registrar el primero',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: gastos.length,
                      itemBuilder: (context, index) {
                        final gasto = gastos[index];
                        return _buildGastoRow(gasto, index, isTablet);
                      },
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

  Widget _buildStatItem(String label, String value, IconData icon, bool isTablet) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: isTablet ? 24 : 20,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isTablet ? 12 : 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGastoRow(Map<String, dynamic> gasto, int index, bool isTablet) {
    final monto = (gasto['monto'] as num?)?.toDouble() ?? 0.0;
    final descripcion = gasto['descripcion']?.toString() ?? 'Sin descripción';
    final fechaString = gasto['fecha']?.toString() ?? '';

    // Formatear fecha
    String fechaFormateada = '';
    if (fechaString.isNotEmpty) {
      try {
        final fecha = DateTime.parse(fechaString);
        fechaFormateada = '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
      } catch (e) {
        fechaFormateada = fechaString;
      }
    }

    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.orange[50] : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              fechaFormateada,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                descripcion,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '\$${monto.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getTodosLosGastos() async {
    try {
      final db = await _dbHelper.database;

      final result = await db.query(
        'gastos',
        orderBy: 'fecha DESC, created_at DESC',
      );

      print('Gastos encontrados: ${result.length}');
      return result;
    } catch (e) {
      print('Error al obtener gastos: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _getEstadisticasGastos() async {
    try {
      final db = await _dbHelper.database;

      final result = await db.rawQuery('''
        SELECT 
          COUNT(*) as total,
          COALESCE(SUM(monto), 0) as monto_total,
          COALESCE(AVG(monto), 0) as promedio
        FROM gastos
      ''');

      return {
        'total': (result[0]['total'] as num).toInt(),
        'monto_total': (result[0]['monto_total'] as num).toDouble(),
        'promedio': (result[0]['promedio'] as num).toDouble(),
      };
    } catch (e) {
      print('Error al obtener estadísticas de gastos: $e');
      return {
        'total': 0,
        'monto_total': 0.0,
        'promedio': 0.0,
      };
    }
  }
}