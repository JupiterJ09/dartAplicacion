import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'menu_screen.dart';
import 'configuracion_screen.dart';
import 'graficas_screen.dart';
import 'costos_screen.dart';
import 'en_uso_screen.dart';
import 'libres_screen.dart';
import 'mantenimiento_screen.dart';
import 'historial_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String _currentSection = 'home';
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
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
    return true;
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
      case 'menu':
        return MenuScreen(onNavigate: _navigateToSection);
      case 'configuracion':
        return ConfiguracionScreen(onNavigate: _navigateToSection);
      case 'graficas':
        return GraficasScreen(onNavigate: _navigateToSection);
      case 'costos':
        return CostosScreen(onNavigate: _navigateToSection);
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
        case 'libres':
        case 'mantenimiento':
        case 'historial':
          _currentIndex = 1;
          break;
        default:
          break;
      }
    });
  }

  Widget? _buildBottomNav() {
    if (['menu', 'configuracion', 'graficas', 'costos'].contains(_currentSection)) {
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
              _buildBottomNavItem(Icons.car_rental, 2, 'libres'),
              _buildBottomNavItem(Icons.settings, 3, 'menu'),
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
        child: Icon(
          icon,
          color: isSelected ? Colors.green[700] : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}