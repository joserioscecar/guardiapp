import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/colores.dart';

class Label extends StatelessWidget {
  const Label(this.texto);
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.textoOscuro,
        ),
      ),
    );
  }
}
