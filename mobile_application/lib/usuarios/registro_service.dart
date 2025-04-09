import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_application/config.dart';


class RegisterService{
  Future<bool> register(String username, String password, String nombre, String apellido, String email) async {
    print("Entro a register service");
    print('http://${Config.HOST}:${Config.PORT}/register');
    final Map<String, String> data = {
      'username': username,
      'password': password,
      'nombre': nombre,
      'apellido': apellido,
      'email': email
    };

    try {
      final response = await http.post(
        Uri.parse('http://${Config.HOST}:${Config.PORT}/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );
      // ignore: avoid_print
     
      print( response.body);

      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else if (response.statusCode == 401) {
        // Invalid data
        return false;
      } else {
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return false;
    }
  }
}