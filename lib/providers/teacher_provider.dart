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
            'name': 'Ana García Martínez',
            'id': 'MAT-2024-001',
            'grade': '10-A',
            'avg': '9.8',
          },
          {
            'name': 'Luis Mendoza Rivera',
            'id': 'MAT-2024-002',
            'grade': '10-A',
            'avg': '9.7',
          },
          {
            'name': 'Sofía Hernández Díaz',
            'id': 'MAT-2024-003',
            'grade': '10-B',
            'avg': '9.6',
          },
          {
            'name': 'Marco Torres Vega',
            'id': 'MAT-2024-004',
            'grade': '10-A',
            'avg': '9.5',
          },
          {
            'name': 'Valentina Díaz López',
            'id': 'MAT-2024-005',
            'grade': '10-B',
            'avg': '9.5',
          },
          {
            'name': 'Diego Ramírez Soto',
            'id': 'MAT-2024-006',
            'grade': '10-C',
            'avg': '9.4',
          },
          {
            'name': 'Carlos Ruiz Peña',
            'id': 'MAT-2024-007',
            'grade': '10-A',
            'avg': '8.0',
          },
          {
            'name': 'María López Herrera',
            'id': 'MAT-2024-008',
            'grade': '10-B',
            'avg': '7.8',
          },
          {
            'name': 'Jorge Vargas Moreno',
            'id': 'MAT-2024-009',
            'grade': '10-C',
            'avg': '7.5',
          },
          {
            'name': 'Lucía Romero Cruz',
            'id': 'MAT-2024-010',
            'grade': '10-A',
            'avg': '7.3',
          },
          {
            'name': 'Pablo Moreno Silva',
            'id': 'MAT-2024-011',
            'grade': '10-B',
            'avg': '7.2',
          },
          {
            'name': 'Camila Ríos Navarro',
            'id': 'MAT-2024-012',
            'grade': '10-C',
            'avg': '7.1',
          },
          {
            'name': 'Tomás Herrera Flores',
            'id': 'MAT-2024-013',
            'grade': '10-A',
            'avg': '7.0',
          },
          {
            'name': 'Isabella Cruz Salazar',
            'id': 'MAT-2024-014',
            'grade': '10-B',
            'avg': '7.0',
          },
          {
            'name': 'Elena Soto Ramírez',
            'id': 'MAT-2024-015',
            'grade': '10-C',
            'avg': '6.2',
          },
          {
            'name': 'Andrés López Mora',
            'id': 'MAT-2024-016',
            'grade': '10-A',
            'avg': '5.8',
          },
          {
            'name': 'Fernanda Mora Ortega',
            'id': 'MAT-2024-017',
            'grade': '10-B',
            'avg': '5.5',
          },
          {
            'name': 'Ricardo Navarro Díaz',
            'id': 'MAT-2024-018',
            'grade': '10-C',
            'avg': '4.9',
          },
        ];

        _classes = [
          {
            'name': 'Matemáticas Avanzadas',
            'room': 'Aula 3B',
            'schedule': 'Lun/Mié 8:00 - 9:30',
            'students': '32',
            'color': '0xFF2EC4B6',
          },
          {
            'name': 'Álgebra Lineal',
            'room': 'Aula 5A',
            'schedule': 'Mar/Jue 10:00 - 11:30',
            'students': '28',
            'color': '0xFF3B82F6',
          },
          {
            'name': 'Cálculo Diferencial',
            'room': 'Aula 2C',
            'schedule': 'Lun/Mié 12:00 - 13:30',
            'students': '25',
            'color': '0xFF8B5CF6',
          },
          {
            'name': 'Geometría Analítica',
            'room': 'Aula 4D',
            'schedule': 'Mar/Jue 8:00 - 9:30',
            'students': '30',
            'color': '0xFFF39C12',
          },
          {
            'name': 'Estadística',
            'room': 'Aula 1A',
            'schedule': 'Vie 8:00 - 11:00',
            'students': '22',
            'color': '0xFFE74C3C',
          },
          {
            'name': 'Trigonometría',
            'room': 'Aula 6B',
            'schedule': 'Lun/Mié 14:00 - 15:30',
            'students': '17',
            'color': '0xFF70C635',
          },
        ];

        _submissions = [
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

        _availableClasses = [
          {
            'id': '65d4f9c2a1c3000000000001',
            'name': 'Matemáticas 101',
            'icon': '📐',
          },
          {
            'id': '65d4f9c2a1c3000000000002',
            'name': 'Biología - 10mo A',
            'icon': '🧬',
          },
          {
            'id': '65d4f9c2a1c3000000000003',
            'name': 'Historia Universal',
            'icon': '📜',
          },
          {
            'id': '65d4f9c2a1c3000000000004',
            'name': 'Ciencias Naturales',
            'icon': '🔬',
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
