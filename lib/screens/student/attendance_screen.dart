import 'package:flutter/material.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:criterium/providers/student_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // ── Colores del código de asistencia ──
  static const Color _greenAttendance = Color(0xFF2ECC71);
  static const Color _redAbsence = Color(0xFFE74C3C);
  static const Color _orangeTardy = Color(0xFFF39C12);
  static const Color _greyInactive = Color(0xFFD1D5DB);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StudentProvider>().fetchStudentData());
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
        title: Text(
          'Asistencia',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Resumen rápido ──
            Row(
              children: [
                _buildSummaryCard(
                  context,
                  'Asistencia',
                  '90%',
                  _greenAttendance,
                ),
                const SizedBox(width: 10),
                _buildSummaryCard(context, 'Faltas', '0', _redAbsence),
                const SizedBox(width: 10),
                _buildSummaryCard(context, 'Retardos', '2', _orangeTardy),
              ],
            ),
            const SizedBox(height: 24),

            // ── Calendario ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.transparent
                        : Colors.grey.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Mes y año
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: textColor.withOpacity(0.4),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Febrero 2026',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.chevron_right,
                        color: textColor.withOpacity(0.4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Días de la semana
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
                        .map(
                          (d) => SizedBox(
                            width: 36,
                            child: Text(
                              d,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),

                  // Grid de días — Febrero 2026 empieza Domingo
                  context.watch<StudentProvider>().isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        )
                      : _buildCalendarGrid(
                          textColor,
                          context.watch<StudentProvider>().attendanceRecords,
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Leyenda ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.transparent
                        : Colors.grey.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendDot('Asistencia', _greenAttendance),
                  _buildLegendDot('Falta', _redAbsence),
                  _buildLegendDot('Retardo', _orangeTardy),
                  _buildLegendDot('Inhábil', _greyInactive),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Incidentes recientes ──
            Text(
              'Incidentes recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildIncidentTile(
              '05 Feb',
              'Retardo',
              'Matemáticas',
              _orangeTardy,
              Icons.access_time,
              context,
            ),
            const SizedBox(height: 10),
            _buildIncidentTile(
              '12 Feb',
              'Retardo',
              'Historia',
              _orangeTardy,
              Icons.access_time,
              context,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Summary Card ──
  Widget _buildSummaryCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : AppTheme.navyBlue.withOpacity(0.6),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Calendar Grid ──
  // Febrero 2026: empieza Domingo (offset 6 en lun-dom), 28 días
  Widget _buildCalendarGrid(Color textColor, Map<int, int> attendance) {
    // Febrero 2026 empieza Domingo → offset = 6 (6 celdas vacías antes del día 1 en grid Lun-Dom)
    const int offset = 6;
    const int daysInMonth = 28;

    final List<Widget> cells = [];

    // Celdas vacías de offset
    for (int i = 0; i < offset; i++) {
      cells.add(const SizedBox());
    }

    // Días del mes
    for (int day = 1; day <= daysInMonth; day++) {
      final int status = attendance[day] ?? 0;
      Color dotColor;
      switch (status) {
        case 1:
          dotColor = _redAbsence;
          break;
        case 2:
          dotColor = _orangeTardy;
          break;
        case 3:
          dotColor = _greyInactive;
          break;
        default:
          dotColor = _greenAttendance;
      }

      final bool isToday = day == 18; // Simular hoy = 18 Feb

      cells.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: isToday
                  ? BoxDecoration(
                      color: AppTheme.navyBlue,
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              alignment: Alignment.center,
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                  color: isToday
                      ? Colors.white
                      : status == 3
                      ? Colors.grey[400]
                      : textColor,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.85,
      children: cells,
    );
  }

  // ── Legend Dot ──
  Widget _buildLegendDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── Incident Tile ──
  Widget _buildIncidentTile(
    String date,
    String type,
    String subject,
    Color color,
    IconData icon,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type — $subject',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppTheme.navyBlue,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
