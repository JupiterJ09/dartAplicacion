import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// App principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true, // 👈 Aquí sí es válido
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

// Página principal
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi primer proyecto'),
        backgroundColor: const Color.fromARGB(255, 55, 156, 75),
        actions: const [Icon(Icons.access_alarm)],
      ),
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 39, 94, 131),
          width: 350,
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hola Mundo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  wordSpacing: 17.0
                ),
              ),
              const SizedBox(height: 20), // Espacio entre texto y botón
              ElevatedButton(
                onPressed: () {
                  // Aquí navega a la nueva pantalla
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecondPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: const Text('Ir a otra vista'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Segunda página
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segunda página'),
        backgroundColor: Colors.amber,
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
