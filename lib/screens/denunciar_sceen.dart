import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_flutter/widgets/fila_Icono.dart';
import '../widgets/Campo_texto.dart';
import '../widgets/label.dart';
import 'success_screen.dart';
import '../theme/colores.dart';
import '../widgets/dropdown_gris.dart';


// ── Datos ──────────────────────────────────
const _lugares = [
  'Centro', 'Norte', 'Sur', 'Oriente', 'Occidente',
  'Barrio El Bosque', 'Barrio La Palma',
];

const _tiposDiscriminacion = [
  'Discriminación LGBTIQ+', 'Racismo o xenofobia', 'Bullying escolar',
  'Violencia de género', 'Acoso laboral', 'Maltrato institucional',
];

const _subtipos = {
  'Discriminación LGBTIQ+': ['Agresión verbal', 'Exclusión', 'Violencia'],
  'Racismo o xenofobia':    ['Insultos raciales', 'Exclusión'],
  'Bullying escolar':       ['Acoso', 'Hostigamiento'],
  'Violencia de género':    ['Acoso', 'Violencia psicológica'],
  'Acoso laboral':          ['Presión', 'Discriminación laboral'],
  'Maltrato institucional': ['Negación de servicios'],
};

const _tiposAcoso     = ['Acoso sexual', 'Acoso escolar', 'Acoso laboral', 'Ciberbullying'];
const _tiposViolencia = ['Física', 'Psicológica', 'Sexual', 'Económica'];
const _gruposPob      = [
  'Mujer', 'Hombre', 'LGBTIQ+', 'Adulto mayor',
  'Persona con discapacidad', 'Migrante', 'Niño/Niña',
];

const _entornos = {
  'Familiar':      ['Padre', 'Madre', 'Hermanos', 'Abuelos', 'Tíos', 'Otros'],
  'Social':        ['Calle', 'Parque', 'Otros'],
  'Académico':     ['Colegios', 'Universidades', 'Fundaciones', 'Corporaciones'],
  'Institucional': ['Entidades públicas', 'Clínicas', 'EPS', 'IPS', 'ESE'],
};

const _instituciones = ['Fiscalía', 'Defensoría del Pueblo', 'Policía'];

