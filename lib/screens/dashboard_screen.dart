import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:criterium/screens/evaluation_screen.dart';
import 'package:criterium/screens/submissions_screen.dart';
import 'package:criterium/screens/new_assignment_screen.dart';
import 'package:criterium/screens/profile_screen.dart';
import 'package:criterium/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  final bool isTeacher;
  const DashboardScreen({super.key, this.isTeacher = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  /// Lista de páginas que se muestran según el índice del BottomNavigationBar.
  /// Se construye en build() porque depende del contexto y del rol.
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construir las páginas del BottomNav dinámicamente
    _pages = [
      _buildDashboardView(),
      widget.isTeacher
          ? SubmissionsScreen(className: 'Todas', isTeacher: true)
          : const Center(
              child: Text(
                'Vista de Tareas del Alumno',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navyBlue,
                ),
              ),
            ),
      const Center(
        child: Text(
          'Reportes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.navyBlue,
          ),
        ),
      ),
      ProfileScreen(isTeacher: widget.isTeacher),
    ];

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.navyBlue,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.navyBlue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(widget.isTeacher ? Icons.school : Icons.people),
                label: widget.isTeacher ? 'Classes' : 'Students',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                label: 'Reports',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF70C635),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            backgroundColor: AppTheme.navyBlue,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
          ),
        ),
      ),
      floatingActionButton: widget.isTeacher && _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewAssignmentScreen(),
                  ),
                );
              },
              backgroundColor: AppTheme.navyBlue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  /// Vista principal del Dashboard (antes era todo el body).
  /// Se extrajo para poder usarla como una página dentro de _pages.
  Widget _buildDashboardView() {
    // Configuración de textos según rol
    String userName = widget.isTeacher
        ? 'Prof. Alex\nRivera'
        : 'Hola,\nMarlene';
    String userRoleSubtitle = widget.isTeacher ? 'Instructor Senior' : '';

    // Stats
    String stat1Val = widget.isTeacher ? '6' : '12';
    String stat1Label = widget.isTeacher ? 'CLASES' : 'ALTO';

    String stat2Val = widget.isTeacher ? '12' : '5';
    String stat2Label = widget.isTeacher ? 'PENDIENTES' : 'MEDIO';

    String stat3Val = widget.isTeacher ? '4' : '2';
    String stat3Label = widget.isTeacher ? 'ATENCIÓN' : 'RIESGO';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MARTES, 24 OCT',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        color: AppTheme.navyBlue,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    if (widget.isTeacher)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          userRoleSubtitle,
                          style: TextStyle(
                            color: AppTheme.navyBlue.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    // ── Campana de Notificaciones → SnackBar ──
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sin notificaciones nuevas'),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.notifications_none,
                          color: AppTheme.navyBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // ── Avatar → Navega a ProfileScreen ──
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(isTeacher: widget.isTeacher),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          widget.isTeacher
                              ? 'https://i.pravatar.cc/150?img=11'
                              : 'https://i.pravatar.cc/100?img=5',
                        ),
                        backgroundColor: const Color(0xFFE8EAF0),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats Cards Row
            Row(
              children: [
                _buildStatCard(
                  context,
                  stat1Val,
                  stat1Label,
                  widget.isTeacher ? Icons.class_ : Icons.trending_up,
                  const Color(0xFF2EC4B6),
                  onTap: () {
                    _showStatDetails(
                      title: widget.isTeacher
                          ? 'Cuadro de Honor'
                          : 'Materias Excelentes',
                      color: const Color(0xFF2EC4B6),
                      icon: widget.isTeacher ? Icons.emoji_events : Icons.star,
                      items: widget.isTeacher
                          ? [
                              {'name': 'Ana García', 'detail': 'Promedio: 9.8'},
                              {
                                'name': 'Luis Mendoza',
                                'detail': 'Promedio: 9.7',
                              },
                              {
                                'name': 'Sofía Hernández',
                                'detail': 'Promedio: 9.6',
                              },
                              {
                                'name': 'Marco Torres',
                                'detail': 'Promedio: 9.5',
                              },
                              {
                                'name': 'Valentina Díaz',
                                'detail': 'Promedio: 9.5',
                              },
                              {
                                'name': 'Diego Ramírez',
                                'detail': 'Promedio: 9.4',
                              },
                            ]
                          : [
                              {'name': 'Matemáticas', 'detail': '10/10'},
                              {
                                'name': 'Historia Universal',
                                'detail': '9.8/10',
                              },
                              {'name': 'Lengua Española', 'detail': '9.7/10'},
                              {'name': 'Biología', 'detail': '9.5/10'},
                              {'name': 'Educación Física', 'detail': '9.5/10'},
                              {'name': 'Ética y Valores', 'detail': '9.4/10'},
                              {'name': 'Artes Visuales', 'detail': '9.4/10'},
                              {'name': 'Tecnología', 'detail': '9.3/10'},
                              {'name': 'Música', 'detail': '9.3/10'},
                              {'name': 'Civismo', 'detail': '9.2/10'},
                              {'name': 'Tutoría', 'detail': '9.1/10'},
                              {'name': 'Lectura', 'detail': '9.0/10'},
                            ],
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  stat2Val,
                  stat2Label,
                  widget.isTeacher ? Icons.assignment_late : Icons.remove,
                  const Color(0xFFF39C12),
                  onTap: () {
                    _showStatDetails(
                      title: widget.isTeacher
                          ? 'Rendimiento Regular'
                          : 'Materias Regulares',
                      color: const Color(0xFFF39C12),
                      icon: widget.isTeacher
                          ? Icons.trending_flat
                          : Icons.schedule,
                      items: widget.isTeacher
                          ? [
                              {
                                'name': 'Carlos Ruiz',
                                'detail': 'Promedio: 8.0',
                              },
                              {
                                'name': 'María López',
                                'detail': 'Promedio: 7.8',
                              },
                              {
                                'name': 'Jorge Vargas',
                                'detail': 'Promedio: 7.5',
                              },
                              {
                                'name': 'Lucía Romero',
                                'detail': 'Promedio: 7.3',
                              },
                              {
                                'name': 'Pablo Moreno',
                                'detail': 'Promedio: 7.2',
                              },
                              {
                                'name': 'Camila Ríos',
                                'detail': 'Promedio: 7.1',
                              },
                              {
                                'name': 'Tomás Herrera',
                                'detail': 'Promedio: 7.0',
                              },
                              {
                                'name': 'Isabella Cruz',
                                'detail': 'Promedio: 7.0',
                              },
                              {
                                'name': 'Mateo Salazar',
                                'detail': 'Promedio: 6.9',
                              },
                              {
                                'name': 'Renata Flores',
                                'detail': 'Promedio: 6.8',
                              },
                              {
                                'name': 'Emilio Ortega',
                                'detail': 'Promedio: 6.7',
                              },
                              {
                                'name': 'Daniela Peña',
                                'detail': 'Promedio: 6.5',
                              },
                            ]
                          : [
                              {
                                'name': 'Ciencias Naturales',
                                'detail': '8.0/10',
                              },
                              {'name': 'Educación Física', 'detail': '7.8/10'},
                              {
                                'name': 'Historia',
                                'detail': 'Tarea para mañana',
                              },
                              {'name': 'Geografía', 'detail': '7.5/10'},
                              {'name': 'Inglés', 'detail': 'Examen pendiente'},
                            ],
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  stat3Val,
                  stat3Label,
                  widget.isTeacher ? Icons.people : Icons.priority_high,
                  const Color(0xFFE74C3C),
                  onTap: () {
                    _showStatDetails(
                      title: widget.isTeacher
                          ? 'Riesgo Académico'
                          : 'Materias en Riesgo',
                      color: const Color(0xFFE74C3C),
                      icon: widget.isTeacher
                          ? Icons.warning_amber_rounded
                          : Icons.trending_down,
                      items: widget.isTeacher
                          ? [
                              {
                                'name': 'Elena Soto',
                                'detail': '3 Faltas - Promedio: 6.2',
                              },
                              {
                                'name': 'Andrés López',
                                'detail': '5 Faltas - Promedio: 5.8',
                              },
                              {
                                'name': 'Fernanda Mora',
                                'detail': '4 Faltas - Promedio: 5.5',
                              },
                              {
                                'name': 'Ricardo Navarro',
                                'detail': '6 Faltas - Promedio: 4.9',
                              },
                            ]
                          : [
                              {'name': 'Química', 'detail': '6.5/10'},
                              {
                                'name': 'Física',
                                'detail': '6.0/10 - 2 tareas sin entregar',
                              },
                            ],
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Clases Activas Header + "Ver todo" ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isTeacher ? 'Mis Clases' : 'Clases Activas',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.navyBlue,
                  ),
                ),
                // ── "Ver todo" → solo para maestros ──
                if (widget.isTeacher)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubmissionsScreen(
                            className: 'Todas',
                            isTeacher: true,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Ver todo',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Main Class Card (Matemáticas)
            _buildClassCard(
              context,
              title: 'Matemáticas\n101',
              subtitle: 'Aula 3B',
              progress: 0.65,
              status: 'EN PROGRESO',
              statusColor: Colors.green,
              iconData: Icons.calculate_outlined,
              participants: 24,
              timeLeft: '45 min restantes',
              backgroundColor: AppTheme.navyBlue,
              isDark: true,
              onTap: () {
                if (widget.isTeacher) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubmissionsScreen(
                        className: 'Matemáticas 101',
                        isTeacher: widget.isTeacher,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EvaluationScreen(),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            // Secondary Class Card (Ciencias)
            _buildClassCard(
              context,
              title: 'Ciencias\nNaturales',
              subtitle: 'Laboratorio 2',
              status: 'SIGUIENTE',
              statusColor: Colors.orange,
              iconData: Icons.science_outlined,
              backgroundColor: Colors.white,
              isDark: false,
            ),

            const SizedBox(height: 16),

            // Completed Class Card (Historia)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COMPLETADA',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Historia Universal',
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Función de escaneo QR próximamente'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner, size: 18),
                    label: const Text('Escanear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF70C635),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Espaciado extra si hay FAB
            if (widget.isTeacher) const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom Sheet para detalles del semáforo ──
  void _showStatDetails({
    required String title,
    required Color color,
    required IconData icon,
    required List<Map<String, String>> items,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.55,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.navyBlue,
                            ),
                          ),
                          Text(
                            '${items.length} ${widget.isTeacher ? "estudiantes" : "materias"}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[200], height: 1),
              // List
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final initial = item['name']![0].toUpperCase();
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.12),
                        child: Text(
                          initial,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      title: Text(
                        item['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.navyBlue,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        item['detail']!,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required IconData iconData,
    required Color backgroundColor,
    required bool isDark,
    double? progress,
    int? participants,
    String? timeLeft,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppTheme.navyBlue : const Color(0xFF94A3B8))
                  .withValues(alpha: isDark ? 0.3 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    iconData,
                    color: isDark ? const Color(0xFF70C635) : AppTheme.navyBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: isDark ? Colors.white : AppTheme.navyBlue,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: isDark ? Colors.white70 : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            if (progress != null) ...[
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2EC4B6),
                ),
                minHeight: 6,
                borderRadius: BorderRadius.circular(10),
              ),
            ],

            if (participants != null && timeLeft != null) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/100?img=1',
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-8, 0),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/100?img=2',
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-16, 0),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/100?img=3',
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-24, 0),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF70C635),
                          child: Text(
                            '+$participants',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.navyBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    timeLeft,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppTheme.navyBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
