import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile_application/config.dart';
import 'package:mobile_application/usuarios/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocService {
  Future<bool> officeConvert(List<String> names, List<File> files) async {
    final LoginService loginService = LoginService();
    final token = await loginService.getToken();
    final userId = await loginService.getUserId();
    final List<String> base64Files = await covertFiles64(files);
    if (token == null || userId == null) {
      return false; // Token or userId not found
    }

    print(names);
    print(base64Files);
    
    final Map<String, dynamic> data = {
      'files':  base64Files,
      'names': names,
      'userId': userId,
      
    };
    print(data);
    try{

      final response = await http.post(
        Uri.parse('http://${Config.HOST}:${Config.PORT}/officeConvert'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: json.encode(data),
        
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);

        // 1. Extraer json de 'pdfs.file', que puede ser List o Map
        final dynamic fileJson = decoded['pdfs']['file'];

        // 2. Normalizar siempre a List<dynamic>
        final List<dynamic> files = fileJson is List
            ? fileJson
            : [fileJson];

        // 3. Extraer sólo el campo 'data' de cada objeto
        final List<String> dataList = files
            .map((fileEntry) => fileEntry['data'] as String)
            .toList();

        print('PDFs convertidos (base64): $dataList');
        await saveOfiice(dataList);
        return true;
      } else if (response.statusCode == 401) {
        
        return false;
      } else{
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return false;
    }
    // Simulate a network call
    
  }

  Future<void> saveOfiice(List<String> urls) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('arrayPdfOffice', urls);
  }

  Future<void> delatePdfs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('arrayPdfOffice')) {
      await prefs.remove('arrayPdfOffice');
    }
  }

  Future <List<String>?> getOffice() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('arrayPdfOffice')) {
      return prefs.getStringList('arrayPdfOffice');
    }
    return null;
  }

  Future<List<String>> covertFiles64(List<File> files) async {
    final List<String> base64Files = [];
    for (var file in files) {
      final bytes = await file.readAsBytes();
      final String base64String = base64Encode(bytes);
      base64Files.add(base64String);
    }

    return base64Files;
  }

}
