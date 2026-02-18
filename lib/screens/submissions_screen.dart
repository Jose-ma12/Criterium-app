import 'package:flutter/material.dart';
import 'package:criterium/screens/grade_success_screen.dart';
import 'package:criterium/theme/app_theme.dart';

class SubmissionsScreen extends StatefulWidget {
  final String className;
  final bool isTeacher;
  const SubmissionsScreen({
    super.key,
    required this.className,
    this.isTeacher = false,
  });

  @override
  State<SubmissionsScreen> createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends State<SubmissionsScreen> {
  String _selectedFilter = 'Todos';
  String _searchQuery = '';

  // Datos simulados
  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Juan Pérez',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'status': 'Pendiente',
      'time': 'Hace 2h',
      'grade': null,
    },
    {
      'name': 'María García',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'status': 'Calificado',
      'time': null,
      'grade': 95,
    },
    {
      'name': 'Carlos Ruiz',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'status': 'Calificado',
      'time': null,
      'grade': 82,
    },
    {
      'name': 'Elena Soto',
      'avatar': 'https://i.pravatar.cc/150?img=9',
      'status': 'Sin Entregar',
      'time': null,
      'grade': null,
    },
    {
      'name': 'Diego Martínez',
      'avatar': 'https://i.pravatar.cc/150?img=7',
      'status': 'Tardía',
      'time': 'Hace 1d',
      'grade': null,
    },
    {
      'name': 'Sofía Hernández',
      'avatar': 'https://i.pravatar.cc/150?img=25',
      'status': 'Tardía',
      'time': 'Hace 3d',
      'grade': null,
    },
    {
      'name': 'Andrés López',
      'avatar': 'https://i.pravatar.cc/150?img=14',
      'status': 'Pendiente',
      'time': 'Hace 5h',
      'grade': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    List<Map<String, dynamic>> result;

    // Filtrar por estado
    switch (_selectedFilter) {
      case 'Pendientes':
        result = _students
            .where(
              (s) =>
                  s['status'] == 'Pendiente' || s['status'] == 'Sin Entregar',
            )
            .toList();
        break;
      case 'Calificadas':
        result = _students.where((s) => s['status'] == 'Calificado').toList();
        break;
      case 'Tardías':
        result = _students.where((s) => s['status'] == 'Tardía').toList();
        break;
      default: // 'Todos'
        result = List.from(_students);
    }

    // Filtrar por búsqueda de nombre
    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (s) => s['name'].toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.isTeacher ? 'Entregas: ${widget.className}' : 'Mis Tareas',
          style: const TextStyle(
            color: AppTheme.navyBlue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppTheme.navyBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y Filtros
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar estudiantes o estados',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos'),
                      const SizedBox(width: 12),
                      _buildFilterChip('Pendientes'),
                      const SizedBox(width: 12),
                      _buildFilterChip('Calificadas'),
                      const SizedBox(width: 12),
                      _buildFilterChip('Tardías'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return _buildStudentCard(student);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isTeacher
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppTheme.navyBlue,
              child: const Icon(Icons.edit, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.navyBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.navyBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    bool isPending = student['status'] == 'Pendiente';
    bool isGraded = student['status'] == 'Calificado';
    bool isMissing = student['status'] == 'Sin Entregar';
    bool isLate = student['status'] == 'Tardía';

    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.circle;

    if (isPending) {
      statusColor = AppTheme.orange;
      statusIcon = Icons.access_time_filled;
    } else if (isGraded) {
      statusColor = const Color(0xFF2ECC71);
      statusIcon = Icons.check_circle;
    } else if (isLate) {
      statusColor = Colors.purple;
      statusIcon = Icons.warning_amber_rounded;
    } else if (isMissing) {
      statusColor = Colors.grey;
      statusIcon = Icons.cancel;
    }

    return GestureDetector(
      onTap: () {
        if (isPending || isLate) {
          showDialog(
            context: context,
            builder: (context) =>
                GradeSuccessScreen(studentName: student['name']),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Borde azul si está pendiente para resaltar
          border: (isPending || isLate)
              ? Border.all(
                  color: (isLate ? Colors.purple : AppTheme.navyBlue)
                      .withOpacity(0.1),
                  width: 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(student['avatar']),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        student['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.navyBlue,
                        ),
                      ),
                      if ((isPending || isLate) && student['time'] != null)
                        Text(
                          student['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isLate
                                ? Colors.purple[300]
                                : Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(statusIcon, size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            isPending
                                ? 'Pendiente de Revisión'
                                : isLate
                                ? 'Entregada tarde'
                                : student['status'],
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (isGraded)
                        Text(
                          '${student['grade']}/100',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2ECC71),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
