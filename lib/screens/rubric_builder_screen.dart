import 'package:flutter/material.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:criterium/providers/teacher_provider.dart';

class RubricBuilderScreen extends StatefulWidget {
  final String title;
  final String description;
  final String dueDate;
  final String className;

  const RubricBuilderScreen({
    super.key,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.className,
  });

  @override
  State<RubricBuilderScreen> createState() => _RubricBuilderScreenState();
}

class _RubricBuilderScreenState extends State<RubricBuilderScreen> {
  bool _isLoading = false;
  String _verdict = '';
  final TextEditingController _feedbackCtrl = TextEditingController();

  void _enviarEvaluacion() async {
    if (_verdict.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar un veredicto comercial.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final feedbackText = _feedbackCtrl.text.trim();
    if (feedbackText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, escribe un feedback técnico y comercial.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Calculamos la calificación basada en el veredicto
    int finalGrade = 80;
    if (_verdict == 'vendible') finalGrade = 100;
    if (_verdict == 'noviable') finalGrade = 60;

    // Mutamos el estado global
    context.read<TeacherProvider>().evaluateProject(widget.title, finalGrade);

    await Future.delayed(const Duration(milliseconds: 600)); // Breve animación

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Evaluación y feedback enviados al creador'),
        backgroundColor: Color(0xFF2ECC71),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildVerdictOption(
    String title,
    String icon,
    String value,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _verdict == value;

    return GestureDetector(
      onTap: () => setState(() => _verdict = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? color
                      : (isDark ? Colors.white : AppTheme.navyBlue),
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Evaluar Proyecto',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROYECTO A EVALUAR',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.className,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.electricBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- NUEVA SECCIÓN DE ARCHIVOS ---
                  Text(
                    'Archivos Adjuntos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAttachedFile(
                    context,
                    'Pitch_Deck_Final.pdf',
                    '2.4 MB',
                    Icons.picture_as_pdf,
                    const Color(0xFFE74C3C),
                  ),
                  _buildAttachedFile(
                    context,
                    'Demo_Gameplay_v2.mp4',
                    '45.1 MB',
                    Icons.video_file,
                    const Color(0xFF8B5CF6),
                  ),
                  _buildAttachedFile(
                    context,
                    'Build_Android.apk',
                    '68.3 MB',
                    Icons.android,
                    const Color(0xFF2ECC71),
                  ),
                  const SizedBox(height: 32),

                  // ---------------------------------
                  Text(
                    'Veredicto Comercial',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecciona la viabilidad de este proyecto en el mercado actual.',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildVerdictOption(
                    'Altamente Vendible',
                    '💎',
                    'vendible',
                    const Color(0xFF2ECC71),
                  ),
                  _buildVerdictOption(
                    'Requiere Mejoras',
                    '⚠️',
                    'mejoras',
                    const Color(0xFFF39C12),
                  ),
                  _buildVerdictOption(
                    'No Viable',
                    '❌',
                    'noviable',
                    const Color(0xFFE74C3C),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Feedback Técnico y Comercial',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _feedbackCtrl,
                    maxLines: 5,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText:
                          'Escribe tus recomendaciones de diseño, monetización o jugabilidad...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF334155)
                          : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Area
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _enviarEvaluacion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navyBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Confirmar Evaluación',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedFile(
    BuildContext context,
    String fileName,
    String size,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.transparent : Colors.grey[200]!,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          fileName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          size,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download_rounded, color: Color(0xFF3B82F6)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Descargando $fileName...'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF3B82F6),
              ),
            );
          },
        ),
      ),
    );
  }
}
