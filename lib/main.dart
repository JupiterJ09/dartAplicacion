import 'package:flutter/material.dart';
import 'package:prueba/widgets/home.dart';
import 'package:prueba/widgets/customDrawer.dart';

void main() {
  runApp(const MyApp());
}

// App principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
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
        title: const Text('Mi Hotel'),
        backgroundColor: const Color.fromARGB(255, 55, 156, 75)
      ),
      
      drawer: const CustomDrawer(),
      body: const Home(),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 55, 156, 75),
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person), onPressed: () {}),
            IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}