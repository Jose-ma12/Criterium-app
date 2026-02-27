import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class StudentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> _assignments = [];
  Map<int, int> _attendanceRecords = {};
  bool _isLoading = false;
  String? _errorMessage;

  // INTERRUPTOR DE BACKEND:
  // true = Usa datos de prueba (App funcional sin servidor)
  // false = Usa peticiones http reales al servidor
  final bool _useMockData = true;

  List<Map<String, dynamic>> get subjects => _subjects;
  List<Map<String, dynamic>> get assignments => _assignments;
  Map<int, int> get attendanceRecords => _attendanceRecords;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStudentData() async {
    _isLoading = true;
    _errorMessage = null; // Limpiar errores previos
    notifyListeners();

    try {
      if (_useMockData) {
        // ==========================================
        // 🛑 MODO OFFLINE: DATOS DE PRUEBA (MOCKS)
        // ==========================================
        await Future.delayed(const Duration(seconds: 2));

        _subjects = [
          {
            'name': 'Desarrollo de MVP',
            'teacher': 'Mentor Alex Rivera',
            'grade': 9.8,
            'icon': Icons.calculate,
          },
          {
            'name': 'Estrategia de Mercado',
            'teacher': 'Mentor Ana Vega',
            'grade': 9.5,
            'icon': Icons.trending_up,
          },
          {
            'name': 'Levantamiento de Capital',
            'teacher': 'Mentor Daniel Ortiz',
            'grade': 10.0,
            'icon': Icons.monetization_on,
          },
        ];

        _assignments = [
          {
            'name': 'Pitch Deck Final',
            'subject': 'Estrategia de Mercado',
            'icon': Icons.trending_up,
            'date': '15 Feb 2026',
            'status': 'graded',
            'grade': '10/10',
            'feedback': '¡Excelente trabajo! Muy bien argumentado el TAM.',
          },
          {
            'name': 'Demo Técnica del Juego',
            'subject': 'Desarrollo de MVP',
            'icon': Icons.gamepad,
            'date': '14 Feb 2026',
            'status': 'graded',
            'grade': '9/10',
            'feedback':
                'Buen trabajo. Los controles necesitan un poco de pulido.',
          },
          {
            'name': 'Plan de Monetización',
            'subject': 'Levantamiento de Capital',
            'icon': Icons.monetization_on,
            'date': '18 Feb 2026',
            'status': 'pending',
            'grade': null,
            'feedback': null,
          },
        ];

        _attendanceRecords = {
          1: 3, // Dom -> inhábil
          2: 0, 3: 0, 4: 0, 5: 2, 6: 0, // Lun-Vie semana 1 (retardo día 5)
          7: 3, 8: 3, // Sáb-Dom
          9: 0, 10: 0, 11: 0, 12: 2, 13: 0, // Lun-Vie semana 2 (retardo día 12)
          14: 3, 15: 3, // Sáb-Dom
          16: 0, 17: 0, 18: 0, 19: 0, 20: 0, // semana 3
          21: 3, 22: 3, // Sáb-Dom
          23: 0, 24: 0, 25: 0, 26: 0, 27: 0, // semana 4
          28: 3, // Sáb
        };
      } else {
        // ==========================================
        // 🟢 MODO PRODUCCIÓN: CONEXIÓN REAL AL API
        // ==========================================
        final baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:5074/api';

        // Ejemplo de petición (El desarrollador Backend debe ajustar las URLs)
        final response = await http.get(
          Uri.parse('$baseUrl/Student/Dashboard'),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          // TODO: Mapear la respuesta JSON a las variables _subjects, _assignments, etc.
          // _subjects = List<Map<String, dynamic>>.from(data['subjects']);
        } else {
          throw Exception('Error del servidor: ${response.statusCode}');
        }
      }
    } catch (e) {
      _errorMessage =
          'Error de conexión. Verifica tu acceso a internet o el estado del servidor.';
      debugPrint('Error en el Provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _subjects.clear();
    _assignments.clear();
    _attendanceRecords.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
