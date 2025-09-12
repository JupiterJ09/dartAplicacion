import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class CostosScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const CostosScreen({Key? key, required this.onNavigate}) : super(key: key);

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
              buildHeader('Costos', context, isTablet, () => onNavigate('menu')),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(isTablet ? 24 : 16),
                  padding: EdgeInsets.all(isTablet ? 32 : 20),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(isTablet ? 32 : 20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCostField('Monto', false, isTablet),
                        SizedBox(height: isTablet ? 32 : 24),
                        _buildCostField('Fecha', true, isTablet),
                        SizedBox(height: isTablet ? 32 : 24),
                        Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: isTablet ? 12 : 8),
                        Container(
                          width: double.infinity,
                          height: isTablet ? 200 : 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(isTablet ? 16 : 8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildCostField(String label, bool hasIcon, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Container(
          height: isTablet ? 60 : 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: hasIcon 
            ? Row(
                children: [
                  Expanded(child: Container()),
                  Padding(
                    padding: EdgeInsets.all(isTablet ? 16 : 8),
                    child: Icon(
                      Icons.calendar_today, 
                      color: Colors.grey[600],
                      size: isTablet ? 24 : 20,
                    ),
                  ),
                ],
              )
            : null,
        ),
      ],
    );
  }
}