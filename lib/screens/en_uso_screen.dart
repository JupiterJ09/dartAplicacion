import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class EnUsoScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const EnUsoScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: SafeArea(
        child: Column(
          children: [
            buildHeaderWithTabs('En uso', context, isTablet, onNavigate),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(isTablet ? 24 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isTablet ? 32 : 20),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return buildRoomItem(
                      'Habitación ${index + 1}', 
                      Icons.close, 
                      Colors.red, 
                      isTablet,
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
}