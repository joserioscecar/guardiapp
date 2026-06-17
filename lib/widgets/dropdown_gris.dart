
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colores.dart';

class DropdownGris extends StatelessWidget {
  const DropdownGris({
    required this.valor,
    required this.placeholder,
    required this.opciones,
    required this.onSeleccionar,
  });

  final String valor;
  final String placeholder;
  final List<String> opciones;
  final ValueChanged<String> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fondoCampo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: valor.isEmpty ? null : valor,
            hint: Text(placeholder, style: GoogleFonts.inter(color: AppColors.textoGris)),
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textoOscuro),
            borderRadius: BorderRadius.circular(12),
            style: GoogleFonts.inter(color: AppColors.textoOscuro, fontSize: 16),
            dropdownColor: Colors.white,
            items: opciones
                .map((op) => DropdownMenuItem(value: op, child: Text(op, style: GoogleFonts.inter())))
                .toList(),
            onChanged: (v) { if (v != null) onSeleccionar(v); },
          ),
        ),
      ),
    );
  }
}