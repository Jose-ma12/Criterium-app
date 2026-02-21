import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:criterium/screens/chat_screen.dart';
import 'package:criterium/theme/app_theme.dart';

class StudentDirectoryScreen extends StatefulWidget {
  const StudentDirectoryScreen({super.key});

  @override
  State<StudentDirectoryScreen> createState() => _StudentDirectoryScreenState();
}

class _StudentDirectoryScreenState extends State<StudentDirectoryScreen> {
  String _searchQuery = '';

  static final List<Map<String, String>> _students = [
    {
      'name': 'Ana García Martínez',
      'id': 'MAT-2024-001',
      'grade': '10-A',
      'avg': '9.8',
    },
    {
      'name': 'Luis Mendoza Rivera',
      'id': 'MAT-2024-002',
      'grade': '10-A',
      'avg': '9.7',
    },
    {
      'name': 'Sofía Hernández Díaz',
      'id': 'MAT-2024-003',
      'grade': '10-B',
      'avg': '9.6',
    },
    {
      'name': 'Marco Torres Vega',
      'id': 'MAT-2024-004',
      'grade': '10-A',
      'avg': '9.5',
    },
    {
      'name': 'Valentina Díaz López',
      'id': 'MAT-2024-005',
      'grade': '10-B',
      'avg': '9.5',
    },
    {
      'name': 'Diego Ramírez Soto',
      'id': 'MAT-2024-006',
      'grade': '10-C',
      'avg': '9.4',
    },
    {
      'name': 'Carlos Ruiz Peña',
      'id': 'MAT-2024-007',
      'grade': '10-A',
      'avg': '8.0',
    },
    {
      'name': 'María López Herrera',
      'id': 'MAT-2024-008',
      'grade': '10-B',
      'avg': '7.8',
    },
    {
      'name': 'Jorge Vargas Moreno',
      'id': 'MAT-2024-009',
      'grade': '10-C',
      'avg': '7.5',
    },
    {
      'name': 'Lucía Romero Cruz',
      'id': 'MAT-2024-010',
      'grade': '10-A',
      'avg': '7.3',
    },
    {
      'name': 'Pablo Moreno Silva',
      'id': 'MAT-2024-011',
      'grade': '10-B',
      'avg': '7.2',
    },
    {
      'name': 'Camila Ríos Navarro',
      'id': 'MAT-2024-012',
      'grade': '10-C',
      'avg': '7.1',
    },
    {
      'name': 'Tomás Herrera Flores',
      'id': 'MAT-2024-013',
      'grade': '10-A',
      'avg': '7.0',
    },
    {
      'name': 'Isabella Cruz Salazar',
      'id': 'MAT-2024-014',
      'grade': '10-B',
      'avg': '7.0',
    },
    {
      'name': 'Elena Soto Ramírez',
      'id': 'MAT-2024-015',
      'grade': '10-C',
      'avg': '6.2',
    },
    {
      'name': 'Andrés López Mora',
      'id': 'MAT-2024-016',
      'grade': '10-A',
      'avg': '5.8',
    },
    {
      'name': 'Fernanda Mora Ortega',
      'id': 'MAT-2024-017',
      'grade': '10-B',
      'avg': '5.5',
    },
    {
      'name': 'Ricardo Navarro Díaz',
      'id': 'MAT-2024-018',
      'grade': '10-C',
      'avg': '4.9',
    },
  ];

  List<Map<String, String>> get _filteredStudents {
    if (_searchQuery.isEmpty) return _students;
    return _students
        .where(
          (s) =>
              s['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s['id']!.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
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
          'Directorio de Alumnos',
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
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Buscar alumno...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: cardColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: textColor, width: 1.5),
                ),
              ),
            ),
          ),

          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filteredStudents.length} alumnos',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return _buildStudentTile(student, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTile(Map<String, String> student, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double avgValue = double.tryParse(student['avg']!) ?? 0;
    final Color avgColor = avgValue >= 9.0
        ? const Color(0xFF2EC4B6)
        : avgValue >= 7.0
        ? const Color(0xFFF39C12)
        : const Color(0xFFE74C3C);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.navyBlue.withOpacity(0.08),
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/100?img=${(index % 70) + 1}',
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name']!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppTheme.navyBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      student['id']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.navyBlue.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        student['grade']!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navyBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Average badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: avgColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              student['avg']!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: avgColor,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Message button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    studentName: student['name']!,
                    studentAvatar:
                        'https://i.pravatar.cc/100?img=${(index % 70) + 1}',
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.navyBlue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 18,
                color: AppTheme.navyBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
