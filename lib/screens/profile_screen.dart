import 'package:flutter/material.dart';
import 'package:criterium/screens/generic_info_screen.dart';
import 'package:criterium/screens/login_screen.dart';
import 'package:criterium/screens/edit_profile_screen.dart';
import 'package:criterium/screens/submissions_screen.dart';
import 'package:criterium/screens/teacher/teacher_classes_screen.dart';
import 'package:criterium/screens/teacher/student_directory_screen.dart';
import 'package:criterium/screens/student/attendance_screen.dart';
import 'package:criterium/screens/student/assignment_history_screen.dart';
import 'package:criterium/screens/student/grades_summary_screen.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:criterium/main.dart';

class ProfileScreen extends StatefulWidget {
  final bool isTeacher;
  const ProfileScreen({super.key, this.isTeacher = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name;
  late String _role;
  late String _bio;
  late String _phone;
  late String _email;
  late String _institution;

  @override
  void initState() {
    super.initState();
    if (widget.isTeacher) {
      _name = 'Prof. Alex Rivera';
      _role = 'Instructor Senior de Matemáticas';
      _bio = 'Apasionado por las matemáticas y la enseñanza innovadora.';
      _phone = '+52 55 1234 5678';
      _email = 'alex.rivera@criterium.edu';
    } else {
      _name = 'Marlene López';
      _role = 'Estudiante - 10mo Grado';
      _bio = 'Me encanta aprender y superar retos académicos.';
      _phone = '+52 55 9876 5432';
      _email = 'marlene.lopez@criterium.edu';
    }
    _institution = 'Colegio Criterium Academy';
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          currentName: _name,
          currentBio: _bio,
          currentPhone: _phone,
          email: _email,
          role: _role,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _name = result['name'] ?? _name;
        _bio = result['bio'] ?? _bio;
        _phone = result['phone'] ?? _phone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: textColor),
            onPressed: _openEditProfile,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar y Datos
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      widget.isTeacher
                          ? 'https://i.pravatar.cc/150?img=11'
                          : 'https://i.pravatar.cc/150?img=5',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.navyBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: cardColor, width: 2),
                  ),
                  child: Icon(
                    widget.isTeacher ? Icons.verified_user : Icons.school,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _role,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              _institution,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),

            const SizedBox(height: 32),

            // Estadísticas dinámicas según rol
            Row(
              children: widget.isTeacher
                  ? [
                      _buildStatItem(
                        context,
                        'CLASES',
                        '6',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherClassesScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildStatItem(
                        context,
                        'PENDIENTES',
                        '12',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubmissionsScreen(
                                className: 'Todas',
                                isTeacher: true,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildStatItem(
                        context,
                        'ESTUDIANTES',
                        '154',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StudentDirectoryScreen(),
                            ),
                          );
                        },
                      ),
                    ]
                  : [
                      _buildStatItem(
                        context,
                        'PROMEDIO',
                        '9.8',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GradesSummaryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildStatItem(
                        context,
                        'ENTREGAS',
                        '12',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AssignmentHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildStatItem(
                        context,
                        'FALTAS',
                        '0',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AttendanceScreen(),
                            ),
                          );
                        },
                      ),
                    ],
            ),

            const SizedBox(height: 32),

            // Configuración
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Configuración de cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Modo Oscuro ──
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (_, currentMode, __) {
                final isDarkOn = currentMode == ThemeMode.dark;
                return Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.grey[200]!,
                    ),
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
                  child: SwitchListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDarkOn ? Icons.dark_mode : Icons.light_mode,
                        color: textColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Modo Oscuro',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    value: isDarkOn,
                    activeColor: const Color(0xFF2EC4B6),
                    onChanged: (value) {
                      themeNotifier.value = value
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildSettingItem(
              context,
              Icons.notifications,
              'Notificaciones',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenericInfoScreen(
                      icon: Icons.notifications,
                      title: 'Configurar Notificaciones',
                      content:
                          'Aquí podrás gestionar tus preferencias de alertas.\n\n'
                          '• Correos electrónicos: Activado\n'
                          '• Notificaciones Push: Activado\n'
                          '• Alertas de tareas: Activado',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildSettingItem(
              context,
              Icons.lock,
              'Privacidad y Seguridad',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenericInfoScreen(
                      icon: Icons.lock,
                      title: 'Privacidad',
                      content:
                          'En Criterium nos tomamos tu privacidad en serio. '
                          'Tus datos están encriptados de extremo a extremo y '
                          'solo son visibles para tu institución académica según '
                          'la Ley de Protección de Datos Educativos.',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildSettingItem(
              context,
              Icons.help,
              'Ayuda y Soporte',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenericInfoScreen(
                      icon: Icons.help_outline,
                      title: 'Centro de Ayuda',
                      content:
                          '¿Necesitas asistencia?\n\n'
                          'Contacta al soporte técnico de tu escuela o '
                          'escríbenos a soporte@criterium.app.\n\n'
                          'Versión de la App: 2.4.0 (Build 2023)',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'LEGAL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingItem(
              context,
              Icons.description,
              'Términos de servicio',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenericInfoScreen(
                      icon: Icons.description,
                      title: 'Términos Legales',
                      content:
                          'El uso de esta aplicación está sujeto a las '
                          'normativas de conducta de la institución. El usuario '
                          'se compromete a realizar evaluaciones objetivas y '
                          'respetuosas.\n\n'
                          'Criterium se reserva el derecho de modificar estos '
                          'términos en cualquier momento. El uso continuado de '
                          'la aplicación implica la aceptación de los mismos.\n\n'
                          '© 2023 Criterium. Todos los derechos reservados.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Cerrar Sesión
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: isDark
                      ? Colors.red.withOpacity(0.15)
                      : const Color(0xFFFFEBEE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Criterium v2.4.0',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F3F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: textColor.withOpacity(0.7),
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: textColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? Colors.grey[500] : Colors.grey[400],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
