import 'package:flutter/material.dart';

class StudentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> _assignments = [];
  Map<int, int> _attendanceRecords = {};
  bool _isLoading = false;
  String? _errorMessage;

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
      await Future.delayed(const Duration(seconds: 2));

      _subjects = [
        {
          'name': 'Matemáticas',
          'teacher': 'Prof. Alex Rivera',
          'grade': 9.8,
          'icon': Icons.calculate,
        },
        {
          'name': 'Historia',
          'teacher': 'Prof. Carmen Vega',
          'grade': 9.5,
          'icon': Icons.menu_book,
        },
        {
          'name': 'Ciencias',
          'teacher': 'Prof. Daniel Ortiz',
          'grade': 10.0,
          'icon': Icons.science,
        },
        {
          'name': 'Biología',
          'teacher': 'Prof. Laura Méndez',
          'grade': 9.7,
          'icon': Icons.eco,
        },
        {
          'name': 'Español',
          'teacher': 'Prof. Sofía Reyes',
          'grade': 10.0,
          'icon': Icons.auto_stories,
        },
        {
          'name': 'Inglés',
          'teacher': 'Prof. James Smith',
          'grade': 9.6,
          'icon': Icons.translate,
        },
        {
          'name': 'Física',
          'teacher': 'Prof. Roberto Díaz',
          'grade': 9.9,
          'icon': Icons.bolt,
        },
        {
          'name': 'Ética',
          'teacher': 'Prof. María Torres',
          'grade': 10.0,
          'icon': Icons.balance,
        },
        {
          'name': 'Geografía',
          'teacher': 'Prof. Andrés Luna',
          'grade': 9.3,
          'icon': Icons.public,
        },
      ];

      _assignments = [
        {
          'name': 'Ensayo: Revolución Francesa',
          'subject': 'Historia',
          'icon': Icons.menu_book,
          'date': '15 Feb 2026',
          'status': 'graded',
          'grade': '10/10',
          'feedback': '¡Excelente trabajo, Marlene! Muy bien argumentado.',
        },
        {
          'name': 'Ejercicios Cap. 5 — Ecuaciones',
          'subject': 'Matemáticas',
          'icon': Icons.calculate,
          'date': '14 Feb 2026',
          'status': 'graded',
          'grade': '9/10',
          'feedback': 'Buen trabajo. Revisa el ejercicio 3.',
        },
        {
          'name': 'Informe de Laboratorio: Ácidos',
          'subject': 'Ciencias',
          'icon': Icons.science,
          'date': '18 Feb 2026',
          'status': 'pending',
          'grade': null,
          'feedback': null,
        },
        {
          'name': 'Presentación: Ecosistemas',
          'subject': 'Biología',
          'icon': Icons.eco,
          'date': '12 Feb 2026',
          'status': 'graded',
          'grade': '10/10',
          'feedback': '¡Presentación impecable! Sigue así.',
        },
        {
          'name': 'Cuestionario Unidad 3',
          'subject': 'Geografía',
          'icon': Icons.public,
          'date': '10 Feb 2026',
          'status': 'late',
          'grade': null,
          'feedback': null,
        },
        {
          'name': 'Resumen: Don Quijote Cap. 1-5',
          'subject': 'Español',
          'icon': Icons.auto_stories,
          'date': '20 Feb 2026',
          'status': 'pending',
          'grade': null,
          'feedback': null,
        },
        {
          'name': 'Mapa Conceptual: La Célula',
          'subject': 'Biología',
          'icon': Icons.eco,
          'date': '08 Feb 2026',
          'status': 'graded',
          'grade': '9.5/10',
          'feedback': 'Muy completo. Agrega la mitocondria en detalle.',
        },
        {
          'name': 'Ejercicios de Trigonometría',
          'subject': 'Matemáticas',
          'icon': Icons.calculate,
          'date': '06 Feb 2026',
          'status': 'graded',
          'grade': '10/10',
          'feedback': '¡Perfecto! Dominas el tema.',
        },
        {
          'name': 'Línea del Tiempo: WWII',
          'subject': 'Historia',
          'icon': Icons.menu_book,
          'date': '04 Feb 2026',
          'status': 'graded',
          'grade': '9/10',
          'feedback': 'Faltó la batalla de Stalingrado.',
        },
        {
          'name': 'Vocabulario Unit 4',
          'subject': 'Inglés',
          'icon': Icons.translate,
          'date': '22 Feb 2026',
          'status': 'pending',
          'grade': null,
          'feedback': null,
        },
        {
          'name': 'Proyecto: Circuitos Eléctricos',
          'subject': 'Física',
          'icon': Icons.bolt,
          'date': '02 Feb 2026',
          'status': 'graded',
          'grade': '10/10',
          'feedback': '¡Excelente demostración práctica!',
        },
        {
          'name': 'Actividad: Valores Cívicos',
          'subject': 'Ética',
          'icon': Icons.balance,
          'date': '01 Feb 2026',
          'status': 'graded',
          'grade': '10/10',
          'feedback': 'Reflexión muy madura.',
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
    } catch (e) {
      _errorMessage = 'Error de conexión. Verifica tu acceso a internet.';
      debugPrint('Error en el Provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
