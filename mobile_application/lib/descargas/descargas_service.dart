import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


class DescargasService{
  Future<bool> dowlandPdfs(List<String> lista) async {
    try{
      final Directory? directory = await getDownloadsDirectory();
    final now = DateTime.now();
    final String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);

    for (int i =0; i<lista.length; i++){
      final String pdf = lista[i];
      final bytes = base64Decode(pdf);

      final String fileName = '$formattedDate$i.pdf';
      final String filePath = '${directory?.path}/$fileName';

      final File file = File(filePath);
      await file.writeAsBytes(bytes); 
    }
    return true;
    }
    catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return false;
    }

  }
}