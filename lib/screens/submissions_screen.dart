import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:criterium/screens/grade_success_screen.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:criterium/utils/pdf_generator.dart';
import 'package:provider/provider.dart';
import 'package:criterium/providers/teacher_provider.dart';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<TeacherProvider>();
      if (provider.submissions.isEmpty || provider.classes.isEmpty) {
        provider.fetchTeacherData();
      }
    });
  }

  List<Map<String, dynamic>> _filteredStudents(
    List<Map<String, dynamic>> submissions,
  ) {
    List<Map<String, dynamic>> result;

    switch (_selectedFilter) {
      case 'Pendientes':
        result = submissions
            .where(
              (s) =>
                  s['status'] == 'Pendiente' || s['status'] == 'Sin Entregar',
            )
            .toList();
        break;
      case 'Calificadas':
        result = submissions.where((s) => s['status'] == 'Calificado').toList();
        break;
      case 'Tardías':
        result = submissions.where((s) => s['status'] == 'Tardía').toList();
        break;
      default:
        result = List.from(submissions);
    }

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
    final teacherProv = context.watch<TeacherProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          widget.isTeacher ? 'Entregas: ${widget.className}' : 'Mis Tareas',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: textColor),
            onPressed: () => _showOptionsMenu(context, teacherProv),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y Filtros
          Container(
            padding: const EdgeInsets.all(16),
            color: cardColor,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Buscar estudiantes o estados',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.grey[500] : Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF334155)
                        : Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(context, 'Todos'),
                      const SizedBox(width: 12),
                      _buildFilterChip(context, 'Pendientes'),
                      const SizedBox(width: 12),
                      _buildFilterChip(context, 'Calificadas'),
                      const SizedBox(width: 12),
                      _buildFilterChip(context, 'Tardías'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: teacherProv.isLoading
                ? const Center(child: CircularProgressIndicator())
                : teacherProv.errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          teacherProv.errorMessage!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<TeacherProvider>()
                              .fetchTeacherData(),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredStudents(
                      teacherProv.submissions,
                    ).length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents(
                        teacherProv.submissions,
                      )[index];
                      return _buildStudentCard(context, student);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.isTeacher
          ? FloatingActionButton(
              onPressed: () => _showEditSheet(context),
              backgroundColor: AppTheme.navyBlue,
              child: const Icon(Icons.edit, color: Colors.white),
            )
          : null,
    );
  }

  void _showEditSheet(BuildContext context) {
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
                  'Editar Tarea',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildSheetOption(
                ctx,
                Icons.description_outlined,
                'Editar descripción de la tarea',
                const Color(0xFF3B82F6),
              ),
              _buildSheetOption(
                ctx,
                Icons.calendar_month,
                'Cambiar fecha de entrega',
                const Color(0xFFF39C12),
                onTap: () {
                  Navigator.pop(ctx);
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2027),
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
                  ).then((date) {
                    if (date != null && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Fecha cambiada a ${date.day}/${date.month}/${date.year}',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  });
                },
              ),
              _buildSheetOption(
                ctx,
                Icons.grading,
                'Modificar Rúbrica',
                const Color(0xFF8B5CF6),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsMenu(BuildContext context, TeacherProvider teacherProv) {
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
                  'Opciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildSheetOption(
                ctx,
                Icons.picture_as_pdf_outlined,
                'Exportar reporte en PDF',
                const Color(0xFF2EC4B6),
                onTap: () async {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Generando reporte...'),
                        ],
                      ),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                  await PdfGenerator.generateAndShareReport(
                    widget.className,
                    students: _filteredStudents(teacherProv.submissions),
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('✅ Reporte generado con éxito'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF2EC4B6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildSheetOption(
                ctx,
                Icons.notifications_active_outlined,
                'Enviar recordatorio a pendientes',
                const Color(0xFFF39C12),
              ),
              _buildSheetOption(
                ctx,
                Icons.archive_outlined,
                'Archivar tarea',
                const Color(0xFFE74C3C),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetOption(
    BuildContext ctx,
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDark ? Colors.grey[500] : Colors.grey,
      ),
      onTap:
          onTap ??
          () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label — acción completada'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.navyBlue
              : (isDark ? const Color(0xFF334155) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.12)
                      : Colors.grey[300]!,
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[300] : AppTheme.navyBlue),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, Map<String, dynamic> student) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

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
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: (isPending || isLate)
              ? Border.all(
                  color: (isLate ? Colors.purple : AppTheme.navyBlue)
                      .withOpacity(isDark ? 0.2 : 0.1),
                  width: 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: CachedNetworkImageProvider(student['avatar']),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      if ((isPending || isLate) && student['time'] != null)
                        Text(
                          student['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isLate
                                ? Colors.purple[300]
                                : (isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[500]),
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? Colors.grey[500] : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
