import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const MenuScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return WillPopScope(
      onWillPop: () async {
        onNavigate('home');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.green[600],
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Row(
                  children: [
                    Text(
                      'Opciones',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => onNavigate('home'),
                      child: Icon(
                        Icons.arrow_back, 
                        color: Colors.white,
                        size: isTablet ? 28 : 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(isTablet ? 24 : 16),
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(isTablet ? 32 : 20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMenuItem('Graficas', 'graficas', isTablet),
                      _buildMenuItem('Costos', 'costos', isTablet),
                      _buildMenuItem('Configuración', 'configuracion', isTablet),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Icon(
                  Icons.settings, 
                  color: Colors.white, 
                  size: isTablet ? 28 : 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String section, bool isTablet) {
    return GestureDetector(
      onTap: () => onNavigate(section),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 20 : 16,
          horizontal: isTablet ? 24 : 16,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: isTablet ? 24 : 16, 
          vertical: isTablet ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}