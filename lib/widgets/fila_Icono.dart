import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colores.dart';

class FilaIcono extends StatelessWidget {
  const FilaIcono({
    required this.valor,
    required this.placeholder,
    required this.onTap,
    required this.icono,
    this.isInvalid = false,
  });

  final String valor;
  final String placeholder;
  final VoidCallback onTap;
  final Widget icono;
  final bool isInvalid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.fondoCampo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isInvalid ? Colors.red : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              valor.isEmpty ? placeholder : valor,
              style: GoogleFonts.inter(color: valor.isEmpty ? AppColors.textoGris : AppColors.textoOscuro),
            ),
            icono,
          ],
        ),
      ),
    );
  }
}
