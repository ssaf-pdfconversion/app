import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:mobile_application/styles.dart';
import 'package:mobile_application/documentos/documentos_service.dart';

class Documentos extends StatefulWidget{
  const Documentos({super.key});

  @override
  State<Documentos> createState() => _DocumentosState();
}

class _DocumentosState extends State<Documentos>{
  final DocService documentosService = DocService();
  final bool cargando = false;

  List<String> _fileNames = [];
  final List<File> _files = [];

  Future<void> _openFileExplorer() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
    );

    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (!_fileNames.contains(file.name)) {
            _fileNames.add(file.name);
          }
          if (!_files.any((f) => f.path == file.path)) {
            _files.add(File(file.path!));
          }
        }
      });
    } else {
      // Usuario canceló la selección
      setState(() {
        _fileNames = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Archivos'),
      backgroundColor: Colors.deepPurple[300],
      foregroundColor: Colors.white,
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
              child: _fileNames.isNotEmpty
                  ? ListView.builder(
                      itemCount: _fileNames.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(_fileNames[index]),
                        );
                      },
                    )
                  : const SizedBox(),
        ),
        if(_fileNames.isNotEmpty)
          ElevatedButton(
            onPressed: () {
                  documentosService.officeConvert(_fileNames,_files).then((success) {
                    if (success) {
                      Get.snackbar('Éxito', 'URLs convertidas a PDF',
                          backgroundColor: Colors.green[100],
                          colorText: Colors.black);
                          Get.toNamed('/descargarDocs');
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
      )
    ),

  );
  }
  
}