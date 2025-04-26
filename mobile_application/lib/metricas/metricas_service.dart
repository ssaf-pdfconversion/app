
import 'package:mobile_application/config.dart';
import 'package:mobile_application/usuarios/login_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mobile_application/metricas/graficas.dart';

class MetricService{
  Future<double>metricTotal() async{
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
        final total = data['data'];
        final number = double.tryParse(total.toString()) ?? 0.0; // Convert to double
        return number;
      } else if (response.statusCode == 401) {
        
        return -1.0;
      } else{
        return -1.0;
      }
      

    }catch(e){
      // ignore: avoid_print
      print('Error Catch: $e');
      return -1;
    }
   



  }

  Future<List<ChartData>> statistics(DateTime startDate, DateTime endDate, String fileType) async{
    final LoginService loginService = LoginService();
    final token = await loginService.getToken();
    final userId = await loginService.getUserId();
    int fileTypeId = 0; // Default value
    if (token == null || userId == null) {
      return []; // Token or userId not found
    }


    // formateador yyyy-MM-dd
    final DateFormat fmt = DateFormat('yyyy-MM-dd');
    final String start = fmt.format(startDate);  // e.g. "2025-04-01"
    final String end   = fmt.format(endDate);

    if(fileType == 'url'){
      fileTypeId = 2;
      
    }
    else{
      fileTypeId = 1;
    }
    
    try{
      final Map<String, dynamic> data = {
        'userId': userId,
        'startDate': start,
        'endDate': end,
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
        final Map<String, dynamic> decoded = json.decode(response.body);
        final dynamic fileJson = decoded['data'];
        final List<ChartData> chartdata = convertRawStatsToChartData(fileJson);
        

        return chartdata;
      } else if (response.statusCode == 401) {
        
        return [];
      } else{
        return [];
      }
      

    }catch(e){
      // ignore: avoid_print
      print('Error Catch: $e');
      return [];
    }
  }
}