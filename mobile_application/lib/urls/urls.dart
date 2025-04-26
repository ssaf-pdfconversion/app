import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_application/styles.dart';
import 'package:mobile_application/urls/urls_service.dart';
import 'package:mobile_application/usuarios/cerrar_sesion.dart';

class Urls extends StatefulWidget {
  const Urls({super.key});

  @override
  State<Urls> createState() => _UrlsState();
}

class _UrlsState extends State<Urls> {
  final TextEditingController _urlController = TextEditingController();
  final List<String> _urls = [];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _addUrl() {
    final String url = _urlController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _urls.add(url);
      });
      _urlController.clear();
    }
  }

  void showLoadingDialog(BuildContext context, { String text = 'Cargando…' }) {
  showDialog(
    context: context,
    barrierDismissible: false, // impide cerrar al pulsar fuera
    // ignore: deprecated_member_use
    builder: (_) => WillPopScope( // opcional: bloquea botón “atrás”
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(text, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    ),
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar URLs'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
         actions: [
          CerrarSesion()
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
            'Convertir URLs a PDF',
            style: TextStyle(fontSize: 23,
            fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
            
            
            ),
          const SizedBox(height: 10),
            Text('Convierte tus página web a PDF'),
            const SizedBox(height: 10),
            // Cuadro de texto para escribir la URL
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Escribe la URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Botón para añadir la URL
            ElevatedButton(
              onPressed: _addUrl,
              style: CustomButtonStyle.primaryStyle,
              child: const Text('Añadir URL'),
            ),
            const SizedBox(height: 20),
            // Lista de URLs agregadas
            Expanded(
              child: _urls.isNotEmpty
                  ? ListView.builder(
                      itemCount: _urls.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.link),
                          title: Text(_urls[index]),
                        );
                      },
                    )
                    
                  : const SizedBox(),
            ),
            if(_urls.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  showLoadingDialog(context);
                  final urlsService = UrlsService();
                  urlsService.urlConvert(_urls).then((success) {
                    if (success) {
                      // ignore: use_build_context_synchronously
                      hideLoadingDialog(context);
                      Get.snackbar('Éxito', 'URLs convertidas a PDF',
                          backgroundColor: Colors.green[100],
                          colorText: Colors.black);
                          Get.toNamed('/descargarUrls');
                    } else {
                       // ignore: use_build_context_synchronously
                      hideLoadingDialog(context);
                      Get.snackbar('Error', 'No se pudo convertir las URLs',
                          backgroundColor: Colors.red[100],
                          colorText: Colors.black);
                    }
                  });
                
                },
                style: CustomButtonStyle.primaryStyle,
                child: const Text('Convertir a PDF'),
              ),
          ],
        ),
      ),
    );
  }
}