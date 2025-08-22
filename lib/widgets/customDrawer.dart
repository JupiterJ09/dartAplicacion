import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header del drawer
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 55, 156, 75),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.hotel,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Mi Hotel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sistema de Gestión',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Opciones del menú
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                // Lógica para navegar al inicio
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.bed),
              title: const Text('Habitaciones'),
              onTap: () {
                Navigator.pop(context);
                // Lógica para ver habitaciones
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Huéspedes'),
              onTap: () {
                Navigator.pop(context);
                // Lógica para gestionar huéspedes
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Reservacion'),
              onTap: () {
                Navigator.pop(context);
                // Lógica para ver reservas
              },
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                // Lógica para configuración
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Ayuda'),
              onTap: () {
                Navigator.pop(context);
                // Lógica para mostrar ayuda
              },
            ),
          ],
        ),
      );
  }
}