import 'package:flutter/material.dart';

// Segunda página
class CostPage extends StatelessWidget {
  const CostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Costos'),
        backgroundColor: const Color.fromARGB(255, 55, 156, 75),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '¡Bienvenido a la segunda página!',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}