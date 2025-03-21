import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_application/styles.dart';

class Menu extends StatelessWidget{
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSquareButton(
                icon: Icons.folder,
                text: 'Convertir Archivos',
                onPressed: () {
                  Get.toNamed('/documentos');
                },
              ),
              const SizedBox(height: 20),
              CustomSquareButton(
                icon: Icons.link,
                text: 'Convertir URLs',
                onPressed: () {
                  Get.toNamed('/urls');// Acción para convertir URLs
                },
              ),
              const SizedBox(height: 20),
              CustomSquareButton(
                icon: Icons.show_chart,
                text: 'Métricas',
                onPressed: () {
                  Get.toNamed('/metricas');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}