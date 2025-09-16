import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const HomeScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return Container(
      color: Colors.green[600],
      width: double.infinity,
      height: size.height,
      child: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: Container(
                // Márgenes iguales en todos los lados
                margin: EdgeInsets.all(isTablet ? 24 : 20),
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
                    
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: isTablet ? 20 : 16),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildHomeCard(Icons.people,
                               '5',
                                Colors.green[100]!, 
                                cardWidth, 
                                cardHeight, 
                                isTablet, 
                              () => onNavigate('en_uso')),

                              _buildHomeCard(
                                Icons.bed, 
                                '1', 
                                Colors.green[100]!, 
                                cardWidth,
                                cardHeight,
                                isTablet,
                                () => onNavigate('libres')
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
                                () => onNavigate('mantenimiento')
                              ),
                              _buildHomeCard(
                                Icons.attach_money, 
                                r'$1400', 
                                Colors.green[100]!, 
                                cardWidth,
                                cardHeight,
                                isTablet,
                                () => onNavigate('graficas')
                              ),
                            ],
                          ),
                          
                          SizedBox(height: isTablet ? 40 : 32),
                          
                          _buildHomeCard(
                                Icons.history, 
                                r'$1400', 
                                Colors.green[100]!, 
                                double.infinity,
                                cardHeight,
                                isTablet,
                                () => onNavigate('historial')
                              ),
                          
                          SizedBox(height: isTablet ? 32 : 24),
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


Widget _buildHomeCard(
  IconData icon, 
  String text, 
  Color color, 
  double width, 
  double height, 
  bool isTablet,
  VoidCallback? onTap,
) {
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
    child: Material(                     
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        child: Container(
          width: width,
          height: height,
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
        ),
      ),
    ),
  );
}
}