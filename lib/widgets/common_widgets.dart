import 'package:flutter/material.dart';

// Widget para headers con título
Widget buildHeader(String title, BuildContext context, bool isTablet, VoidCallback onBack) {
  return Container(
    padding: EdgeInsets.all(isTablet ? 24 : 16),
    child: Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: isTablet ? 32 : 28,
          ),
        ),
        Spacer(),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
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



// Widget para botones de tabs del menú
Widget buildMenuTab(String label, String section, bool isActive, bool isTablet, Function(String) onNavigate) {
  return GestureDetector(
    onTap: () => onNavigate(section),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.green[600] : Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: isTablet ? 14 : 12,
        ),
      ),
    ),
  );
}

// Widget para elementos de habitación
Widget buildRoomItem(String title, IconData icon, Color iconColor, bool isTablet) {
  return Container(
    margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
    padding: EdgeInsets.all(isTablet ? 20 : 16),
    decoration: BoxDecoration(
      color: Colors.green[50],
      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      border: Border.all(color: Colors.green[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(
          Icons.people,
          color: Colors.green[600],
          size: isTablet ? 28 : 24,
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.green[700],
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.all(isTablet ? 6 : 4),
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: isTablet ? 20 : 16,
          ),
        ),
      ],
    ),
  );
}

// Widget para elementos de mantenimiento
Widget buildMaintenanceItem(String title, bool isTablet) {
  return Container(
    margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
    padding: EdgeInsets.all(isTablet ? 20 : 16),
    decoration: BoxDecoration(
      color: Colors.green[50],
      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      border: Border.all(color: Colors.green[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(
          Icons.build,
          color: Colors.green[600],
          size: isTablet ? 28 : 24,
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.green[700],
          ),
        ),
        Spacer(),
        Container(
          width: isTablet ? 28 : 24,
          height: isTablet ? 28 : 24,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green[400]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(isTablet ? 6 : 4),
          ),
        ),
      ],
    ),
  );
}