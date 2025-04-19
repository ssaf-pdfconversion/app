
import 'package:mobile_application/config.dart';
import 'package:mobile_application/usuarios/login_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MetricService{
  Future<int> metricTotal() async{
    print('metricas service');
    final LoginService loginService = LoginService();
    final token = await loginService.getToken();
    final userId = await loginService.getUserId();
    if (token == null || userId == null) {
      return -1; // Token or userId not found // Default return value in case of an unhandled scenario
    }
    
    try{

      final Map<String, dynamic> data = {
        'userId': userId,
      };
      final response = await http.post(
        Uri.parse('http://${Config.HOST}:${Config.PORT}/total'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body:json.encode(data),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final total = data['data'] as int;
        return total;
      } else if (response.statusCode == 401) {
        
        return -1;
      } else{
        return -1;
      }
      

    }catch(e){
      // ignore: avoid_print
      print('Error Catch: $e');
      return -1;
    }
   



  }

  Future<bool> statistics(DateTime startDate, DateTime endDate, String fileType) async{
    final LoginService loginService = LoginService();
    final token = await loginService.getToken();
    final userId = await loginService.getUserId();
    int fileTypeId = 0; // Default value
    if (token == null || userId == null) {
      return false; // Token or userId not found
    }
    print('fileType: $fileType');

    if(fileType == 'url'){
      fileTypeId = 2;
      
    }
    else{
      fileTypeId = 1;
    }
    
    try{
      final Map<String, dynamic> data = {
        'userId': userId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'fileTypeId': fileTypeId,
      };
    
      final response = await http.post(
        Uri.parse('http://${Config.HOST}:${Config.PORT}/statistics'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body:json.encode(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        
        return false;
      } else{
        return false;
      }
      

    }catch(e){
      // ignore: avoid_print
      print('Error Catch: $e');
      return false;
    }
  }
}