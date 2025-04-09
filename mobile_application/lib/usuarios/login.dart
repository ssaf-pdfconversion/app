import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mobile_application/usuarios/login_service.dart';
import 'package:mobile_application/styles.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: 
          Container(
            margin: const EdgeInsets.all(10.0),
            width: 300,
            height: 500,
            child: Column(
              children: [

                Icon(Icons.picture_as_pdf, size: 100, color: Colors.deepPurple[400]),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),

                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                TextButton(onPressed: (){ Get.toNamed('/registro');}, 
                child: Text('¿No tienes cuenta? Registrate aquí',
                style: TextStyle(color: Colors.deepPurple[400]),
                )),

                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                   
                    final success = await loginService.login(
                      _usernameController.text,
                      _passwordController.text,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mensaje de Prueba'),
                        ),
                      );
                      Get.offNamed('/menu'); // Redirigir a la pantalla de menú
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mensaje de Prueba'),
                        ),
                      );
                      Get.offNamed('/menu'); 
                    }
                    
                  },
                  style: CustomButtonStyle.primaryStyle,
                  child: const Text('Iniciar Sesión'),
                ),
        ]
       ),
          )
      ),
    );
  }
}