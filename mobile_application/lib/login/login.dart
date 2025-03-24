import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  ButtonStyle styleButton = ElevatedButton.styleFrom(
    fixedSize: const Size(300,30),
      backgroundColor: Colors.deepPurple[400],
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Bordes cuadrados
      ),
      textStyle: const TextStyle(
        fontSize: 15,
      ),
      foregroundColor: Colors.white,
  );

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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/menu');
                  },
                  style:  styleButton,
                  child: const Text('Iniciar Sesión'),
                ),
        ]
       ),
          )
      ),
    );
  }
}