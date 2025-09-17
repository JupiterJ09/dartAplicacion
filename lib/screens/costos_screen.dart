import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';

class CostosScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const CostosScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<CostosScreen> createState() => _CostosScreenState();
}

class _CostosScreenState extends State<CostosScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _descripcionController = TextEditingController();
  
  DateTime _fechaSeleccionada = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _montoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return WillPopScope(
      onWillPop: () async {
        widget.onNavigate('menu');
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
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(isTablet ? 32 : 20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo Monto
                          _buildMontoField(isTablet),
                          
                          SizedBox(height: isTablet ? 32 : 24),
                          
                          // Campo Fecha
                          _buildFechaField(isTablet),
                          
                          SizedBox(height: isTablet ? 32 : 24),
                          
                          // Campo Descripción
                          _buildDescripcionField(isTablet),
                          
                          SizedBox(height: isTablet ? 40 : 32),
                          
                          // Botones
                          _buildBotones(isTablet),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMontoField(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monto *',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _montoController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              prefixIcon: Icon(
                Icons.attach_money,
                color: Colors.green[600],
                size: isTablet ? 28 : 24,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 20 : 16,
              ),
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: isTablet ? 18 : 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El monto es obligatorio';
              }
              final monto = double.tryParse(value);
              if (monto == null || monto <= 0) {
                return 'Ingresa un monto válido mayor a 0';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFechaField(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () => _seleccionarFecha(context),
              child: Container(
                height: isTablet ? 60 : 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.green[600],
                        size: isTablet ? 28 : 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _formatearFecha(_fechaSeleccionada),
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[400],
                        size: isTablet ? 28 : 24,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDescripcionField(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción *',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _descripcionController,
            maxLines: isTablet ? 6 : 4,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
            ),
            decoration: InputDecoration(
              hintText: 'Describe el gasto (ej: Compra de productos de limpieza, reparación de tubería, etc.)',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La descripción es obligatoria';
              }
              if (value.trim().length < 5) {
                return 'La descripción debe tener al menos 5 caracteres';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBotones(bool isTablet) {
    return Column(
      children: [
        // Botón Ver Gastos
        SizedBox(
          width: double.infinity,
          height: isTablet ? 50 : 44,
          child: ElevatedButton.icon(
            onPressed: () => widget.onNavigate('lista_gastos'),
            icon: Icon(
              Icons.list_alt,
              size: isTablet ? 20 : 18,
            ),
            label: Text(
              'Ver Lista de Gastos',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.orange[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              ),
            ),
          ),
        ),
        
        SizedBox(height: isTablet ? 16 : 12),
        
        // Botón Guardar
        SizedBox(
          width: double.infinity,
          height: isTablet ? 60 : 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _guardarGasto,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.green[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    height: isTablet ? 24 : 20,
                    width: isTablet ? 24 : 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save,
                        size: isTablet ? 24 : 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Guardar Gasto',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        
        SizedBox(height: isTablet ? 16 : 12),
        
        // Botón Limpiar
        SizedBox(
          width: double.infinity,
          height: isTablet ? 50 : 44,
          child: OutlinedButton(
            onPressed: _isLoading ? null : _limpiarFormulario,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[400]!, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.clear,
                  size: isTablet ? 20 : 18,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8),
                Text(
                  'Limpiar',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    try {
      final DateTime? fechaSeleccionada = await showDatePicker(
        context: context,
        initialDate: _fechaSeleccionada,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(Duration(days: 365)),
        helpText: 'Seleccionar fecha',
        cancelText: 'Cancelar',
        confirmText: 'Aceptar',
      );

      if (fechaSeleccionada != null && mounted) {
        setState(() {
          _fechaSeleccionada = fechaSeleccionada;
        });
      }
    } catch (e) {
      print('Error al seleccionar fecha: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir el selector de fecha'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _formatearFecha(DateTime fecha) {
    final meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final monto = double.parse(_montoController.text);
      final descripcion = _descripcionController.text.trim();
      final fechaString = _fechaSeleccionada.toIso8601String().split('T')[0];

      await _dbHelper.createGasto(
        monto: monto,
        descripcion: descripcion,
        fecha: fechaString,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Gasto registrado correctamente',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16),
          ),
        );

        _limpiarFormulario();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Error al guardar el gasto: $e',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _limpiarFormulario() {
    _montoController.clear();
    _descripcionController.clear();
    setState(() {
      _fechaSeleccionada = DateTime.now();
    });
  }
}