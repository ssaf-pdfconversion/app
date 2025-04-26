import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_application/usuarios/cerrar_sesion.dart';

import 'package:mobile_application/styles.dart';
import 'package:mobile_application/descargas/descargas_service.dart';
import 'package:mobile_application/documentos/documentos_service.dart';

class Descargar extends StatefulWidget {
  const Descargar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DescargarState createState() => _DescargarState();
}

class _DescargarState extends State<Descargar> {
  final DocService documentosService = DocService();
  final DescargasService descargasService = DescargasService();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descargar Archivos'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
        actions: [
          CerrarSesion()
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Tus archivos office han sido convertidos a PDF y estan listos para descargar',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  final archivosBase64 = await documentosService.getOffice();
                  if (archivosBase64 != null) {
                    final succes = await descargasService.dowlandPdfs(archivosBase64);
                    if(succes) {
                      setState(() {
                        _isLoading = false;
                      });
                      Get.snackbar('Éxito', 'Archivos descargados correctamente',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                    } else {
                      Get.snackbar('Error', 'Error al descargar los archivos',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                    }
                  } else {
                    Get.snackbar('Error', 'No se encontraron archivos para descargar',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                  }
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
              const SizedBox(height: 20),
              _isLoading 
              ? Column(children: [
                CircularProgressIndicator(
                backgroundColor: Colors.deepPurple[100],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                strokeWidth: 5,
              )
              , const SizedBox(height: 10),
              const Text('Descargando archivos...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
              ],)
              : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
