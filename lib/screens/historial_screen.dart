import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class HistorialScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const HistorialScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => widget.onNavigate('home'),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: isTablet ? 32 : 24,
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 8),
                  Text(
                    'Historial de Solicitudes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
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
            
            // Tabla Header
            Container(
              margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isTablet ? 16 : 12),
                  topRight: Radius.circular(isTablet ? 16 : 12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Cuarto',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
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
                    child: Text(
                      'Hora',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      r'$',
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
            
            // Lista de solicitudes
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
                  future: _getSolicitudesTerminadas(),
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
                              'Error al cargar historial',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                color: Colors.red[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final solicitudes = snapshot.data ?? [];
                    
                    if (solicitudes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: isTablet ? 80 : 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: isTablet ? 24 : 16),
                            Text(
                              'No hay solicitudes terminadas',
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                            Text(
                              'Las solicitudes finalizadas aparecerán aquí',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: solicitudes.length,
                      itemBuilder: (context, index) {
                        final solicitud = solicitudes[index];
                        return _buildHistorialRow(solicitud, index, isTablet);
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

  Widget _buildHistorialRow(Map<String, dynamic> solicitud, int index, bool isTablet) {
    final numero = solicitud['numero'] ?? 'S/N';
    final tipo = solicitud['tipo_habitacion'] ?? 'Cuarto';
    final ingresoTotal = solicitud['ingreso_total']?.toDouble() ?? 0.0;
    final fechaSolicitud = solicitud['fecha_solicitud'] ?? '';
    
    // Formatear fecha y hora
    String fechaFormateada = '';
    String horaFormateada = '';
    if (fechaSolicitud.isNotEmpty) {
      try {
        final fecha = DateTime.parse(fechaSolicitud);
        fechaFormateada = '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}';
        horaFormateada = '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        fechaFormateada = '--/--';
        horaFormateada = '--:--';
      }
    }
    
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.green[50] : Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              '$tipo $numero',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              fechaFormateada,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
          ),
          Expanded(
            child: Text(
              horaFormateada,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
          ),
          Expanded(
            child: Text(
              '\$${ingresoTotal.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<List<Map<String, dynamic>>> _getSolicitudesTerminadas() async {
    final db = await _dbHelper.database;
    
    return await db.rawQuery('''
      SELECT s.*, c.numero, c.tipo_habitacion
      FROM solicitudes s
      JOIN cuartos c ON s.cuarto_id = c.id
      WHERE s.estado = 'finalizada'
      ORDER BY s.fecha_solicitud DESC
    ''');
  }
}