import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:criterium/theme/app_theme.dart';

class GradesSummaryScreen extends StatelessWidget {
  const GradesSummaryScreen({super.key});

  // ── Mock Data ──
  static final List<Map<String, dynamic>> _subjects = [
    {
      'name': 'Matemáticas',
      'teacher': 'Prof. Alex Rivera',
      'grade': 9.8,
      'icon': Icons.calculate,
    },
    {
      'name': 'Historia',
      'teacher': 'Prof. Carmen Vega',
      'grade': 9.5,
      'icon': Icons.menu_book,
    },
    {
      'name': 'Ciencias',
      'teacher': 'Prof. Daniel Ortiz',
      'grade': 10.0,
      'icon': Icons.science,
    },
    {
      'name': 'Biología',
      'teacher': 'Prof. Laura Méndez',
      'grade': 9.7,
      'icon': Icons.eco,
    },
    {
      'name': 'Español',
      'teacher': 'Prof. Sofía Reyes',
      'grade': 10.0,
      'icon': Icons.auto_stories,
    },
    {
      'name': 'Inglés',
      'teacher': 'Prof. James Smith',
      'grade': 9.6,
      'icon': Icons.translate,
    },
    {
      'name': 'Física',
      'teacher': 'Prof. Roberto Díaz',
      'grade': 9.9,
      'icon': Icons.bolt,
    },
    {
      'name': 'Ética',
      'teacher': 'Prof. María Torres',
      'grade': 10.0,
      'icon': Icons.balance,
    },
    {
      'name': 'Geografía',
      'teacher': 'Prof. Andrés Luna',
      'grade': 9.3,
      'icon': Icons.public,
    },
  ];

  static final List<Map<String, dynamic>> _softSkills = [
    {'name': 'Participación en clase', 'stars': 5},
    {'name': 'Conducta', 'stars': 5},
    {'name': 'Trabajo en equipo', 'stars': 4},
    {'name': 'Puntualidad', 'stars': 4},
  ];

  @override
  Widget build(BuildContext context) {
    // Calcular promedio
    final double average =
        _subjects.map((s) => s['grade'] as double).reduce((a, b) => a + b) /
        _subjects.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Boleta de Calificaciones',
          style: TextStyle(
            color: AppTheme.navyBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tarjeta Maestra — Promedio General ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.navyBlue.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Gráfico circular
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CustomPaint(
                      painter: _CircularGradePainter(average / 10),
                      child: Center(
                        child: Text(
                          average.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Promedio General',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Semestre Ene–Jun 2026',
                          style: TextStyle(fontSize: 13, color: Colors.white38),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2ECC71).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Color(0xFF2ECC71),
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Excelente',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2ECC71),
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
            ),
            const SizedBox(height: 28),

            // ── Lista de Materias ──
            const Text(
              'Calificaciones por materia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.navyBlue,
              ),
            ),
            const SizedBox(height: 14),

            ...List.generate(_subjects.length, (index) {
              final subject = _subjects[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSubjectCard(subject),
              );
            }),

            const SizedBox(height: 16),

            // ── Habilidades Blandas ──
            const Text(
              'Habilidades Blandas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.navyBlue,
              ),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(_softSkills.length, (index) {
                  final skill = _softSkills[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < _softSkills.length - 1 ? 16 : 0,
                    ),
                    child: _buildSoftSkillRow(skill['name'], skill['stars']),
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Subject Card ──
  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final double grade = subject['grade'];
    final double progress = grade / 10;

    // Color basado en calificación
    Color gradeColor;
    if (grade >= 9.5) {
      gradeColor = const Color(0xFF2ECC71);
    } else if (grade >= 8.0) {
      gradeColor = const Color(0xFF3B82F6);
    } else if (grade >= 7.0) {
      gradeColor = const Color(0xFFF39C12);
    } else {
      gradeColor = const Color(0xFFE74C3C);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.navyBlue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(subject['icon'], color: AppTheme.navyBlue, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.navyBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subject['teacher'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                // Barra de progreso
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            grade.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: gradeColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Soft Skill Row ──
  Widget _buildSoftSkillRow(String name, int stars) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.navyBlue,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
              index < stars ? Icons.star_rounded : Icons.star_outline_rounded,
              color: index < stars ? const Color(0xFFF59E0B) : Colors.grey[300],
              size: 22,
            );
          }),
        ),
      ],
    );
  }
}

// ── Custom Painter para el gráfico circular ──
class _CircularGradePainter extends CustomPainter {
  final double progress; // 0.0 a 1.0

  _CircularGradePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Fondo del arco
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Arco de progreso
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [Color(0xFF2ECC71), Color(0xFF3B82F6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularGradePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
