import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:criterium/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'urgent',
      'title': 'Alerta de faltas',
      'body': 'Elena Soto ha acumulado 3 faltas consecutivas sin justificante.',
      'time': 'Hace 15 min',
      'read': false,
      'icon': Icons.warning_amber_rounded,
      'color': const Color(0xFFE74C3C),
    },
    {
      'type': 'academic',
      'title': 'Entrega tardía',
      'body':
          'Juan Pérez entregó la tarea \"Ensayo de Biología\" fuera de tiempo.',
      'time': 'Hace 1h',
      'read': false,
      'icon': Icons.assignment_late,
      'color': const Color(0xFFF39C12),
    },
    {
      'type': 'academic',
      'title': 'Nueva entrega',
      'body': 'María García envió su tarea de Álgebra Lineal para revisión.',
      'time': 'Hace 2h',
      'read': false,
      'icon': Icons.assignment_turned_in,
      'color': const Color(0xFF2EC4B6),
    },
    {
      'type': 'system',
      'title': 'Mantenimiento programado',
      'body':
          'El sistema estará en mantenimiento el domingo de 2:00 a 5:00 AM.',
      'time': 'Hace 4h',
      'read': true,
      'icon': Icons.build_circle_outlined,
      'color': const Color(0xFF3B82F6),
    },
    {
      'type': 'academic',
      'title': 'Calificación publicada',
      'body': 'Se publicaron las calificaciones del examen parcial de Cálculo.',
      'time': 'Ayer',
      'read': true,
      'icon': Icons.grading,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'type': 'urgent',
      'title': 'Baja de promedio',
      'body': 'Andrés López Mora bajó su promedio a 5.8. Se requiere atención.',
      'time': 'Ayer',
      'read': true,
      'icon': Icons.trending_down,
      'color': const Color(0xFFE74C3C),
    },
    {
      'type': 'system',
      'title': 'Nueva función disponible',
      'body':
          'Ya puedes exportar reportes de calificaciones a Excel desde el panel.',
      'time': 'Hace 2 días',
      'read': true,
      'icon': Icons.new_releases_outlined,
      'color': const Color(0xFF70C635),
    },
    {
      'type': 'academic',
      'title': 'Recordatorio de entrega',
      'body': '5 alumnos aún no entregan la tarea de Historia Universal.',
      'time': 'Hace 3 días',
      'read': true,
      'icon': Icons.timer_outlined,
      'color': const Color(0xFFF39C12),
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
          'Notificaciones',
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Todas marcadas como leídas'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Text(
              'Leer todo',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return _buildNotificationTile(context, n);
        },
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, Map<String, dynamic> n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;
    final bool isUnread = !(n['read'] as bool);
    final Color color = n['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread
            ? (isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEEF2FF))
            : cardColor,
        borderRadius: BorderRadius.circular(18),
        border: isUnread
            ? Border.all(color: AppTheme.navyBlue.withOpacity(0.08))
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(n['icon'] as IconData, color: color, size: 22),
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        n['title'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: isUnread
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  n['body'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  n['time'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
