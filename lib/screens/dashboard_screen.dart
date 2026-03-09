import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:criterium/screens/evaluation_screen.dart';
import 'package:criterium/screens/submissions_screen.dart';
import 'package:criterium/screens/new_assignment_screen.dart';
import 'package:criterium/screens/profile_screen.dart';
import 'package:criterium/screens/student/assignment_history_screen.dart';
import 'package:criterium/screens/qr_scanner_screen.dart';
import 'package:criterium/screens/reports_screen.dart';
import 'package:criterium/screens/notifications_screen.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:criterium/providers/dashboard_provider.dart';
import 'package:criterium/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DashboardScreen extends StatefulWidget {
  final bool isTeacher;
  const DashboardScreen({super.key, this.isTeacher = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<DashboardProvider>().fetchDashboardData(
        widget.isTeacher,
      ),
    );
  }

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    // Construir las páginas del BottomNav dinámicamente
    _pages = [
      _buildDashboardView(),
      widget.isTeacher
          ? SubmissionsScreen(className: 'Todas', isTeacher: true)
          : const AssignmentHistoryScreen(), // <-- PANTALLA REAL CONECTADA
      ReportsScreen(isTeacher: widget.isTeacher),
      ProfileScreen(isTeacher: widget.isTeacher),
    ];

    return Scaffold(
      backgroundColor: bgColor,
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
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  widget.isTeacher ? Icons.folder_special : Icons.rocket_launch,
                ),
                label: widget.isTeacher ? 'Proyectos' : 'Mis Proyectos',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                label: 'Reportes',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
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
    );
  }

  /// Vista principal del Dashboard (antes era todo el body).
  /// Se extrajo para poder usarla como una página dentro de _pages.
  Widget _buildDashboardView() {
    final dashboardProv = context.watch<DashboardProvider>();

    if (dashboardProv.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dashboardProv.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                dashboardProv.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context
                    .read<DashboardProvider>()
                    .fetchDashboardData(widget.isTeacher),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navyBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    final authProv = context.watch<AuthProvider>();
    final user = authProv.currentUser;

    // Configuración de textos según rol leyendo del usuario real
    String rawName = user?.name ?? (widget.isTeacher ? 'Mentor' : 'Creador');
    String userName;

    // Formatear el nombre para mantener el diseño de dos líneas
    if (rawName.contains(' ')) {
      final parts = rawName.split(' ');
      userName = '${parts[0]}\n${parts.sublist(1).join(' ')}';
    } else {
      userName = 'Hola,\n$rawName';
    }

    String userRoleSubtitle = widget.isTeacher ? 'Mentor / Evaluador' : '';

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MARTES, 24 OCT',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                          color: textColor,
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
                              color: textColor.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // ── Campana de Notificaciones → SnackBar ──
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(Icons.notifications_none, color: textColor),
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
                        backgroundColor: const Color(0xFFE8EAF0),
                        backgroundImage: user != null && user.avatar.isNotEmpty
                            ? (user.avatar.startsWith('http')
                                  ? CachedNetworkImageProvider(user.avatar)
                                        as ImageProvider
                                  : FileImage(File(user.avatar)))
                            : null,
                        child: user == null || user.avatar.isEmpty
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
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
                  dashboardProv.topCardsStats['stat1Val'] ?? '0',
                  dashboardProv.topCardsStats['stat1Label'] ?? '',
                  widget.isTeacher ? Icons.class_ : Icons.trending_up,
                  const Color(0xFF2EC4B6),
                  onTap: () {
                    _showStatDetails(
                      title: widget.isTeacher
                          ? 'Proyectos Destacados'
                          : 'Categorías Top',
                      color: const Color(0xFF2EC4B6),
                      icon: widget.isTeacher ? Icons.emoji_events : Icons.star,
                      items: dashboardProv.stat1List,
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  dashboardProv.topCardsStats['stat2Val'] ?? '0',
                  dashboardProv.topCardsStats['stat2Label'] ?? '',
                  widget.isTeacher ? Icons.assignment_late : Icons.remove,
                  const Color(0xFFF39C12),
                  onTap: () {
                    _showStatDetails(
                      title: widget.isTeacher
                          ? 'Proyectos Promedio'
                          : 'Categorías Regulares',
                      color: const Color(0xFFF39C12),
                      icon: widget.isTeacher
                          ? Icons.trending_flat
                          : Icons.schedule,
                      items: dashboardProv.stat2List,
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  dashboardProv.topCardsStats['stat3Val'] ?? '0',
                  dashboardProv.topCardsStats['stat3Label'] ?? '',
                  widget.isTeacher ? Icons.people : Icons.priority_high,
                  const Color(0xFFE74C3C),
                  onTap: () {
                    _showStatDetails(
                      title: widget.isTeacher
                          ? 'Proyectos en Riesgo'
                          : 'Categorías con Baja Viabilidad',
                      color: const Color(0xFFE74C3C),
                      icon: widget.isTeacher
                          ? Icons.warning_amber_rounded
                          : Icons.trending_down,
                      items: dashboardProv.stat3List,
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
                  widget.isTeacher
                      ? 'Proyectos Recientes'
                      : 'Mis Proyectos Activos',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
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
                    child: Text(
                      'Ver todo',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // ── NUEVO BOTÓN INTEGRADO PARA CREADORES ──
            if (!widget.isTeacher) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewAssignmentScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.cloud_upload, color: Colors.white),
                  label: const Text(
                    'Subir Nuevo Proyecto',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navyBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            ...dashboardProv.activeProjects.map(
              (proj) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildClassCard(
                  context,
                  title: proj['title'],
                  subtitle: proj['subtitle'],
                  progress: proj['progress'],
                  status: proj['status'],
                  statusColor: proj['statusColor'],
                  iconData: proj['iconData'],
                  participants: proj['participants'],
                  timeLeft: proj['timeLeft'],
                  backgroundColor: proj['backgroundColor'],
                  isDark: proj['isDark'],
                  hasScanner: proj['hasScanner'] ?? false,
                  onTap: () {
                    if (widget.isTeacher) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubmissionsScreen(
                            className: proj['title'].replaceAll('\n', ' '),
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
              ),
            ),

            const SizedBox(
              height: 120,
            ), // <-- Padding extra para el navbar flotante
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
          constraints: const BoxConstraints(
            minHeight: 140,
          ), // <-- Altura mínima, permite crecer
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ), // <-- Menos padding lateral
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
                textAlign: TextAlign.center, // <-- NUEVA LÍNEA
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
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColor = Theme.of(context).cardColor;
        final textColor = isDark ? Colors.white : AppTheme.navyBlue;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.55,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
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
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
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
                              color: textColor,
                            ),
                          ),
                          Text(
                            '${items.length} ${widget.isTeacher ? "creadores" : "categorías"}',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[500],
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
              Divider(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey[200],
                height: 1,
              ),
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
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        item['detail']!,
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: isDark ? Colors.grey[500] : Colors.grey[400],
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
    double? progress,
    required String status,
    required Color statusColor,
    required IconData iconData,
    int? participants,
    String? timeLeft,
    required Color backgroundColor,
    required bool isDark,
    bool hasScanner = false,
    required VoidCallback onTap,
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
                        backgroundImage: CachedNetworkImageProvider(
                          'https://i.pravatar.cc/100?img=1',
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-8, 0),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundImage: CachedNetworkImageProvider(
                            'https://i.pravatar.cc/100?img=2',
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-16, 0),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundImage: CachedNetworkImageProvider(
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

            if (hasScanner) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final scannedCode = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QRScannerScreen(),
                      ),
                    );
                    if (scannedCode != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '✅ Sesión registrada. Código: $scannedCode',
                          ),
                          backgroundColor: const Color(0xFF2ECC71),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 18),
                  label: const Text('Escanear QR de Proyecto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF70C635),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
