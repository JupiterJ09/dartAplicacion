import 'package:flutter/material.dart';
//import '../widgets/common_widgets.dart';
import '../database/database_helper.dart';

class EnUsoScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const EnUsoScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<EnUsoScreen> createState() => _EnUsoScreenState();
}

class _EnUsoScreenState extends State<EnUsoScreen> {
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
                    'Cuartos en Uso',
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
            
            // Content
            Expanded(
              child: Container(
                margin: EdgeInsets.all(isTablet ? 24 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isTablet ? 32 : 20),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _dbHelper.getCuartosEnUso(),
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
                              'Error al cargar datos',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                color: Colors.red[600],
                              ),
                            ),
                            SizedBox(height: isTablet ? 8 : 6),
                            Text(
                              snapshot.error.toString(),
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final cuartosEnUso = snapshot.data ?? [];
                    
                    if (cuartosEnUso.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hotel_outlined,
                              size: isTablet ? 80 : 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: isTablet ? 24 : 16),
                            Text(
                              'No hay cuartos en uso',
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                            Text(
                              'Todos los cuartos están disponibles',
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
                      padding: EdgeInsets.all(isTablet ? 24 : 16),
                      itemCount: cuartosEnUso.length,
                      itemBuilder: (context, index) {
                        final cuarto = cuartosEnUso[index];
                        return _buildRoomInUseItem(cuarto, isTablet);
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

  Widget _buildRoomInUseItem(Map<String, dynamic> cuarto, bool isTablet) {
    final numero = cuarto['numero'] ?? 'S/N';
    final tipo = cuarto['tipo_habitacion'] ?? 'Cuarto';
    final modalidadPago = cuarto['modalidad_pago'] ?? 'por_hora';
    final ingresoTotal = cuarto['ingreso_total']?.toDouble() ?? 0.0;
    final horasTotales = cuarto['horas_totales'] ?? 0;
    final diasTotales = cuarto['dias_totales'] ?? 0;
    final fechaInicio = cuarto['fecha_inicio'] ?? '';
    
    // Formatear fecha
    String fechaFormateada = '';
    if (fechaInicio.isNotEmpty) {
      try {
        final fecha = DateTime.parse(fechaInicio);
        fechaFormateada = '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        fechaFormateada = 'Fecha inválida';
      }
    }
    
    // Determinar duración
    String duracion = '';
    if (modalidadPago == 'por_hora' && horasTotales > 0) {
      duracion = '$horasTotales hora${horasTotales > 1 ? 's' : ''}';
    } else if (modalidadPago == 'por_dia' && diasTotales > 0) {
      duracion = '$diasTotales día${diasTotales > 1 ? 's' : ''}';
    } else {
      duracion = 'Personalizado';
    }
    
    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del cuarto
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 8 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.hotel,
                        color: Colors.red[700],
                        size: isTablet ? 20 : 16,
                      ),
                      SizedBox(width: isTablet ? 8 : 4),
                      Text(
                        '$tipo $numero',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12 : 8,
                    vertical: isTablet ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                  ),
                  child: Text(
                    'OCUPADO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 12 : 10,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isTablet ? 16 : 12),
            
            // Información de la solicitud
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.access_time,
                        'Inicio',
                        fechaFormateada,
                        isTablet,
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      _buildInfoRow(
                        Icons.schedule,
                        'Duración',
                        duracion,
                        isTablet,
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      _buildInfoRow(
                        Icons.payment,
                        'Modalidad',
                        modalidadPago.replaceAll('_', ' ').toUpperCase(),
                        isTablet,
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      _buildInfoRow(
                        Icons.attach_money,
                        'Total',
                        '\$${ingresoTotal.toStringAsFixed(2)}',
                        isTablet,
                        valueColor: Colors.green[700],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isTablet ? 20 : 16),
            
            // Botón de finalizar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showFinalizarDialog(cuarto),
                icon: Icon(
                  Icons.check_circle_outline,
                  size: isTablet ? 20 : 18,
                ),
                label: Text(
                  'Finalizar Estancia',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 16 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    bool isTablet, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isTablet ? 18 : 16,
          color: Colors.grey[600],
        ),
        SizedBox(width: isTablet ? 8 : 6),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: isTablet ? 8 : 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: valueColor ?? Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  void _showFinalizarDialog(Map<String, dynamic> cuarto) {
    final numero = cuarto['numero'] ?? 'S/N';
    final tipo = cuarto['tipo_habitacion'] ?? 'Cuarto';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Finalizar Estancia'),
          content: Text(
            '¿Estás seguro de que deseas finalizar la estancia del $tipo $numero?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _finalizarEstancia(cuarto);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              child: Text('Finalizar'),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _finalizarEstancia(Map<String, dynamic> cuarto) async {
    try {
      // Buscar la solicitud activa para este cuarto
      final solicitudesActivas = await _dbHelper.getSolicitudesActivas();
      final solicitudActiva = solicitudesActivas.firstWhere(
        (s) => s['cuarto_id'] == cuarto['id'],
        orElse: () => {},
      );
      
      if (solicitudActiva.isNotEmpty) {
        await _dbHelper.finalizarSolicitud(solicitudActiva['id']);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Estancia finalizada correctamente',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green[600],
              duration: Duration(seconds: 2),
            ),
          );
          
          // Refrescar la pantalla
          setState(() {});
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al finalizar estancia: $e',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red[600],
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}