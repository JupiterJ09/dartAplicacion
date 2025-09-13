import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const HomeScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isLandscape = size.width > size.height;
    
    return Container(
      color: Colors.green[600],
      width: double.infinity,
      height: size.height, // Altura completa de la pantalla
      child: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
            _buildTopMenu(context, isTablet),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  isTablet ? 32 : 16,
                  isTablet ? 24 : 16,
                  isTablet ? 32 : 16,
                  isTablet ? 32 : 80, // Más espacio para la bottom navigation
                ),
                padding: EdgeInsets.all(isTablet ? 32 : 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isTablet ? 32 : 24),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = isTablet 
                        ? (constraints.maxWidth - 24) / 2 
                        : (constraints.maxWidth - 16) / 2;
                    final cardHeight = isTablet ? 160.0 : 120.0;
                    
                    return SingleChildScrollView( // Hace scrolleable el contenido
                      child: Column(
                        children: [
                          SizedBox(height: isTablet ? 20 : 16),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildHomeCard(
                                Icons.people, 
                                '5', 
                                Colors.green[100]!, 
                                cardWidth,
                                cardHeight,
                                isTablet,
                              ),
                              _buildHomeCard(
                                Icons.bed, 
                                '1', 
                                Colors.green[100]!, 
                                cardWidth,
                                cardHeight,
                                isTablet,
                              ),
                            ],
                          ),
                          
                          SizedBox(height: isTablet ? 32 : 24),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildHomeCard(
                                Icons.build, 
                                '2', 
                                Colors.green[100]!, 
                                cardWidth,
                                cardHeight,
                                isTablet,
                              ),
                              _buildHomeCard(
                                Icons.attach_money, 
                                r'$1400', 
                                Colors.green[100]!, 
                                cardWidth,
                                cardHeight,
                                isTablet,
                              ),
                            ],
                          ),
                          
                          SizedBox(height: isTablet ? 40 : 32),
                          
                          _buildHistorialButton(isTablet),
                          
                          SizedBox(height: isTablet ? 32 : 24), // Espaciado final
                        ],
                      ),
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

  Widget _buildStatusBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '12:01',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Icon(Icons.battery_std, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text('40%', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopMenu(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 20 : 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onNavigate('menu'),
            child: Icon(
              Icons.menu, 
              color: Colors.white, 
              size: isTablet ? 32 : 28,
            ),
          ),
          Spacer(),
          Container(
            height: isTablet ? 48 : 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildMenuTab('home', 'home', true, isTablet, onNavigate),
                buildMenuTab('En uso', 'en_uso', false, isTablet, onNavigate),
                buildMenuTab('Libres', 'libres', false, isTablet, onNavigate),
                buildMenuTab('Mantenimiento', 'mantenimiento', false, isTablet, onNavigate),
                buildMenuTab('Historial', 'historial', false, isTablet, onNavigate),
              ],
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios, 
            color: Colors.yellow, 
            size: isTablet ? 28 : 24,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeCard(IconData icon, String text, Color color, double width, double height, bool isTablet) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, 
            size: isTablet ? 40 : 32, 
            color: Colors.green[700],
          ),
          SizedBox(height: isTablet ? 12 : 8),
          FittedBox(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialButton(bool isTablet) {
    return GestureDetector(
      onTap: () => onNavigate('historial'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 20 : 16,
          horizontal: isTablet ? 24 : 20,
        ),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history, 
              size: isTablet ? 32 : 28, 
              color: Colors.green[700],
            ),
            SizedBox(width: 12),
            Text(
              'Historial',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}