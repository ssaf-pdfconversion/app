import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_application/styles.dart';
import 'package:mobile_application/urls/urls_service.dart';
import 'package:mobile_application/descargas/descargas_service.dart';

class DescargarUrls extends StatefulWidget {
  const DescargarUrls({super.key});

  @override
  _DescargarUrlsState createState() => _DescargarUrlsState();
}

class _DescargarUrlsState extends State<DescargarUrls> {
  final UrlsService urlsService = UrlsService();
  final DescargasService descargasService = DescargasService();
  bool _isLoading = false;
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
              const Text(
                'Tus páginas web han sido convertidas a PDF y estan listos para descargar',
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
                  final archivosBase64 = await urlsService.getUrls();
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
                onPressed: () async {
                  await UrlsService().delatePdfs();
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
