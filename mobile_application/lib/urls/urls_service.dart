import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_application/config.dart';
import 'package:mobile_application/usuarios/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UrlsService {
  Future<bool> urlConvert(List<String> urls) async {
    print('Enviando URLs: $urls');
    final LoginService loginService = LoginService();
    final token = await loginService.getToken();
    final userId = await loginService.getUserId();

    if (token == null || userId == null) {
      return false; // Token o userId no encontrado
    }

    final Map<String, dynamic> data = {
      'urls': urls,
      'userId': userId,
    };

    try {
      final response = await http.post(
        Uri.parse('http://${Config.HOST}:${Config.PORT}/urlConvert'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
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

        // 4. Guardar en SharedPreferences
        await saveUrls(dataList);
        return true;

      } else if (response.statusCode == 401) {
        // No autorizado
        return false;
      } else {
        // Otros errores
        print('Error en conversión: código ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción en urlConvert: $e');
      return false;
    }
  }

  Future<void> saveUrls(List<String> urls) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('arrayPdfsUrls', urls);
  }

  Future<void> delatePdfs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('arrayPdfsUrls')) {
      await prefs.remove('arrayPdfsUrls');
    }
  }

  Future<List<String>?> getUrls() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('arrayPdfsUrls')) {
      return prefs.getStringList('arrayPdfsUrls');
    }
    return null;
  }
}
