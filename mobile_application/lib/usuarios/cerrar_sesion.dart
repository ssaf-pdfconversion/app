import 'package:flutter/material.dart';
import 'package:mobile_application/usuarios/login_service.dart';
import 'package:get/get.dart';

class CerrarSesion extends StatelessWidget{
   CerrarSesion({super.key});

  final LoginService _loginService = LoginService();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout, color: Colors.white, size: 30),
      onPressed: () async {
        await _loginService.logout();
        Get.toNamed('/login');
      },
    );
  }
  
}