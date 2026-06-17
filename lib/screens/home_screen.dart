import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'denunciar_sceen.dart';
import '../theme/colores.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      appBar: AppBar(
        backgroundColor: AppColors.azulPersa,
        title: Text(
          'GuardiApp',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DenunciarScreen(
                  onBack: () => Navigator.pop(context),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.azulPersa,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Hacer una Denuncia',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}