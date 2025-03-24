import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomButtonStyle {

  static ButtonStyle get primaryStyle => ElevatedButton.styleFrom(
        fixedSize: const Size(300, 30),
        backgroundColor: Colors.deepPurple[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Bordes cuadrados
        ),
        textStyle: const TextStyle(
          fontSize: 15,
        ),
        foregroundColor: Colors.white,
      );
}


class CustomSquareButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const CustomSquareButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(180, 180),
        backgroundColor: Colors.deepPurple[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.white70,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


// Gráfica para la sección "Diario"
 