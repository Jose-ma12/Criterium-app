import 'package:flutter/material.dart';
import 'package:criterium/theme/app_theme.dart';

class AssignmentHistoryScreen extends StatefulWidget {
  const AssignmentHistoryScreen({super.key});

  @override
  State<AssignmentHistoryScreen> createState() =>
      _AssignmentHistoryScreenState();
}

class _AssignmentHistoryScreenState extends State<AssignmentHistoryScreen> {
  int _selectedFilter = 0; // 0=Todas, 1=Calificadas, 2=Pendientes

  // ── Mock Data ──
  final List<Map<String, dynamic>> _assignments = [
    {
      'name': 'Ensayo: Revolución Francesa',
      'subject': 'Historia',
      'icon': Icons.menu_book,
      'date': '15 Feb 2026',
      'status': 'graded', // graded, pending, late
      'grade': '10/10',
      'feedback': '¡Excelente trabajo, Marlene! Muy bien argumentado.',
    },
    {
      'name': 'Ejercicios Cap. 5 — Ecuaciones',
      'subject': 'Matemáticas',
      'icon': Icons.calculate,
      'date': '14 Feb 2026',
      'status': 'graded',
      'grade': '9/10',
      'feedback': 'Buen trabajo. Revisa el ejercicio 3.',
    },
    {
      'name': 'Informe de Laboratorio: Ácidos',
      'subject': 'Ciencias',
      'icon': Icons.science,
      'date': '18 Feb 2026',
      'status': 'pending',
      'grade': null,
      'feedback': null,
    },
    {
      'name': 'Presentación: Ecosistemas',
      'subject': 'Biología',
      'icon': Icons.eco,
      'date': '12 Feb 2026',
      'status': 'graded',
      'grade': '10/10',
      'feedback': '¡Presentación impecable! Sigue así.',
    },
    {
      'name': 'Cuestionario Unidad 3',
      'subject': 'Geografía',
      'icon': Icons.public,
      'date': '10 Feb 2026',
      'status': 'late',
      'grade': null,
      'feedback': null,
    },
    {
      'name': 'Resumen: Don Quijote Cap. 1-5',
      'subject': 'Español',
      'icon': Icons.auto_stories,
      'date': '20 Feb 2026',
      'status': 'pending',
      'grade': null,
      'feedback': null,
    },
    {
      'name': 'Mapa Conceptual: La Célula',
      'subject': 'Biología',
      'icon': Icons.eco,
      'date': '08 Feb 2026',
      'status': 'graded',
      'grade': '9.5/10',
      'feedback': 'Muy completo. Agrega la mitocondria en detalle.',
    },
    {
      'name': 'Ejercicios de Trigonometría',
      'subject': 'Matemáticas',
      'icon': Icons.calculate,
      'date': '06 Feb 2026',
      'status': 'graded',
      'grade': '10/10',
      'feedback': '¡Perfecto! Dominas el tema.',
    },
    {
      'name': 'Línea del Tiempo: WWII',
      'subject': 'Historia',
      'icon': Icons.menu_book,
      'date': '04 Feb 2026',
      'status': 'graded',
      'grade': '9/10',
      'feedback': 'Faltó la batalla de Stalingrado.',
    },
    {
      'name': 'Vocabulario Unit 4',
      'subject': 'Inglés',
      'icon': Icons.translate,
      'date': '22 Feb 2026',
      'status': 'pending',
      'grade': null,
      'feedback': null,
    },
    {
      'name': 'Proyecto: Circuitos Eléctricos',
      'subject': 'Física',
      'icon': Icons.bolt,
      'date': '02 Feb 2026',
      'status': 'graded',
      'grade': '10/10',
      'feedback': '¡Excelente demostración práctica!',
    },
    {
      'name': 'Actividad: Valores Cívicos',
      'subject': 'Ética',
      'icon': Icons.balance,
      'date': '01 Feb 2026',
      'status': 'graded',
      'grade': '10/10',
      'feedback': 'Reflexión muy madura.',
    },
  ];

  List<Map<String, dynamic>> get _filteredAssignments {
    if (_selectedFilter == 1) {
      return _assignments.where((a) => a['status'] == 'graded').toList();
    } else if (_selectedFilter == 2) {
      return _assignments
          .where((a) => a['status'] == 'pending' || a['status'] == 'late')
          .toList();
    }
    return _assignments;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAssignments;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Mis Entregas',
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
      body: Column(
        children: [
          // ── Resumen rápido ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildMiniStat(
                  '${_assignments.length}',
                  'Total',
                  AppTheme.navyBlue,
                ),
                const SizedBox(width: 10),
                _buildMiniStat(
                  '${_assignments.where((a) => a['status'] == 'graded').length}',
                  'Calificadas',
                  const Color(0xFF2ECC71),
                ),
                const SizedBox(width: 10),
                _buildMiniStat(
                  '${_assignments.where((a) => a['status'] == 'pending').length}',
                  'Pendientes',
                  const Color(0xFFF39C12),
                ),
                const SizedBox(width: 10),
                _buildMiniStat(
                  '${_assignments.where((a) => a['status'] == 'late').length}',
                  'Tardías',
                  const Color(0xFFE74C3C),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Filtros ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip('Todas', 0),
                const SizedBox(width: 8),
                _buildFilterChip('Calificadas', 1),
                const SizedBox(width: 8),
                _buildFilterChip('Pendientes', 2),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Lista de entregas ──
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filtered.length + 1, // +1 for bottom padding
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == filtered.length) {
                  return const SizedBox(height: 24);
                }
                return _buildAssignmentCard(filtered[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Mini Stat ──
  Widget _buildMiniStat(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter Chip ──
  Widget _buildFilterChip(String label, int index) {
    final bool isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.navyBlue : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppTheme.navyBlue : Colors.grey[300]!,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.navyBlue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  // ── Assignment Card ──
  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    final String status = assignment['status'];
    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case 'graded':
        statusColor = const Color(0xFF2ECC71);
        statusLabel = assignment['grade'];
        statusIcon = Icons.check_circle;
        break;
      case 'late':
        statusColor = const Color(0xFFE74C3C);
        statusLabel = 'Tardía';
        statusIcon = Icons.warning_amber_rounded;
        break;
      default:
        statusColor = const Color(0xFFF39C12);
        statusLabel = 'Por entregar';
        statusIcon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icono de materia
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.navyBlue.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  assignment['icon'],
                  color: AppTheme.navyBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Nombre y materia
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.navyBlue,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      assignment['subject'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Calificación / Estado
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: status == 'graded' ? 18 : 13,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    assignment['date'],
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
          // Feedback del profesor
          if (status == 'graded' && assignment['feedback'] != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2ECC71).withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      assignment['feedback'],
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
