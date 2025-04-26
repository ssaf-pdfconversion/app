import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_application/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        final data = json.decode(response.body);
        final token = data['token'];
        final userId = data['userId'];
        saveToken(token);
        saveUserId(userId);
        return true;
      }else{
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return false;
    }
    // Simulate a network call
    
  }
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }
}