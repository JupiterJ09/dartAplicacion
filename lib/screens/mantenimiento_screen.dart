import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class MantenimientoScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const MantenimientoScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<MantenimientoScreen> createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
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
                    'Limpieza y Mantenimiento',
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
                  future: _getCuartosEnMantenimiento(),
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
                          ],
                        ),
                      );
                    }
                    
                    final cuartosMantenimiento = snapshot.data ?? [];
                    
                    if (cuartosMantenimiento.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cleaning_services,
                              size: isTablet ? 80 : 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: isTablet ? 24 : 16),
                            Text(
                              'No hay cuartos pendientes',
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                            Text(
                              'Todos los cuartos están listos',
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
                      itemCount: cuartosMantenimiento.length,
                      itemBuilder: (context, index) {
                        final cuarto = cuartosMantenimiento[index];
                        return _buildMantenimientoItem(cuarto, isTablet);
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

  Widget _buildMantenimientoItem(Map<String, dynamic> cuarto, bool isTablet) {
    final numero = cuarto['numero'] ?? 'S/N';
    final tipo = cuarto['tipo_habitacion'] ?? 'Cuarto';
    final estado = cuarto['estado'] ?? 'mantenimiento';
    final fechaCreacion = cuarto['created_at'] ?? '';
    
    // Formatear fecha
    String fechaFormateada = '';
    if (fechaCreacion.isNotEmpty) {
      try {
        final fecha = DateTime.parse(fechaCreacion);
        fechaFormateada = '${fecha.day}/${fecha.month}/${fecha.year}';
      } catch (e) {
        fechaFormateada = 'Fecha inválida';
      }
    }
    
    // Configurar colores y textos según el estado
    Color? colorFondo;
    Color? colorTexto;
    Color? colorBoton;
    String estadoTexto;
    String descripcionEstado;
    IconData icono;
    
    if (estado == 'limpieza') {
      colorFondo = Colors.blue[100];
      colorTexto = Colors.blue[700];
      colorBoton = Colors.blue[600];
      estadoTexto = 'LIMPIEZA';
      descripcionEstado = 'Requiere limpieza';
      icono = Icons.cleaning_services;
    } else {
      colorFondo = Colors.orange[100];
      colorTexto = Colors.orange[700];
      colorBoton = Colors.orange[600];
      estadoTexto = 'MANTENIMIENTO';
      descripcionEstado = 'En mantenimiento';
      icono = Icons.build;
    }
    
    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Row(
          children: [
            // Información del cuarto
            Expanded(
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
                          color: colorFondo,
                          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tipo == 'cabaña' ? Icons.cabin : Icons.hotel,
                              color: colorTexto,
                              size: isTablet ? 20 : 16,
                            ),
                            SizedBox(width: isTablet ? 8 : 4),
                            Text(
                              '$tipo $numero',
                              style: TextStyle(
                                color: colorTexto,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isTablet ? 12 : 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 12 : 8,
                          vertical: isTablet ? 6 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorBoton,
                          borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                        ),
                        child: Text(
                          estadoTexto,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 12 : 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: isTablet ? 12 : 8),
                  
                  // Información del estado
                  Row(
                    children: [
                      Icon(
                        icono,
                        size: isTablet ? 18 : 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: isTablet ? 8 : 6),
                      Text(
                        descripcionEstado,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(width: isTablet ? 20 : 16),
            
            // Botón de finalizar
            ElevatedButton.icon(
              onPressed: () => _finalizarEstado(cuarto),
              icon: Icon(
                Icons.check_circle,
                size: isTablet ? 20 : 18,
              ),
              label: Text(
                'Finalizar',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 12 : 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getCuartosEnMantenimiento() async {
    final db = await _dbHelper.database;
    return await db.query(
      'cuartos',
      where: 'estado = ? OR estado = ?',
      whereArgs: ['mantenimiento', 'limpieza'],
      orderBy: 'CAST(numero AS INTEGER)',
    );
  }

  Future<void> _finalizarEstado(Map<String, dynamic> cuarto) async {
    final estado = cuarto['estado'];
    final numero = cuarto['numero'];
    final tipo = cuarto['tipo_habitacion'];
    
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Finalizar ${estado == 'limpieza' ? 'Limpieza' : 'Mantenimiento'}'),
          content: Text(
            '¿Confirmas que el $tipo $numero está listo para usar?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmado == true) {
      try {
        await _dbHelper.finalizarLimpiezaMantenimiento(cuarto['id']);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${estado == 'limpieza' ? 'Limpieza' : 'Mantenimiento'} finalizado - Cuarto disponible'
              ),
              backgroundColor: Colors.green[600],
            ),
          );
          setState(() {});
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red[600],
            ),
          );
        }
      }
    }
  }
}