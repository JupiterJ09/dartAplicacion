import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'graficas_screen.dart';
import 'costos_screen.dart';
import 'en_uso_screen.dart';
import 'libres_screen.dart';
import 'mantenimiento_screen.dart';
import 'historial_screen.dart';
import 'registro_habitacion.dart'; 
import 'lista_gastos_screen.dart';
import 'package:flutter/services.dart'; // para SystemNavigator

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String _currentSection = 'home';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        body: _getCurrentScreen(),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

Future<bool> _onWillPop() async {
  if (_currentSection != 'home') {
    _navigateToSection('home');
    return false;
  }

  final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Salir'),
          content: Text('¿Quieres salir de la app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Sí'),
            ),
          ],
        ),
      ) ?? false;

  if (shouldExit) {
    SystemNavigator.pop();     // cierra la app correctamente
    return false;              // evita un pop extra que dejaría pantalla negra
  }
  return false;
}

  Widget _getCurrentScreen() {
    switch (_currentSection) {
      case 'home':
        return HomeScreen(onNavigate: _navigateToSection);
      case 'en_uso':
        return EnUsoScreen(onNavigate: _navigateToSection);
      case 'libres':
        return LibresScreen(onNavigate: _navigateToSection);
      case 'mantenimiento':
        return MantenimientoScreen(onNavigate: _navigateToSection);
      case 'historial':
        return HistorialScreen(onNavigate: _navigateToSection);
      case 'graficas':
        return GraficasScreen(onNavigate: _navigateToSection);
      case 'costos':
        return CostosScreen(onNavigate: _navigateToSection);
      case 'registro':
       return RegistroScreen(onNavigate: _navigateToSection);
        break;
        case 'lista_gastos':
       return ListaGastosScreen(onNavigate: _navigateToSection);
        break;
      default:
        return HomeScreen(onNavigate: _navigateToSection);
    }
  }

  void _navigateToSection(String section) {
    setState(() {
      _currentSection = section;
      HapticFeedback.lightImpact();

      switch (section) {
        case 'home':
          _currentIndex = 0;
          break;
        case 'en_uso':
          _currentIndex = 1;
          break;
        case 'libres':
          _currentIndex = 2;
          break;
        case 'mantenimiento':
          _currentIndex = 3;
          break;
        case 'historial':
          break;
        default:
          break;
      }
    });
  }

  Widget? _buildBottomNav() {
    if ([
      'menu',
      'configuracion',
      'graficas',
      'costos',
    ].contains(_currentSection)) {
      return null;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.home, 0, 'home'),
              _buildBottomNavItem(Icons.people, 1, 'en_uso'),
              _buildBottomNavItem(Icons.meeting_room_outlined, 2, 'libres'),
              _buildBottomNavItem(Icons.build, 3, 'mantenimiento'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, int index, String section) {
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _navigateToSection(section),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Transform.scale(
          scale: isSelected ? 1.1 : 1.0, // 10% más grande si está seleccionado
          child: Icon(
            icon,
            color: isSelected ? Colors.green[700] : Colors.grey[600],
            size: 24,
          ),
        ),
      ),
    );
  }
}
