import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:mobile_application/styles.dart';
import 'package:mobile_application/documentos/documentos_service.dart';
import 'package:mobile_application/usuarios/cerrar_sesion.dart';

class Documentos extends StatefulWidget{
  const Documentos({super.key});

  @override
  State<Documentos> createState() => _DocumentosState();
}


class _DocumentosState extends State<Documentos>{
  final DocService documentosService = DocService();
  final bool cargando = false;

   List<String> fileNames = [];

  List<File> files = [];

  Future<void> _openFileExplorer() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
  );

  if (result != null) {
    print('Entro al primer if');
    print(result.paths);
    final temporaryFiles = result.paths
        .where((path) => path != null)
        .map((path) => File(path!))
        .toList();

    setState(() {
      for (var file in temporaryFiles) {
        if (!files.contains(file)) {
          files.add(file);
          fileNames.add(file.path.split('/').last);
        }
      }print(files);
      print(fileNames);
    });
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
      title: const Text('Archivos'),
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
        Text(
          'Convertir Archivos a PDF',
          style: TextStyle(fontSize: 23,
          fontWeight: FontWeight.bold,),
          textAlign: TextAlign.center,
          
        ),
        const SizedBox(height: 10),
        Text('Convierte tus archivos office a PDF'),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: _openFileExplorer,
          style: CustomButtonStyle.primaryStyle,
          child: Text('Selecciona tus Archivos',),
        ),
        Expanded(
              child: fileNames.isNotEmpty
                  ? ListView.builder(
                      itemCount: fileNames.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(fileNames[index]),
                        );
                      },
                    )
                  : const SizedBox( child:
                    Text('No hay archivos seleccionados',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
        ),
        if(fileNames.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              showLoadingDialog(context, text: 'Convirtiendo...'); // ignore: use_build_context_synchronously
                      
                  documentosService.officeConvert(fileNames,files).then((success) {
                    if (success) {
                      hideLoadingDialog(context); // ignore: use_build_context_synchronously
                      Get.snackbar('Éxito', 'URLs convertidas a PDF',
                          backgroundColor: Colors.green[100],
                          colorText: Colors.black);
                          Get.toNamed('/descargarDocs');
                    } else {
                      hideLoadingDialog(context); // ignore: use_build_context_synchronously
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
      )
    ),

  );
  }
  
}