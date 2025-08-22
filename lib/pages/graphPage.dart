import 'package:flutter/material.dart';

// Segunda página
class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graficas'),
        backgroundColor: const Color.fromARGB(255, 55, 156, 75),
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