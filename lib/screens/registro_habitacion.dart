import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RegistroScreen extends StatefulWidget {
  final Function(String)? onNavigate;
  
  const RegistroScreen({Key? key, this.onNavigate}) : super(key: key);

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
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
                  if (widget.onNavigate != null)
                    IconButton(
                      onPressed: () => widget.onNavigate!('home'),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: isTablet ? 32 : 24,
                      ),
                    ),
                  SizedBox(width: isTablet ? 16 : 8),
                  Text(
                    'Gestión de Cuartos',
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
                  future: _getTodosCuartos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                            SizedBox(height: 16),
                            Text('Error al cargar datos', style: TextStyle(color: Colors.red[600])),
                          ],
                        ),
                      );
                    }

                    final cuartos = snapshot.data ?? [];

                    if (cuartos.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.hotel_outlined, size: 80, color: Colors.grey[400]),
                            SizedBox(height: 24),
                            Text(
                              'No hay cuartos registrados',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Presiona + para agregar el primer cuarto',
                              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(isTablet ? 24 : 16),
                      itemCount: cuartos.length,
                      itemBuilder: (context, index) {
                        final cuarto = cuartos[index];
                        return _buildCuartoItem(cuarto, isTablet);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormularioCuarto(),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text('Nuevo Cuarto'),
      ),
    );
  }

  Widget _buildCuartoItem(Map<String, dynamic> cuarto, bool isTablet) {
    final numero = cuarto['numero'] ?? 'S/N';
    final tipo = cuarto['tipo_habitacion'] ?? 'Cuarto';
    final precioPorHora = cuarto['precio_por_hora']?.toDouble() ?? 0.0;
    final precioPorDia = cuarto['precio_por_dia']?.toDouble() ?? 0.0;
    final estado = cuarto['estado'] ?? 'disponible';

    // Configurar colores según estado
    Color? estadoColor;
    String estadoTexto;
    
    switch (estado) {
      case 'disponible':
        estadoColor = Colors.green[600];
        estadoTexto = 'DISPONIBLE';
        break;
      case 'ocupado':
        estadoColor = Colors.red[600];
        estadoTexto = 'OCUPADO';
        break;
      case 'limpieza':
        estadoColor = Colors.blue[600];
        estadoTexto = 'LIMPIEZA';
        break;
      case 'mantenimiento':
        estadoColor = Colors.orange[600];
        estadoTexto = 'MANTENIMIENTO';
        break;
      default:
        estadoColor = Colors.grey[600];
        estadoTexto = estado.toUpperCase();
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
                    color: estadoColor?.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tipo == 'cabaña' ? Icons.cabin : Icons.hotel,
                        color: estadoColor,
                        size: isTablet ? 20 : 16,
                      ),
                      SizedBox(width: isTablet ? 8 : 4),
                      Text(
                        '$tipo $numero',
                        style: TextStyle(
                          color: estadoColor,
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
                    color: estadoColor,
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

            SizedBox(height: isTablet ? 16 : 12),

            // Información de precios
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.schedule, 'Por Hora', '\$${precioPorHora.toStringAsFixed(2)}', isTablet),
                      SizedBox(height: isTablet ? 8 : 6),
                      _buildInfoRow(Icons.calendar_today, 'Por Día', '\$${precioPorDia.toStringAsFixed(2)}', isTablet),
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
                  child: OutlinedButton.icon(
                    onPressed: () => _mostrarFormularioCuarto(cuarto: cuarto),
                    icon: Icon(Icons.edit, size: isTablet ? 18 : 16),
                    label: Text(
                      'Editar',
                      style: TextStyle(fontSize: isTablet ? 14 : 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue[700],
                      side: BorderSide(color: Colors.blue[700]!),
                      padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 10),
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 12 : 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: estado == 'disponible' 
                        ? () => _confirmarEliminar(cuarto)
                        : null,
                    icon: Icon(Icons.delete, size: isTablet ? 18 : 16),
                    label: Text(
                      'Eliminar',
                      style: TextStyle(fontSize: isTablet ? 14 : 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: estado == 'disponible' ? Colors.red[600] : Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isTablet) {
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
          value,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
      ],
    );
  }

  void _mostrarFormularioCuarto({Map<String, dynamic>? cuarto}) {
    final isEditing = cuarto != null;
    final numeroController = TextEditingController(text: cuarto?['numero'] ?? '');
    final precioPorHoraController = TextEditingController(
      text: cuarto != null ? cuarto['precio_por_hora'].toString() : '',
    );
    final precioPorDiaController = TextEditingController(
      text: cuarto != null ? cuarto['precio_por_dia'].toString() : '',
    );
    
    String tipoSeleccionado = cuarto?['tipo_habitacion'] ?? 'cuarto';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar Cuarto' : 'Nuevo Cuarto'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: numeroController,
                      decoration: InputDecoration(
                        labelText: 'Número del cuarto',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 16),
                    
                    DropdownButtonFormField<String>(
                      value: tipoSeleccionado,
                      decoration: InputDecoration(
                        labelText: 'Tipo de habitación',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.hotel),
                      ),
                      items: [
                        DropdownMenuItem(value: 'cuarto', child: Text('Cuarto')),
                        DropdownMenuItem(value: 'cabaña', child: Text('Cabaña')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          tipoSeleccionado = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    
                    TextField(
                      controller: precioPorHoraController,
                      decoration: InputDecoration(
                        labelText: 'Precio por hora',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.schedule),
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 16),
                    
                    TextField(
                      controller: precioPorDiaController,
                      decoration: InputDecoration(
                        labelText: 'Precio por día',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                    final numero = numeroController.text.trim();
                    final precioPorHora = double.tryParse(precioPorHoraController.text);
                    final precioPorDia = double.tryParse(precioPorDiaController.text);

                    if (numero.isEmpty || precioPorHora == null || precioPorDia == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor completa todos los campos'),
                          backgroundColor: Colors.red[600],
                        ),
                      );
                      return;
                    }

                    Navigator.of(context).pop();

                    if (isEditing) {
                      _actualizarCuarto(cuarto['id'], numero, tipoSeleccionado, precioPorHora, precioPorDia);
                    } else {
                      _crearCuarto(numero, tipoSeleccionado, precioPorHora, precioPorDia);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isEditing ? 'Actualizar' : 'Crear'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmarEliminar(Map<String, dynamic> cuarto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Cuarto'),
          content: Text(
            '¿Estás seguro de que deseas eliminar el ${cuarto['tipo_habitacion']} ${cuarto['numero']}?\n\nEsta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _eliminarCuarto(cuarto['id']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getTodosCuartos() async {
    final db = await _dbHelper.database;
    return await db.query('cuartos', orderBy: 'CAST(numero AS INTEGER)');
  }

  Future<void> _crearCuarto(String numero, String tipo, double precioPorHora, double precioPorDia) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('cuartos', {
        'numero': numero,
        'tipo_habitacion': tipo,
        'precio_por_hora': precioPorHora,
        'precio_por_dia': precioPorDia,
        'estado': 'disponible',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cuarto creado exitosamente'),
            backgroundColor: Colors.green[600],
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().contains('UNIQUE') ? 'El número de cuarto ya existe' : e.toString()}'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  Future<void> _actualizarCuarto(int id, String numero, String tipo, double precioPorHora, double precioPorDia) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'cuartos',
        {
          'numero': numero,
          'tipo_habitacion': tipo,
          'precio_por_hora': precioPorHora,
          'precio_por_dia': precioPorDia,
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cuarto actualizado exitosamente'),
            backgroundColor: Colors.green[600],
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().contains('UNIQUE') ? 'El número de cuarto ya existe' : e.toString()}'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  Future<void> _eliminarCuarto(int id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('cuartos', where: 'id = ?', whereArgs: [id]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cuarto eliminado exitosamente'),
            backgroundColor: Colors.green[600],
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }
}