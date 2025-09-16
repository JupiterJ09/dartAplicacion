import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
//import 'screens/registro_habitacion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Habitaciones',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}