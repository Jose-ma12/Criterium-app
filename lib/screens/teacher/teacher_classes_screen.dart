import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:criterium/screens/submissions_screen.dart';
import 'package:criterium/theme/app_theme.dart';

class TeacherClassesScreen extends StatelessWidget {
  const TeacherClassesScreen({super.key});

  static final List<Map<String, String>> _classes = [
    {
      'name': 'Matemáticas Avanzadas',
      'room': 'Aula 3B',
      'schedule': 'Lun/Mié 8:00 - 9:30',
      'students': '32',
      'color': '0xFF2EC4B6',
    },
    {
      'name': 'Álgebra Lineal',
      'room': 'Aula 5A',
      'schedule': 'Mar/Jue 10:00 - 11:30',
      'students': '28',
      'color': '0xFF3B82F6',
    },
    {
      'name': 'Cálculo Diferencial',
      'room': 'Aula 2C',
      'schedule': 'Lun/Mié 12:00 - 13:30',
      'students': '25',
      'color': '0xFF8B5CF6',
    },
    {
      'name': 'Geometría Analítica',
      'room': 'Aula 4D',
      'schedule': 'Mar/Jue 8:00 - 9:30',
      'students': '30',
      'color': '0xFFF39C12',
    },
    {
      'name': 'Estadística',
      'room': 'Aula 1A',
      'schedule': 'Vie 8:00 - 11:00',
      'students': '22',
      'color': '0xFFE74C3C',
    },
    {
      'name': 'Trigonometría',
      'room': 'Aula 6B',
      'schedule': 'Lun/Mié 14:00 - 15:30',
      'students': '17',
      'color': '0xFF70C635',
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
          'Mis Clases',
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
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: _classes.length,
        itemBuilder: (context, index) {
          final cls = _classes[index];
          final color = Color(int.parse(cls['color']!));
          return _buildClassCard(context, cls, color);
        },
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context,
    Map<String, String> cls,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SubmissionsScreen(className: cls['name']!, isTeacher: true),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.class_, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cls['name']!,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppTheme.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.room_outlined,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        cls['room']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          cls['schedule']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Student count badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_alt_outlined, size: 14, color: color),
                  const SizedBox(width: 4),
                  Text(
                    cls['students']!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
