import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class GraficasScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const GraficasScreen({Key? key, required this.onNavigate}) : super(key: key);

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
              buildHeader('Graficas', context, isTablet, () => onNavigate('menu')),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(isTablet ? 24 : 16),
                  padding: EdgeInsets.all(isTablet ? 32 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isTablet ? 32 : 20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ganancias',
                              style: TextStyle(
                                fontSize: isTablet ? 22 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Por:', 
                              style: TextStyle(fontSize: isTablet ? 18 : 16),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20 : 16, 
                                vertical: isTablet ? 12 : 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Dia', 
                                style: TextStyle(fontSize: isTablet ? 16 : 14),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: isTablet ? 40 : 30),
                        
                        _buildChart(isTablet ? 200 : 150, isTablet),
                        
                        SizedBox(height: isTablet ? 50 : 40),
                        
                        Center(
                          child: Text(
                            'Uso de Cuartos',
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: isTablet ? 30 : 20),
                        
                        _buildChart(isTablet ? 200 : 150, isTablet),
                      ],
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

  Widget _buildChart(double height, bool isTablet) {
    return Container(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBar(height * 0.4, Colors.teal[300]!, isTablet),
          _buildBar(height * 0.6, Colors.teal[400]!, isTablet),
          _buildBar(height * 0.8, Colors.teal[500]!, isTablet),
          _buildBar(height * 0.9, Colors.teal[600]!, isTablet),
        ],
      ),
    );
  }

  Widget _buildBar(double height, Color color, bool isTablet) {
    return Container(
      width: isTablet ? 60 : 40,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isTablet ? 8 : 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}