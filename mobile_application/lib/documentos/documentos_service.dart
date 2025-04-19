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
    
    final Map<String, dynamic> data = {
      'files': [names, base64Files],
      'userId': userId,
      
    };
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
        final data = json.decode(response.body);
        final List<String> pdfsList = List<String>.from(data['pdfs']);
        await saveOfiice(pdfsList);
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
