import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class ConfiguracionScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const ConfiguracionScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return WillPopScope(
      onWillPop: () async {
        onNavigate('menu');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.green[600],
        body: SafeArea(
          child: Column(
            children: [
              buildHeader('Configuración', context, isTablet, () => onNavigate('menu')),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(isTablet ? 24 : 16),
                    padding: EdgeInsets.all(isTablet ? 32 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isTablet ? 32 : 20),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cardSize = isTablet 
                            ? constraints.maxWidth * 0.35 
                            : constraints.maxWidth * 0.4;
                        
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildConfigCard(Icons.bedroom_parent_outlined, Colors.green[100]!, cardSize, isTablet),
                                _buildConfigCard(Icons.single_bed_outlined, Colors.green[100]!, cardSize, isTablet),
                              ],
                            ),
                            SizedBox(height: isTablet ? 40 : 32),
                            _buildConfigCard(Icons.attach_money, Colors.green[100]!, cardSize * 2.2, isTablet),
                          ],
                        );
                      },
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

  Widget _buildConfigCard(IconData icon, Color color, double width, bool isTablet) {
    return Container(
      width: width,
      height: width * 0.8,
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
      child: Icon(
        icon, 
        size: width * 0.3, 
        color: Colors.green[700],
      ),
    );
  }
}