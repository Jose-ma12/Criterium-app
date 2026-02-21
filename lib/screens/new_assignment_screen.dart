import 'package:flutter/material.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:criterium/screens/rubric_builder_screen.dart';

class NewAssignmentScreen extends StatefulWidget {
  const NewAssignmentScreen({super.key});

  @override
  State<NewAssignmentScreen> createState() => _NewAssignmentScreenState();
}

class _NewAssignmentScreenState extends State<NewAssignmentScreen> {
  final TextEditingController _dateController = TextEditingController(
    text: "11/15/2023",
  );

  String _selectedClass = 'Seleccionar clase...';

  static const List<Map<String, String>> _availableClasses = [
    {'name': 'Matemáticas 101', 'icon': '📐'},
    {'name': 'Biología - 10mo A', 'icon': '🧬'},
    {'name': 'Historia Universal', 'icon': '📜'},
    {'name': 'Ciencias Naturales', 'icon': '🔬'},
  ];

  void _showClassSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final cardColor = Theme.of(ctx).cardColor;
        final textColor = isDark ? Colors.white : AppTheme.navyBlue;
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Selecciona una clase',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _availableClasses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final cls = _availableClasses[index];
                  final isSelected = _selectedClass == cls['name'];
                  return ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.navyBlue.withOpacity(0.1)
                            : (isDark
                                  ? const Color(0xFF334155)
                                  : Colors.grey[100]),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          cls['icon']!,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    title: Text(
                      cls['name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? textColor
                            : (isDark ? Colors.grey[300] : Colors.grey[800]),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF2ECC71),
                          )
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedClass = cls['name']!;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;
    final hasClass = _selectedClass != 'Seleccionar clase...';

    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        title: Text(
          'Nueva Tarea',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
        leadingWidth: 100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador de Pasos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.navyBlue,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              'Detalles de la tarea',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Paso 1: Ingresa la información básica de la asignación para tus alumnos.',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 32),

            // Formulario
            _buildLabel('Título de tarea'),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Ej. Ensayo sobre la fotosíntesis',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel('Descripción'),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    'Describe los objetivos y requisitos de esta tarea...',
                hintStyle: TextStyle(color: Colors.grey),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel('Fecha de entrega'),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
              ),
              onTap: () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2026),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppTheme.navyBlue,
                          onSurface: AppTheme.navyBlue,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _dateController.text =
                        '${date.day}/${date.month}/${date.year}';
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            _buildLabel('Asignar a clase'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasClass
                      ? AppTheme.navyBlue.withOpacity(0.3)
                      : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hasClass
                        ? Colors.indigo[50]
                        : (isDark ? const Color(0xFF334155) : Colors.grey[100]),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school,
                    color: hasClass ? AppTheme.navyBlue : Colors.grey,
                    size: 20,
                  ),
                ),
                title: Text(
                  _selectedClass,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: hasClass ? AppTheme.navyBlue : Colors.grey,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () => _showClassSelector(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Botón Siguiente
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0D47A1),
                    Color(0xFF00AA88),
                  ], // Azul a Verde azulado
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00AA88).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RubricBuilderScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Siguiente: Definir rúbrica',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : AppTheme.navyBlue,
      ),
    );
  }
}
