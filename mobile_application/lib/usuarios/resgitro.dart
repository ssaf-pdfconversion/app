import 'package:flutter/material.dart';
import 'package:mobile_application/styles.dart';
import 'package:mobile_application/usuarios/registro_service.dart';
import 'package:get/route_manager.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final registerService = RegisterService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          width: 300,
          height: 500,
          child: Column(
            children: [
              Icon(Icons.perm_contact_calendar, size: 100, color: Colors.deepPurple[400]),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuario',
                ),
              ),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Apellido',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final sucess = await registerService.register(
                    _usernameController.text,
                    _passwordController.text,
                    _nombreController.text,
                    _apellidoController.text,
                    _emailController.text,
                  );
                  if (sucess) {
                    Get.offNamed('/menu');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error en el registro'),
                      ),
                    );
                  }
                },
                style: CustomButtonStyle.primaryStyle,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}