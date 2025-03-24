import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application/styles.dart';

class Documentos extends StatefulWidget{
  const Documentos({super.key});

  @override
  State<Documentos> createState() => _DocumentosState();
}

class _DocumentosState extends State<Documentos>{

  List<String> _fileNames = [];

  Future<void> _openFileExplorer() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
    );

    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (!_fileNames.contains(file.name)) {
            _fileNames.add(file.name);
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
          child: Text('Seleccionar Archivos'),
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
              // Acción para convertir archivos
              Navigator.pushNamed(context, '/descargarDocs');
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