import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_application/config.dart';

class LoginService {
  Future<bool> login(String username, String password) async {
  

    final Map<String, String> data = {
      'username': username,
      'password': password,
    };

    try{

      final response = await http.post(
        Uri.parse('http://${Config.HOST}:${Config.PORT}/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
        
      );
      // ignore: avoid_print
      print(response);
      if (response.statusCode == 200) {
        // Login successful
        return true;
      } else if (response.statusCode == 401) {
        // Invalid credentials
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
}