import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mobile_application/styles.dart';

class DescargarUrls extends StatelessWidget {
  const DescargarUrls({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descargar Archivos'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),  

      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              Text(
                'Tus páginas web han sido convertidas a PDF y estan listos para descargar',
                style: TextStyle(fontSize: 23,
                fontWeight: FontWeight.bold,),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Acción para descargar archivos
                },
                style: CustomButtonStyle.primaryStyle,
                child: const Text('Descargar Archivos'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/menu');
                },
                style: CustomButtonStyle.primaryStyle,
                child: const Text('Volver al Menú'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}