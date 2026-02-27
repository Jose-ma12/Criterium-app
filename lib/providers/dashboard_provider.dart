import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, String>> _stat1List = [];
  List<Map<String, String>> _stat2List = [];
  List<Map<String, String>> _stat3List = [];
  List<Map<String, String>> _feedbackList = [];
  List<Map<String, dynamic>> _activeProjects = [];

  // INTERRUPTOR DE BACKEND:
  // true = Usa datos de prueba (App funcional sin servidor)
  // false = Usa peticiones http reales al servidor
  final bool _useMockData = true;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, String>> get stat1List => _stat1List;
  List<Map<String, String>> get stat2List => _stat2List;
  List<Map<String, String>> get stat3List => _stat3List;
  List<Map<String, String>> get feedbackList => _feedbackList;
  List<Map<String, dynamic>> get activeProjects => _activeProjects;

  Future<void> fetchDashboardData(bool isTeacher) async {
    _isLoading = true;
    _errorMessage = null; // Limpiar errores previos
    notifyListeners();

    try {
      if (_useMockData) {
        // ==========================================
        // 🛑 MODO OFFLINE: DATOS DE PRUEBA (MOCKS)
        // ==========================================
        await Future.delayed(const Duration(seconds: 2));

        if (isTeacher) {
          _stat1List = [
            {'name': 'Ana García', 'detail': 'Viabilidad: 9.8'},
            {'name': 'Luis Mendoza', 'detail': 'Viabilidad: 9.7'},
            {'name': 'Sofía Hernández', 'detail': 'Viabilidad: 9.6'},
            {'name': 'Marco Torres', 'detail': 'Viabilidad: 9.5'},
            {'name': 'Valentina Díaz', 'detail': 'Viabilidad: 9.5'},
            {'name': 'Diego Ramírez', 'detail': 'Viabilidad: 9.4'},
          ];
          _stat2List = [
            {'name': 'Carlos Ruiz', 'detail': 'Viabilidad: 8.0'},
            {'name': 'María López', 'detail': 'Viabilidad: 7.8'},
            {'name': 'Jorge Vargas', 'detail': 'Viabilidad: 7.5'},
            {'name': 'Lucía Romero', 'detail': 'Viabilidad: 7.3'},
            {'name': 'Pablo Moreno', 'detail': 'Viabilidad: 7.2'},
            {'name': 'Camila Ríos', 'detail': 'Viabilidad: 7.1'},
            {'name': 'Tomás Herrera', 'detail': 'Viabilidad: 7.0'},
            {'name': 'Isabella Cruz', 'detail': 'Viabilidad: 7.0'},
            {'name': 'Mateo Salazar', 'detail': 'Viabilidad: 6.9'},
            {'name': 'Renata Flores', 'detail': 'Viabilidad: 6.8'},
            {'name': 'Emilio Ortega', 'detail': 'Viabilidad: 6.7'},
            {'name': 'Daniela Peña', 'detail': 'Viabilidad: 6.5'},
          ];
          _stat3List = [
            {'name': 'Elena Soto', 'detail': 'Riesgo Alto - Viabilidad: 6.2'},
            {
              'name': 'Andrés López',
              'detail': 'Riesgo Crítico - Viabilidad: 5.8',
            },
            {
              'name': 'Fernanda Mora',
              'detail': 'Riesgo Alto - Viabilidad: 5.5',
            },
            {
              'name': 'Ricardo Navarro',
              'detail': 'Proyecto Estancado - Viabilidad: 4.9',
            },
          ];
        } else {
          _stat1List = [
            {'name': 'Estudio de Mercado', 'detail': '10/10'},
            {'name': 'UX/UI Design', 'detail': '9.8/10'},
            {'name': 'Desarrollo Backend', 'detail': '9.7/10'},
            {'name': 'Plan Financiero', 'detail': '9.5/10'},
            {'name': 'Estrategia GTM', 'detail': '9.5/10'},
            {'name': 'Pitch Deck', 'detail': '9.4/10'},
            {'name': 'Desarrollo Frontend', 'detail': '9.4/10'},
            {'name': 'Métricas de Usuario', 'detail': '9.3/10'},
            {'name': 'Monetización', 'detail': '9.3/10'},
            {'name': 'Legal y Compliance', 'detail': '9.2/10'},
            {'name': 'Branding', 'detail': '9.1/10'},
            {'name': 'QA y Testing', 'detail': '9.0/10'},
          ];
          _stat2List = [
            {'name': 'Prototipo Funcional', 'detail': '8.0/10'},
            {'name': 'Adquisición de Usuarios', 'detail': '7.8/10'},
            {
              'name': 'Arquitectura de Software',
              'detail': 'Revisión técnica pendiente',
            },
            {'name': 'Análisis de Competencia', 'detail': '7.5/10'},
            {'name': 'Retención de Usuarios', 'detail': 'Evaluación pendiente'},
          ];
          _stat3List = [
            {'name': 'Levantamiento de Capital', 'detail': '6.5/10'},
            {
              'name': 'Campañas de Marketing',
              'detail': '6.0/10 - 2 entregables sin subir',
            },
          ];
        }

        _feedbackList = [
          {
            'mentorName': isTeacher ? 'Tú (Mentor)' : 'Mentor Alex Rivera',
            'projectName': 'E-Commerce App',
            'feedback':
                'Te recomiendo migrar la base de datos a Firebase Firestore. Tus consultas actuales van a generar cuellos de botella cuando superes los 10k usuarios concurrentes.',
            'time': 'Hace 2 horas',
            'color': '0xFF2EC4B6',
          },
          {
            'mentorName': isTeacher ? 'Tú (Mentor)' : 'Mentora Ana Vega',
            'projectName': 'Juego RPG 2D',
            'feedback':
                'Excelente narrativa. Sin embargo, el esquema de monetización es débil. Sugiero implementar pases de batalla cosméticos en lugar de anuncios invasivos.',
            'time': 'Ayer',
            'color': '0xFFF39C12',
          },
          {
            'mentorName': isTeacher ? 'Tú (Mentor)' : 'Mentor Daniel Ortiz',
            'projectName': 'Plataforma SaaS B2B',
            'feedback':
                'El Pitch Deck es sólido, pero falta definir mejor el Costo de Adquisición de Clientes (CAC). Revisemos esto en la próxima mentoría 1 a 1.',
            'time': 'Hace 3 días',
            'color': '0xFF8B5CF6',
          },
        ];

        _activeProjects = [
          {
            'title': 'E-Commerce\nApp',
            'subtitle': 'Tech Startup',
            'progress': 0.65,
            'status': 'EN PROGRESO',
            'statusColor': const Color(0xFF4CAF50), // Verde
            'iconData': Icons.calculate_outlined,
            'participants': 24,
            'timeLeft': '45 min restantes',
            'backgroundColor': const Color(0xFF0F172A), // AppTheme.navyBlue
            'isDark': true,
          },
          {
            'title': 'Juego RPG\n2D',
            'subtitle': 'Indie Studio',
            'progress': null,
            'status': 'SIGUIENTE',
            'statusColor': const Color(0xFFFF9800), // Naranja
            'iconData': Icons.science_outlined,
            'participants': null,
            'timeLeft': null,
            'backgroundColor': Colors.white,
            'isDark': false,
          },
        ];
      } else {
        // ==========================================
        // 🟢 MODO PRODUCCIÓN: CONEXIÓN REAL AL API
        // ==========================================
        final baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:5074/api';
        final endpoint = isTeacher
            ? '/Teacher/DashboardStats'
            : '/Student/DashboardStats';
        final response = await http.get(Uri.parse('$baseUrl$endpoint'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          // TODO: Mapear la respuesta JSON
        } else {
          throw Exception('Error del servidor: ${response.statusCode}');
        }
      }
    } catch (e) {
      _errorMessage = 'Error de conexión. Verifica tu acceso a internet.';
      debugPrint('Error en el Provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _stat1List.clear();
    _stat2List.clear();
    _stat3List.clear();
    _feedbackList.clear();
    _activeProjects.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
