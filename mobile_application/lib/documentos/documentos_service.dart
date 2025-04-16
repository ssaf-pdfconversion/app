import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_application/config.dart';
import 'package:mobile_application/usuarios/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocService {
  Future<bool> officeConvert(List<String> urls) async {
    
    final LoginService loginService = LoginService();
    final token = await loginService.getToken();
    final userId = await loginService.getUserId();
    if (token == null || userId == null) {
      return false; // Token or userId not found
    }
    
    final Map<String, dynamic> data = {
      'files': urls,
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
        print('PDFs: $pdfsList');
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
    print('holis');
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
}