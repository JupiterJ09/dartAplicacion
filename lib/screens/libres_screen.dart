import 'package:flutter/material.dart';
//import '../widgets/common_widgets.dart';
import '../database/database_helper.dart';

class LibresScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const LibresScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<LibresScreen> createState() => _LibresScreenState();
}

class _LibresScreenState extends State<LibresScreen> {
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
                    'Cuartos Disponibles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    // ← NUEVO: Botón para gestionar cuartos
                    onPressed: () => widget.onNavigate('registro'),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: isTablet ? 32 : 24,
                    ),
                  ),
                  SizedBox(
                    width: isTablet ? 8 : 4,
                  ), // ← Espaciado entre botones
                  IconButton(
                    // ← Botón de refresh (ya existía)
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
                  future: _dbHelper.getCuartosDisponibles(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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

                    final cuartosDisponibles = snapshot.data ?? [];

                    if (cuartosDisponibles.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hotel_class,
                              size: isTablet ? 80 : 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: isTablet ? 24 : 16),
                            Text(
                              'No hay cuartos disponibles',
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                            Text(
                              'Todos los cuartos están ocupados',
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
                      itemCount: cuartosDisponibles.length,
                      itemBuilder: (context, index) {
                        final cuarto = cuartosDisponibles[index];
                        return _buildAvailableRoomItem(cuarto, isTablet);
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

  Widget _buildAvailableRoomItem(Map<String, dynamic> cuarto, bool isTablet) {
    final numero = cuarto['numero'] ?? 'S/N';
    final tipo = cuarto['tipo_habitacion'] ?? 'Cuarto';
    final precioPorHora = cuarto['precio_por_hora']?.toDouble() ?? 0.0;
    final precioPorDia = cuarto['precio_por_dia']?.toDouble() ?? 0.0;

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
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tipo == 'cabaña' ? Icons.cabin : Icons.hotel,
                        color: Colors.green[700],
                        size: isTablet ? 20 : 16,
                      ),
                      SizedBox(width: isTablet ? 8 : 4),
                      Text(
                        '$tipo $numero',
                        style: TextStyle(
                          color: Colors.green[700],
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
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                  ),
                  child: Text(
                    'DISPONIBLE',
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

            // Información de precios
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceRow(
                        Icons.schedule,
                        'Por Hora',
                        '\$${precioPorHora.toStringAsFixed(2)}',
                        isTablet,
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      _buildPriceRow(
                        Icons.calendar_today,
                        'Por Día',
                        '\$${precioPorDia.toStringAsFixed(2)}',
                        isTablet,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: isTablet ? 20 : 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showReservarDialog(cuarto, 'por_hora'),
                    icon: Icon(Icons.schedule, size: isTablet ? 18 : 16),
                    label: Text(
                      'Por Horas',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 12 : 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 12 : 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showReservarDialog(cuarto, 'por_dia'),
                    icon: Icon(Icons.calendar_today, size: isTablet ? 18 : 16),
                    label: Text(
                      'Por Días',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 12 : 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: isTablet ? 12 : 8),

            // Botón precio personalizado
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showReservarDialog(cuarto, 'personalizado'),
                icon: Icon(Icons.edit, size: isTablet ? 18 : 16),
                label: Text(
                  'Precio Personalizado',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange[700],
                  side: BorderSide(color: Colors.orange[700]!),
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    IconData icon,
    String label,
    String price,
    bool isTablet,
  ) {
    return Row(
      children: [
        Icon(icon, size: isTablet ? 18 : 16, color: Colors.grey[600]),
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
        Text(
          price,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: Colors.green[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showReservarDialog(Map<String, dynamic> cuarto, String modalidad) {
    final numero = cuarto['numero'] ?? 'S/N';
    final tipo = cuarto['tipo_habitacion'] ?? 'Cuarto';
    final cuartoId = cuarto['id'];

    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController precioController = TextEditingController();

    // Pre-llenar precio si no es personalizado
    if (modalidad != 'personalizado') {
      final precio = modalidad == 'por_hora'
          ? cuarto['precio_por_hora']?.toDouble() ?? 0.0
          : cuarto['precio_por_dia']?.toDouble() ?? 0.0;
      precioController.text = precio.toStringAsFixed(2);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reservar $tipo $numero'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Modalidad: ${modalidad.replaceAll('_', ' ').toUpperCase()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                SizedBox(height: 16),

                // Campo cantidad
                TextField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: modalidad == 'por_hora'
                        ? 'Número de horas'
                        : modalidad == 'por_dia'
                        ? 'Número de días'
                        : 'Cantidad',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      modalidad == 'por_hora'
                          ? Icons.schedule
                          : modalidad == 'por_dia'
                          ? Icons.calendar_today
                          : Icons.numbers,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Campo precio (editable solo si es personalizado)
                TextField(
                  controller: precioController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  enabled: modalidad == 'personalizado',
                  decoration: InputDecoration(
                    labelText: modalidad == 'personalizado'
                        ? 'Precio por unidad'
                        : 'Precio establecido',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                    suffix: Text(
                      modalidad == 'por_hora'
                          ? '/hora'
                          : modalidad == 'por_dia'
                          ? '/día'
                          : '/unidad',
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Mostrar total calculado
                ValueListenableBuilder(
                  valueListenable: cantidadController,
                  builder: (context, value, child) {
                    final cantidad = int.tryParse(cantidadController.text) ?? 0;
                    final precio =
                        double.tryParse(precioController.text) ?? 0.0;
                    final total = cantidad * precio;

                    return Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total estimado:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final cantidad = int.tryParse(cantidadController.text) ?? 0;
                final precio = double.tryParse(precioController.text) ?? 0.0;

                if (cantidad > 0 && precio > 0) {
                  Navigator.of(context).pop();
                  _crearSolicitud(cuartoId, modalidad, cantidad, precio);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor ingresa valores válidos'),
                      backgroundColor: Colors.red[600],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              child: Text('Confirmar Reserva'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _crearSolicitud(
    int cuartoId,
    String modalidad,
    int cantidad,
    double precio,
  ) async {
    try {
      await _dbHelper.createSolicitud(
        cuartoId: cuartoId,
        modalidad: modalidad,
        horas: modalidad == 'por_hora' ? cantidad : null,
        dias: modalidad == 'por_dia' ? cantidad : null,
        precioPersonalizado: modalidad == 'personalizado' ? precio : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reserva creada exitosamente',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green[600],
            duration: Duration(seconds: 2),
          ),
        );

        // Refrescar la pantalla
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al crear reserva: $e',
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
