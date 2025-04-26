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
  final _usernameController = TextEditingController();
  final _nombreController   = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _registerService    = RegisterService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    final success = await _registerService.register(
      _usernameController.text.trim(),
      _passwordController.text,
      _nombreController.text.trim(),
      _apellidoController.text.trim(),
      _emailController.text.trim(),
    );
    if (success) {
      Get.offNamed('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error en el registro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Medidas de pantalla
    final size        = MediaQuery.of(context).size;
    final isWide     = size.width > 600;
    final formWidth  = isWide ? 500.0 : size.width * 0.9;
    final iconSize   = isWide ? 120.0 : 80.0;
    final fieldWidth = double.infinity; // ocupa todo el ancho del form

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
        
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: formWidth),
              child: Column(
                children: [
                  Icon(
                    Icons.perm_contact_calendar,
                    size: iconSize,
                    color: Colors.deepPurple[400],
                  ),
                  const SizedBox(height: 24),

                  // Username
                  SizedBox(
                    width: fieldWidth,
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Usuario',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nombre / Apellido en fila si es ancho
                  if (isWide)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nombreController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nombre',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _apellidoController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Apellido',
                            ),
                          ),
                        ),
                      ],
                    )
                  else ...[
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _apellidoController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Apellido',
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Email
                  SizedBox(
                    width: fieldWidth,
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  SizedBox(
                    width: fieldWidth,
                    child: TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón Registrar
                  SizedBox(
                    width: fieldWidth,
                    height: 48,
                    child: ElevatedButton(
                      style: CustomButtonStyle.primaryStyle,
                      onPressed: _onRegister,
                      child: const Text('Registrar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
