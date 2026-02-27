import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class TeacherProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _submissions = [];
  List<Map<String, String>> _availableClasses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // INTERRUPTOR DE BACKEND:
  // true = Usa datos de prueba (App funcional sin servidor)
  // false = Usa peticiones http reales al servidor Node/C#
  final bool _useMockData = true;

  List<Map<String, dynamic>> get students => _students;
  List<Map<String, dynamic>> get classes => _classes;
  List<Map<String, dynamic>> get submissions => _submissions;
  List<Map<String, String>> get availableClasses => _availableClasses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTeacherData() async {
    _isLoading = true;
    _errorMessage = null; // Limpiar errores previos
    notifyListeners();

    try {
      if (_useMockData) {
        // ==========================================
        // 🛑 MODO OFFLINE: DATOS DE PRUEBA (MOCKS)
        // ==========================================
        await Future.delayed(const Duration(seconds: 2));

        _students = [
          {
            'name': 'Ana García (Líder de Proyecto)',
            'id': 'PRY-2024-001',
            'grade': 'App Móvil',
            'avg': '9.8',
          },
          {
            'name': 'Luis Mendoza (Líder de Proyecto)',
            'id': 'PRY-2024-002',
            'grade': 'SaaS B2B',
            'avg': '9.7',
          },
          {
            'name': 'Sofía Hernández (Líder de Proyecto)',
            'id': 'PRY-2024-003',
            'grade': 'Juego Indie',
            'avg': '9.6',
          },
          {
            'name': 'Marco Torres (Líder de Proyecto)',
            'id': 'PRY-2024-004',
            'grade': 'E-Commerce',
            'avg': '9.5',
          },
          {
            'name': 'Diego Ramírez (Líder de Proyecto)',
            'id': 'PRY-2024-005',
            'grade': 'IA y Datos',
            'avg': '8.0',
          },
        ];

        _classes = [
          {
            'name': 'Fintech',
            'room': 'Sala A',
            'schedule': 'Lun/Mié 8:00 - 9:30',
            'students': '32',
            'color': '0xFF2EC4B6',
          },
          {
            'name': 'Videojuegos Indie',
            'room': 'Hub 2',
            'schedule': 'Mar/Jue 10:00 - 11:30',
            'students': '28',
            'color': '0xFF3B82F6',
          },
          {
            'name': 'SaaS B2B',
            'room': 'Virtual',
            'schedule': 'Lun/Mié 12:00 - 13:30',
            'students': '25',
            'color': '0xFF8B5CF6',
          },
          {
            'name': 'E-Commerce',
            'room': 'Sala C',
            'schedule': 'Mar/Jue 8:00 - 9:30',
            'students': '30',
            'color': '0xFFF39C12',
          },
        ];

        _submissions = [
          {
            'name': 'Build de Juego RPG',
            'avatar': 'https://i.pravatar.cc/150?img=12',
            'status': 'Pendiente',
            'time': 'Hace 2h',
            'grade': null,
          },
          {
            'name': 'Pitch: App Salud',
            'avatar': 'https://i.pravatar.cc/150?img=5',
            'status': 'Calificado',
            'time': null,
            'grade': 95,
          },
          {
            'name': 'MVP E-Commerce',
            'avatar': 'https://i.pravatar.cc/150?img=3',
            'status': 'Calificado',
            'time': null,
            'grade': 82,
          },
          {
            'name': 'Demo Técnica VR',
            'avatar': 'https://i.pravatar.cc/150?img=9',
            'status': 'Sin Entregar',
            'time': null,
            'grade': null,
          },
        ];

        _availableClasses = [
          {'id': '65d4f9c2a1c3000000000001', 'name': 'VR/AR', 'icon': '🥽'},
          {
            'id': '65d4f9c2a1c3000000000002',
            'name': 'E-commerce',
            'icon': '🛒',
          },
          {
            'id': '65d4f9c2a1c3000000000003',
            'name': 'IA/Machine Learning',
            'icon': '🤖',
          },
        ];
      } else {
        // ==========================================
        // 🟢 MODO PRODUCCIÓN: CONEXIÓN REAL AL API
        // ==========================================
        final baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:5074/api';

        // Ejemplo de petición (El desarrollador Backend debe ajustar las URLs y el mapeo)
        final response = await http.get(
          Uri.parse('$baseUrl/Teacher/Dashboard'),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          // TODO: Mapear la respuesta JSON a las variables _students, _classes, etc.
          // _students = List<Map<String, dynamic>>.from(data['students']);
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

  Future<bool> createAssignment({
    required String title,
    required String description,
    required String dueDate,
    required String className,
    required List<Map<String, dynamic>> rubric,
  }) async {
    try {
      final classObj = _availableClasses.firstWhere(
        (c) => c['name'] == className,
        orElse: () => {
          'id': '65d4f9c2a1c3000000000000',
        }, // Fallback por seguridad
      );
      final resolvedClassId = classObj['id'];

      final baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:5074/api';
      final url = Uri.parse('$baseUrl/Assignments');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title,
          "description": description,
          "dueDate": "${dueDate}T23:59:00Z",
          "classGroupId": resolvedClassId,
          "rubric": rubric
              .map((c) => {"criteriaName": c['title'], "maxPoints": c['score']})
              .toList(),
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Error de conexión: $e");
      return false;
    }
  }

  void clearData() {
    _students.clear();
    _classes.clear();
    _submissions.clear();
    _availableClasses.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
