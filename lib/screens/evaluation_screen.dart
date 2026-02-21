import 'package:flutter/material.dart';
import 'package:criterium/screens/success_screen.dart';
import 'package:criterium/theme/app_theme.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  // Estado simulado para 3 compañeros
  final List<Map<String, dynamic>> _teamMembers = [
    {
      'name': 'Andrea Ruiz',
      'role': 'DESARROLLO FRONTEND',
      'avatar': 'https://i.pravatar.cc/100?img=5', // Mujer
      'responsibility': 85.0,
      'technical': 92.0,
      'selectedChips': ['Liderazgo'],
    },
    {
      'name': 'Carlos Sosa',
      'role': 'DISEÑO UX/UI',
      'avatar': 'https://i.pravatar.cc/100?img=11', // Hombre con lentes
      'responsibility': 60.0,
      'technical': 75.0,
      'selectedChips': ['Falta de comunicación'], // Chip negativo
    },
    {
      'name': 'Elena Méndez',
      'role': 'GESTIÓN DE PROYECTOS',
      'avatar': 'https://i.pravatar.cc/100?img=9', // Mujer
      'responsibility': 100.0,
      'technical': 88.0,
      'selectedChips': ['Puntualidad'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Evaluación de Compañeros',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                Text(
                  'Evalúa a tu equipo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Califica el desempeño de tus compañeros de forma anónima.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                ..._teamMembers
                    .map((member) => _buildMemberCard(member))
                    .toList(),
              ],
            ),
          ),

          // Botón fijo en la parte inferior
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? Theme.of(context).cardColor : Colors.white,
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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2E86DE),
                    Color(0xFF2EC4B6),
                  ], // Azul a Turquesa
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuccessScreen(),
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
                      'Enviar Evaluación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.send, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del miembro
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(member['avatar']),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                  Text(
                    member['role'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E86DE), // Azul claro
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Slider Responsabilidad
          _buildSliderSection(
            context,
            'Responsabilidad',
            member['responsibility'],
            (val) {
              setState(() => member['responsibility'] = val);
            },
          ),

          const SizedBox(height: 16),

          // Slider Aporte Técnico
          _buildSliderSection(context, 'Aporte Técnico', member['technical'], (
            val,
          ) {
            setState(() => member['technical'] = val);
          }),

          const SizedBox(height: 24),

          // Feedback Rápido
          Text(
            'FEEDBACK RÁPIDO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip(
                context,
                'Liderazgo',
                Icons.check_circle,
                Colors.blue,
                member['selectedChips'],
              ),
              _buildChip(
                context,
                'Puntualidad',
                Icons.access_time_filled,
                Colors.green,
                member['selectedChips'],
              ),
              _buildChip(
                context,
                'Falta de comunicación',
                Icons.error_outline,
                Colors.red,
                member['selectedChips'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSection(
    BuildContext context,
    String label,
    double value,
    Function(double) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color activeColor = const Color(0xFF2EC4B6); // Turquesa por defecto
    if (value < 70) activeColor = Colors.grey;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.navyBlue,
                fontSize: 14,
              ),
            ),
            Text(
              '${value.toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: activeColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            activeTrackColor: const Color(0xFF2EC4B6),
            inactiveTrackColor: isDark
                ? const Color(0xFF334155)
                : Colors.grey[200],
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 12,
              elevation: 4,
            ),
            overlayColor: const Color(0xFF2EC4B6).withOpacity(0.1),
          ),
          child: Slider(value: value, min: 0, max: 100, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    List<dynamic> selectedList,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = selectedList.contains(label);

    // Logica visual especifica para "Falta de comunicación" (rojo claro fondo, rojo texto)
    Color backgroundColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFF1F3F5);
    Color textColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;
    Color iconColor = Colors.transparent; // oculto si no seleccionado

    if (isSelected) {
      if (color == Colors.red) {
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFD32F2F);
        iconColor = const Color(0xFFD32F2F);
      } else {
        backgroundColor = const Color(
          0xFFE3F2FD,
        ); // Azul muy claro para los positivos
        if (label == 'Puntualidad') backgroundColor = const Color(0xFFE8F5E9);

        textColor = const Color(0xFF1976D2);
        if (label == 'Puntualidad') textColor = const Color(0xFF388E3C);

        iconColor = textColor;
      }
    }

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected && label == 'Liderazgo') ...[
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
          ],
          if (isSelected && label == 'Puntualidad') ...[
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
          ],
          if (isSelected && label == 'Falta de comunicación') ...[
            const Text(
              '!',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ), // Signo exclamacion
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            selectedList.add(label);
          } else {
            selectedList.remove(label);
          }
        });
      },
      backgroundColor: const Color(0xFFF8F9FA),
      selectedColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.transparent),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
