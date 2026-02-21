import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:criterium/theme/app_theme.dart';

class ReportsScreen extends StatelessWidget {
  final bool isTeacher;
  const ReportsScreen({super.key, required this.isTeacher});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Reportes Académicos',
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded, color: textColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exportar reportes próximamente'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Métricas principales ──
            Row(
              children: isTeacher
                  ? [
                      _buildMetricCard(
                        context,
                        'Promedio del Grupo',
                        '8.5',
                        Icons.groups,
                        const Color(0xFF2EC4B6),
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        context,
                        'Tasa de Entrega',
                        '92%',
                        Icons.check_circle_outline,
                        const Color(0xFF70C635),
                      ),
                    ]
                  : [
                      _buildMetricCard(
                        context,
                        'Mi Promedio',
                        '9.8',
                        Icons.emoji_events,
                        const Color(0xFF2EC4B6),
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        context,
                        'Posición en Clase',
                        '3ro',
                        Icons.leaderboard,
                        const Color(0xFFF39C12),
                      ),
                    ],
            ),

            const SizedBox(height: 28),

            // ── Título de sección ──
            Text(
              isTeacher
                  ? 'Rendimiento por Clase'
                  : 'Progresión de Evaluaciones',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isTeacher
                  ? 'Promedio general de cada materia'
                  : 'Tus últimas calificaciones',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
            ),

            const SizedBox(height: 20),

            // ── Barras de rendimiento ──
            if (isTeacher) ..._buildTeacherBars(context),
            if (!isTeacher) ..._buildStudentBars(context),

            const SizedBox(height: 28),

            // ── Resumen rápido ──
            _buildSummaryCard(context),

            const SizedBox(height: 80), // espacio para bottom nav
          ],
        ),
      ),
    );
  }

  // ── Tarjeta de métrica ──
  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Barras de rendimiento del maestro ──
  List<Widget> _buildTeacherBars(BuildContext context) {
    final classes = [
      {
        'name': 'Matemáticas Avanzadas',
        'value': 0.85,
        'pct': '85%',
        'color': const Color(0xFF2EC4B6),
      },
      {
        'name': 'Álgebra Lineal',
        'value': 0.78,
        'pct': '78%',
        'color': const Color(0xFF3B82F6),
      },
      {
        'name': 'Cálculo Diferencial',
        'value': 0.92,
        'pct': '92%',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'name': 'Geometría Analítica',
        'value': 0.74,
        'pct': '74%',
        'color': const Color(0xFFF39C12),
      },
      {
        'name': 'Estadística',
        'value': 0.88,
        'pct': '88%',
        'color': const Color(0xFFE74C3C),
      },
      {
        'name': 'Trigonometría',
        'value': 0.95,
        'pct': '95%',
        'color': const Color(0xFF70C635),
      },
    ];

    return classes
        .map(
          (c) => _buildProgressRow(
            context,
            c['name'] as String,
            c['value'] as double,
            c['pct'] as String,
            c['color'] as Color,
          ),
        )
        .toList();
  }

  // ── Barras de progresión del alumno ──
  List<Widget> _buildStudentBars(BuildContext context) {
    final evaluations = [
      {
        'name': 'Ensayo - Biología',
        'value': 0.98,
        'pct': '9.8',
        'color': const Color(0xFF2EC4B6),
      },
      {
        'name': 'Examen - Matemáticas',
        'value': 1.0,
        'pct': '10.0',
        'color': const Color(0xFF70C635),
      },
      {
        'name': 'Proyecto - Historia',
        'value': 0.92,
        'pct': '9.2',
        'color': const Color(0xFF3B82F6),
      },
      {
        'name': 'Quiz - Ciencias',
        'value': 0.85,
        'pct': '8.5',
        'color': const Color(0xFFF39C12),
      },
      {
        'name': 'Tarea - Lengua',
        'value': 0.97,
        'pct': '9.7',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'name': 'Laboratorio - Química',
        'value': 0.76,
        'pct': '7.6',
        'color': const Color(0xFFE74C3C),
      },
    ];

    return evaluations
        .map(
          (e) => _buildProgressRow(
            context,
            e['name'] as String,
            e['value'] as double,
            e['pct'] as String,
            e['color'] as Color,
          ),
        )
        .toList();
  }

  // ── Fila individual con barra de progreso ──
  Widget _buildProgressRow(
    BuildContext context,
    String label,
    double value,
    String pct,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  pct,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tarjeta de resumen ──
  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF00AA88)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTeacher ? 'Resumen del Periodo' : 'Tu Resumen',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isTeacher
                      ? '154 alumnos activos\n6 materias en curso\n92% tasa de entrega promedio'
                      : '12 materias activas\n0 faltas acumuladas\nTop 3 de la clase',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              isTeacher ? Icons.analytics : Icons.workspace_premium,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}