// ─────────────────────────────────────────────────────────
class DenunciarScreen extends StatefulWidget {
  const DenunciarScreen({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  State<DenunciarScreen> createState() => _DenunciarScreenState();
}

class _DenunciarScreenState extends State<DenunciarScreen> {
  // ── Valores del formulario ──
  String descripcion     = '';
  String lugar           = '';
  String fecha           = '';
  String tipoDenunciante = '';
  String genero          = '';
  String edad            = '';
  String discriminacion  = '';
  String subDisc         = '';
  String acoso           = '';
  String violencia       = '';
  String grupo           = '';
  String entorno         = '';
  String subEntorno      = '';
  String personas        = '';
  String institucion     = '';
  
  // ── Imágenes seleccionadas ──
  List<XFile> imagenes = [];
  final ImagePicker _picker = ImagePicker();

  // ── Abre el DatePicker nativo de Material 3 ──
  Future<void> _seleccionarFecha() async {
    final ahora = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: ahora,
      firstDate: DateTime(2000),
      lastDate: ahora,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.azulPersa,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        fecha = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // ── Función para seleccionar imágenes ──
  Future<void> _seleccionarImagenes() async {
    try {
      final List<XFile> seleccionadas = await _picker.pickMultiImage();
      if (seleccionadas.isNotEmpty) {
        setState(() {
          imagenes.addAll(seleccionadas);
        });
      }
    } catch (e) {
      debugPrint('Error al seleccionar imágenes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      appBar: AppBar(
        backgroundColor: AppColors.azulPersa,
        foregroundColor: Colors.white,
        title: Text(
          'Detalles de la Denuncia',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Descripción ──
            Label('¿Qué ocurrió?'),
            CampoTexto(
              valor: descripcion,
              placeholder: 'Descripción',
              maxLines: 4,
              onValorChange: (v) => setState(() => descripcion = v),
            ),
            const SizedBox(height: 20),

            // ── Víctima / Testigo ──
            Label('¿Eres víctima o testigo?'),
            Row(
              children: ['Víctima', 'Testigo'].map((op) {
                final sel = tipoDenunciante == op;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => tipoDenunciante = op),
                    child: Container(
                      margin: EdgeInsets.only(right: op == 'Víctima' ? 6 : 0, left: op == 'Testigo' ? 6 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.azulPersa : AppColors.fondoCampo,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        op,
                        style: GoogleFonts.inter(
                          color: sel ? Colors.white : AppColors.textoGris,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Género ──
            Label('Género'),
            Wrap(
              spacing: 8,
              children: ['Mujer', 'Hombre', 'Otro'].map((g) {
                final sel = genero == g;
                return GestureDetector(
                  onTap: () => setState(() => genero = g),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.azulPersa : AppColors.fondoCampo,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      g,
                      style: GoogleFonts.inter(
                        color: sel ? Colors.white : AppColors.textoGris,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Edad ──
            Label('Edad'),
            CampoTexto(
              valor: edad,
              placeholder: 'Ej: 25',
              keyboardType: TextInputType.number,
              maxLength: 3,
              onValorChange: (v) => setState(() => edad = v),
            ),
            const SizedBox(height: 20),

            // ── Lugar ──
            Label('Lugar del incidente'),
            DropdownGris(
              valor: lugar,
              placeholder: 'Selecciona el lugar',
              opciones: _lugares,
              onSeleccionar: (v) => setState(() => lugar = v),
            ),
            const SizedBox(height: 20),

            // ── Fecha ──
            Label('¿Cuándo ocurrió?'),
            FilaIcono(
              valor: fecha,
              placeholder: 'Selecciona la fecha',
              onTap: _seleccionarFecha,
              icono: const Icon(Icons.calendar_month, color: AppColors.textoGris),
            ),
            const SizedBox(height: 20),

            // ── Discriminación ──
            Label('Tipo de discriminación'),
            DropdownGris(
              valor: discriminacion,
              placeholder: 'Selecciona el tipo',
              opciones: _tiposDiscriminacion,
              onSeleccionar: (v) => setState(() { discriminacion = v; subDisc = ''; }),
            ),
            if (discriminacion.isNotEmpty) ...[
              const SizedBox(height: 12),
              DropdownGris(
                valor: subDisc,
                placeholder: 'Selecciona el subtipo',
                opciones: _subtipos[discriminacion] ?? [],
                onSeleccionar: (v) => setState(() => subDisc = v),
              ),
            ],
            const SizedBox(height: 20),

            // ── Acoso ──
            Label('Tipo de acoso'),
            DropdownGris(
              valor: acoso,
              placeholder: 'Selecciona el tipo de acoso',
              opciones: _tiposAcoso,
              onSeleccionar: (v) => setState(() => acoso = v),
            ),
            const SizedBox(height: 20),

            // ── Violencia ──
            Label('Tipo de violencia'),
            DropdownGris(
              valor: violencia,
              placeholder: 'Selecciona el tipo de violencia',
              opciones: _tiposViolencia,
              onSeleccionar: (v) => setState(() => violencia = v),
            ),
            const SizedBox(height: 20),

            // ── Grupo poblacional ──
            Label('Grupo poblacional'),
            DropdownGris(
              valor: grupo,
              placeholder: 'Selecciona el grupo',
              opciones: _gruposPob,
              onSeleccionar: (v) => setState(() => grupo = v),
            ),
            const SizedBox(height: 20),

            // ── Entorno ──
            Label('Tipo de entorno'),
            DropdownGris(
              valor: entorno,
              placeholder: 'Selecciona el entorno',
              opciones: _entornos.keys.toList(),
              onSeleccionar: (v) => setState(() { entorno = v; subEntorno = ''; }),
            ),
            if (entorno.isNotEmpty) ...[
              const SizedBox(height: 12),
              DropdownGris(
                valor: subEntorno,
                placeholder: 'Especifica el lugar',
                opciones: _entornos[entorno] ?? [],
                onSeleccionar: (v) => setState(() => subEntorno = v),
              ),
            ],
            const SizedBox(height: 20),

            // ── Personas involucradas ──
            Label('Personas involucradas'),
            DropdownGris(
              valor: personas,
              placeholder: 'Escribe los nombres...',
              opciones: [],
              onSeleccionar: (v) => setState(() => personas = v),
            ),
            const SizedBox(height: 20),

            // ── Institución ──
            Label('¿Deseas redireccionar tu denuncia?'),
            
            Column(
              children: _instituciones.map((inst) {
                final sel = institucion == inst;
                return GestureDetector(
                  onTap: () => setState(() => institucion = inst),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.azulPersa.withOpacity(0.08) : AppColors.fondoCampo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          inst,
                          style: GoogleFonts.inter(
                            color: sel ? AppColors.azulPersa : AppColors.textoOscuro,
                            fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        Radio<String>(
                          value: inst,
                          groupValue: institucion,
                          activeColor: AppColors.azulPersa,
                          onChanged: (v) => setState(() => institucion = v ?? ''),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Botón Adjuntar Imágenes con funcionalidad ──
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _seleccionarImagenes,
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: Text(
                  imagenes.isEmpty 
                    ? '¿Desea ajuntar imagenes ?' 
                    : '${imagenes.length} imágenes seleccionadas',
                  style: GoogleFonts.poppins(
                    color:Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.violeta,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            // ── Vista previa de imágenes seleccionadas ──
            if (imagenes.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagenes.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(File(imagenes[index].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 2,
                          child: GestureDetector(
                            onTap: () => setState(() => imagenes.removeAt(index)),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            
            const SizedBox(height: 20),

            // ── Botón Enviar ──
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Captura de todos los valores del formulario
                  final datosDenuncia = {
                    'descripcion': descripcion,
                    'lugar': lugar,
                    'fecha': fecha,
                    'tipoDenunciante': tipoDenunciante,
                    'genero': genero,
                    'edad': edad,
                    'discriminacion': discriminacion,
                    'subDisc': subDisc,
                    'acoso': acoso,
                    'violencia': violencia,
                    'grupo': grupo,
                    'entorno': entorno,
                    'subEntorno': subEntorno,
                    'personas': personas,
                    'institucion': institucion,
                    'imagenes': imagenes.map((img) => img.path).toList(),
                  };

                  // Mostrar en consola para verificar la captura
                  debugPrint('--- DATOS CAPTURADOS ---');
                  datosDenuncia.forEach((key, value) {
                    debugPrint('$key: $value');
                  });

                  // Simulación de envío con indicador de carga
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(color: AppColors.azulPersa),
                    ),
                  );

                  // Esperar un momento y navegar a la pantalla de éxito
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      Navigator.pop(context); // Cerrar diálogo de carga
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SuccessScreen()),
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azulPersa,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Enviar Denuncia',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


