import 'package:flutter/material.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:criterium/providers/teacher_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  Future<void> _crearTarea() async {
    // --- NUEVA VALIDACIÓN ---
    if (_criteria.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes agregar al menos un criterio a la rúbrica.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return; // Detenemos la ejecución aquí
    }
    // --- FIN DE LA VALIDACIÓN ---

    setState(() => _isLoading = true);
    try {
      final success = await context.read<TeacherProvider>().createAssignment(
        title: widget.title,
        description: widget.description,
        dueDate: widget.dueDate,
        className: widget.className,
        rubric: _criteria,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Tarea guardada exitosamente')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al conectar con el servidor')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  final List<Map<String, dynamic>> _criteria = [];

  int get _totalScore =>
      _criteria.fold<int>(0, (sum, c) => sum + (c['score'] as int));

  // ── Eliminar criterio con confirmación ──
  void _deleteCriterion(int index) {
    final name = _criteria[index]['title'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '¿Eliminar criterio?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(ctx).brightness == Brightness.dark
                ? Colors.white
                : AppTheme.navyBlue,
          ),
        ),
        content: Text(
          '¿Seguro que deseas eliminar "$name"? Esta acción no se puede deshacer.',
          style: TextStyle(color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _criteria.removeAt(index);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"$name" eliminado'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Editar criterio ──
  void _editCriterion(int index) {
    final titleCtrl = TextEditingController(
      text: _criteria[index]['title'] as String,
    );
    final scoreCtrl = TextEditingController(
      text: '${_criteria[index]['score']}',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Editar criterio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.navyBlue,
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: const TextStyle(color: AppTheme.navyBlue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.navyBlue),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: scoreCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Puntaje',
                  labelStyle: const TextStyle(color: AppTheme.navyBlue),
                  suffixText: 'pts',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.navyBlue),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  final n = int.tryParse(v.trim());
                  if (n == null || n <= 0) return 'Debe ser mayor a 0';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                setState(() {
                  _criteria[index]['title'] = titleCtrl.text.trim();
                  _criteria[index]['score'] = int.parse(scoreCtrl.text.trim());
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text(
              'Guardar',
              style: TextStyle(
                color: AppTheme.navyBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Agregar nuevo criterio ──
  void _addCriterion() {
    final titleCtrl = TextEditingController();
    final scoreCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Nuevo criterio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.navyBlue,
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: const TextStyle(color: AppTheme.navyBlue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.navyBlue),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: scoreCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Puntaje',
                  labelStyle: const TextStyle(color: AppTheme.navyBlue),
                  suffixText: 'pts',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.navyBlue),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  final n = int.tryParse(v.trim());
                  if (n == null || n <= 0) return 'Debe ser mayor a 0';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                setState(() {
                  _criteria.add({
                    'title': titleCtrl.text.trim(),
                    'score': int.parse(scoreCtrl.text.trim()),
                    'image':
                        'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&q=80&w=150&h=150',
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text(
              'Agregar',
              style: TextStyle(
                color: AppTheme.navyBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
          'Constructor de Rúbrica',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help, color: textColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Define los criterios para evaluar la tarea de tus alumnos',
                  ),
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progreso
          Container(
            color: cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso de la tarea',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Paso 2 de 3',
                      style: TextStyle(color: textColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.66,
                    backgroundColor: isDark
                        ? const Color(0xFF334155)
                        : Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF2ECC71),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Criterios de evaluación',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      // Botón agregar criterio
                      GestureDetector(
                        onTap: _addCriterion,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.navyBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 18),
                              SizedBox(width: 4),
                              Text(
                                'Agregar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Define los criterios y el puntaje máximo para esta tarea.',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Cards de Criterios dinámicas
                  ..._criteria.asMap().entries.map((entry) {
                    final index = entry.key;
                    final criterion = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCriterionCard(
                        index: index,
                        title: criterion['title'] as String,
                        score: criterion['score'] as int,
                        imageUrl: criterion['image'] as String,
                      ),
                    );
                  }),

                  if (_criteria.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Icon(
                            Icons.playlist_add,
                            size: 56,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Sin criterios aún',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Toca "Agregar" para crear un criterio',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(
                    height: 100,
                  ), // Espacio para botones inferiores
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
            child: Column(
              children: [
                // Save Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0D47A1),
                        Color(0xFF00AA88),
                      ], // Azul a verde azulado
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _crearTarea,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
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
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Guardar y publicar tarea',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.rocket_launch,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Total Score — dinámico
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Puntaje Total\nacumulado',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _totalScore > 100
                              ? const Color(0xFFE74C3C)
                              : const Color(0xFF2ECC71),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_totalScore / 100\npts',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriterionCard({
    required int index,
    required String title,
    required int score,
    required String imageUrl,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NOMBRE DEL CRITERIO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.stars,
                      size: 14,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Puntaje: $score pts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    _buildActionButton(
                      Icons.edit,
                      'Editar',
                      onTap: () => _editCriterion(index),
                    ),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      Icons.delete,
                      const Color(0xFFFFEBEE),
                      Colors.red,
                      onTap: () => _deleteCriterion(index),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    Color bg,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}
