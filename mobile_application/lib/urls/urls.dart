import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_application/styles.dart';
import 'package:mobile_application/urls/urls_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar URLs'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
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
                  final urlsService = UrlsService();
                  const urls = ['aaaaaa', 'bbbbbb', 'cccccc'];
                  urlsService.urlConvert(urls).then((success) {
                    if (success) {
                      Get.snackbar('Éxito', 'URLs convertidas a PDF',
                          backgroundColor: Colors.green[100],
                          colorText: Colors.black);
                          Get.toNamed('/descargarUrls');
                    } else {
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