import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _notifications = [];
  Map<String, List<Map<String, dynamic>>> _chatSessions = {};
  List<Map<String, dynamic>> _evaluationTeam = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get notifications => _notifications;
  List<Map<String, dynamic>> get evaluationTeam => _evaluationTeam;

  List<Map<String, dynamic>> getChatFor(String studentName) {
    return _chatSessions[studentName] ?? [];
  }

  Future<void> fetchAppData() async {
    _isLoading = true;
    _errorMessage = null; // Limpiar errores previos
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _notifications = [
        {
          'type': 'urgent',
          'title': 'Alerta de faltas',
          'body':
              'Elena Soto ha acumulado 3 faltas consecutivas sin justificante.',
          'time': 'Hace 15 min',
          'read': false,
          'icon': Icons.warning_amber_rounded,
          'color': const Color(0xFFE74C3C),
        },
        {
          'type': 'academic',
          'title': 'Entrega tardía',
          'body':
              'Juan Pérez entregó la tarea "Ensayo de Biología" fuera de tiempo.',
          'time': 'Hace 1h',
          'read': false,
          'icon': Icons.assignment_late,
          'color': const Color(0xFFF39C12),
        },
        {
          'type': 'academic',
          'title': 'Nueva entrega',
          'body':
              'María García envió su tarea de Álgebra Lineal para revisión.',
          'time': 'Hace 2h',
          'read': false,
          'icon': Icons.assignment_turned_in,
          'color': const Color(0xFF2EC4B6),
        },
        {
          'type': 'system',
          'title': 'Mantenimiento programado',
          'body':
              'El sistema estará en mantenimiento el domingo de 2:00 a 5:00 AM.',
          'time': 'Hace 4h',
          'read': true,
          'icon': Icons.build_circle_outlined,
          'color': const Color(0xFF3B82F6),
        },
        {
          'type': 'academic',
          'title': 'Calificación publicada',
          'body':
              'Se publicaron las calificaciones del examen parcial de Cálculo.',
          'time': 'Ayer',
          'read': true,
          'icon': Icons.grading,
          'color': const Color(0xFF8B5CF6),
        },
        {
          'type': 'urgent',
          'title': 'Baja de promedio',
          'body':
              'Andrés López Mora bajó su promedio a 5.8. Se requiere atención.',
          'time': 'Ayer',
          'read': true,
          'icon': Icons.trending_down,
          'color': const Color(0xFFE74C3C),
        },
        {
          'type': 'system',
          'title': 'Nueva función disponible',
          'body':
              'Ya puedes exportar reportes de calificaciones a Excel desde el panel.',
          'time': 'Hace 2 días',
          'read': true,
          'icon': Icons.new_releases_outlined,
          'color': const Color(0xFF70C635),
        },
        {
          'type': 'academic',
          'title': 'Recordatorio de entrega',
          'body': '5 alumnos aún no entregan la tarea de Historia Universal.',
          'time': 'Hace 3 días',
          'read': true,
          'icon': Icons.timer_outlined,
          'color': const Color(0xFFF39C12),
        },
      ];

      _chatSessions = {
        // Puedes poner el nombre de algún alumno de tu lista de TeacherProvider para probar
        'Ana García Martínez': [
          {
            'text': 'Hola, noté que no entregaste la última tarea. ¿Todo bien?',
            'isMe': true,
            'time': '10:30 AM',
          },
          {
            'text':
                'Hola profe, tuve problemas con el internet. La subo hoy mismo, disculpe la demora.',
            'isMe': false,
            'time': '10:32 AM',
          },
          {
            'text':
                'No te preocupes, pero trata de entregarla antes de las 6 PM.',
            'isMe': true,
            'time': '10:33 AM',
          },
        ],
      };

      _evaluationTeam = [
        {
          'name': 'Andrea Ruiz',
          'role': 'DESARROLLO FRONTEND',
          'avatar': 'https://i.pravatar.cc/100?img=5',
          'responsibility': 85.0,
          'technical': 92.0,
          'selectedChips': ['Liderazgo'],
        },
        {
          'name': 'Carlos Sosa',
          'role': 'DISEÑO UX/UI',
          'avatar': 'https://i.pravatar.cc/100?img=11',
          'responsibility': 60.0,
          'technical': 75.0,
          'selectedChips': ['Falta de comunicación'],
        },
        {
          'name': 'Elena Méndez',
          'role': 'GESTIÓN DE PROYECTOS',
          'avatar': 'https://i.pravatar.cc/100?img=9',
          'responsibility': 100.0,
          'technical': 88.0,
          'selectedChips': ['Puntualidad'],
        },
      ];
    } catch (e) {
      _errorMessage = 'Error de conexión. Verifica tu acceso a internet.';
      debugPrint('Error en el Provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendMessage(String studentName, String text, String time) {
    if (!_chatSessions.containsKey(studentName)) {
      _chatSessions[studentName] = [];
    }
    _chatSessions[studentName]!.add({'text': text, 'isMe': true, 'time': time});
    notifyListeners();
  }

  void updateEvaluation(int index, String key, dynamic value) {
    _evaluationTeam[index][key] = value;
    notifyListeners();
  }
}
