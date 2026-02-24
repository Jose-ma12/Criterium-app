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
  List<Map<String, dynamic>> _reportBars = [];

  // INTERRUPTOR DE BACKEND:
  // true = Usa datos de prueba (App funcional sin servidor)
  // false = Usa peticiones http reales al servidor
  final bool _useMockData = true;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, String>> get stat1List => _stat1List;
  List<Map<String, String>> get stat2List => _stat2List;
  List<Map<String, String>> get stat3List => _stat3List;
  List<Map<String, dynamic>> get reportBars => _reportBars;

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
            {'name': 'Ana García', 'detail': 'Promedio: 9.8'},
            {'name': 'Luis Mendoza', 'detail': 'Promedio: 9.7'},
            {'name': 'Sofía Hernández', 'detail': 'Promedio: 9.6'},
            {'name': 'Marco Torres', 'detail': 'Promedio: 9.5'},
            {'name': 'Valentina Díaz', 'detail': 'Promedio: 9.5'},
            {'name': 'Diego Ramírez', 'detail': 'Promedio: 9.4'},
          ];
          _stat2List = [
            {'name': 'Carlos Ruiz', 'detail': 'Promedio: 8.0'},
            {'name': 'María López', 'detail': 'Promedio: 7.8'},
            {'name': 'Jorge Vargas', 'detail': 'Promedio: 7.5'},
            {'name': 'Lucía Romero', 'detail': 'Promedio: 7.3'},
            {'name': 'Pablo Moreno', 'detail': 'Promedio: 7.2'},
            {'name': 'Camila Ríos', 'detail': 'Promedio: 7.1'},
            {'name': 'Tomás Herrera', 'detail': 'Promedio: 7.0'},
            {'name': 'Isabella Cruz', 'detail': 'Promedio: 7.0'},
            {'name': 'Mateo Salazar', 'detail': 'Promedio: 6.9'},
            {'name': 'Renata Flores', 'detail': 'Promedio: 6.8'},
            {'name': 'Emilio Ortega', 'detail': 'Promedio: 6.7'},
            {'name': 'Daniela Peña', 'detail': 'Promedio: 6.5'},
          ];
          _stat3List = [
            {'name': 'Elena Soto', 'detail': '3 Faltas - Promedio: 6.2'},
            {'name': 'Andrés López', 'detail': '5 Faltas - Promedio: 5.8'},
            {'name': 'Fernanda Mora', 'detail': '4 Faltas - Promedio: 5.5'},
            {'name': 'Ricardo Navarro', 'detail': '6 Faltas - Promedio: 4.9'},
          ];
          _reportBars = [
            {
              'name': 'Matemáticas Avanzadas',
              'value': 0.85,
              'pct': '85%',
              'color': const Color(0xFF2EC4B6),
            },
            {
              'name': 'Álgebra Lineal',
              'value': 0.78,
              'pct': '78%',
              'color': const Color(0xFF3B82F6),
            },
            {
              'name': 'Cálculo Diferencial',
              'value': 0.92,
              'pct': '92%',
              'color': const Color(0xFF8B5CF6),
            },
            {
              'name': 'Geometría Analítica',
              'value': 0.74,
              'pct': '74%',
              'color': const Color(0xFFF39C12),
            },
            {
              'name': 'Estadística',
              'value': 0.88,
              'pct': '88%',
              'color': const Color(0xFFE74C3C),
            },
            {
              'name': 'Trigonometría',
              'value': 0.95,
              'pct': '95%',
              'color': const Color(0xFF70C635),
            },
          ];
        } else {
          _stat1List = [
            {'name': 'Matemáticas', 'detail': '10/10'},
            {'name': 'Historia Universal', 'detail': '9.8/10'},
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
          ];
          _stat2List = [
            {'name': 'Ciencias Naturales', 'detail': '8.0/10'},
            {'name': 'Educación Física', 'detail': '7.8/10'},
            {'name': 'Historia', 'detail': 'Tarea para mañana'},
            {'name': 'Geografía', 'detail': '7.5/10'},
            {'name': 'Inglés', 'detail': 'Examen pendiente'},
          ];
          _stat3List = [
            {'name': 'Química', 'detail': '6.5/10'},
            {'name': 'Física', 'detail': '6.0/10 - 2 tareas sin entregar'},
          ];
          _reportBars = [
            {
              'name': 'Ensayo - Biología',
              'value': 0.98,
              'pct': '9.8',
              'color': const Color(0xFF2EC4B6),
            },
            {
              'name': 'Examen - Matemáticas',
              'value': 1.0,
              'pct': '10.0',
              'color': const Color(0xFF70C635),
            },
            {
              'name': 'Proyecto - Historia',
              'value': 0.92,
              'pct': '9.2',
              'color': const Color(0xFF3B82F6),
            },
            {
              'name': 'Quiz - Ciencias',
              'value': 0.85,
              'pct': '8.5',
              'color': const Color(0xFFF39C12),
            },
            {
              'name': 'Tarea - Lengua',
              'value': 0.97,
              'pct': '9.7',
              'color': const Color(0xFF8B5CF6),
            },
            {
              'name': 'Laboratorio - Química',
              'value': 0.76,
              'pct': '7.6',
              'color': const Color(0xFFE74C3C),
            },
          ];
        }
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
    _reportBars.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
