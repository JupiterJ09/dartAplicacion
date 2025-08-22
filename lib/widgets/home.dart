import 'package:flutter/material.dart';
import 'package:prueba/pages/costPage.dart';
//import 'package:prueba/pages/graphPage.dart';
//import 'package:prueba/pages/configPage.dart';
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PANTALLA PRINCIPAL',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 20), // Espacio entre texto y botón
              ElevatedButton(
                onPressed: () {
                  // Aquí navega a la nueva pantalla
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CostPage(),
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
      );
  }
}