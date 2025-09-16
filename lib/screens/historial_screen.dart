import 'package:flutter/material.dart';

class HistorialScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const HistorialScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: SafeArea(
        child: Column(
          children: [
            
            Container(
              margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isTablet ? 16 : 12),
                  topRight: Radius.circular(isTablet ? 16 : 12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Cuarto',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Fecha',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Hora',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      r'$',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  isTablet ? 24 : 16,
                  0,
                  isTablet ? 24 : 16,
                  isTablet ? 24 : 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isTablet ? 16 : 12),
                    bottomRight: Radius.circular(isTablet ? 16 : 12),
                  ),
                ),
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(isTablet ? 16 : 12),
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.green[50] : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: isTablet ? 16 : 14),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '12/09',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: isTablet ? 16 : 14),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '14:30',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: isTablet ? 16 : 14),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              r'$50',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: isTablet ? 16 : 14),
                            ),
                          ),
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
}