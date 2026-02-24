import 'package:flutter/material.dart';
import 'package:criterium/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password, bool isTeacher) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simula petición de red
      await Future.delayed(const Duration(seconds: 2));

      if (isTeacher) {
        _currentUser = UserModel(
          id: 't-12345',
          name: 'Prof. Alex Rivera',
          email: email,
          role: 'teacher',
          avatar: 'https://i.pravatar.cc/150?img=11',
          institution: 'Tecnológico de Monterrey',
        );
      } else {
        _currentUser = UserModel(
          id: 's-67890',
          name: 'Ana López',
          email: email,
          role: 'student',
          avatar: 'https://i.pravatar.cc/150?img=5',
          institution: 'Tecnológico de Monterrey',
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error de conexión. Verifica tu acceso a internet.';
      debugPrint('Error en el Provider: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUser({
    required String name,
    required String bio,
    required String phone,
    String? avatar,
  }) {
    if (_currentUser != null) {
      // Creamos una copia del usuario actual pero con los datos nuevos
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: name,
        email: _currentUser!.email,
        role: _currentUser!.role,
        avatar: avatar ?? _currentUser!.avatar,
        institution: _currentUser!.institution,
        // Nota: Si UserModel no tiene campos para bio y phone, se ignorarán por ahora,
        // pero al menos el 'name' se actualizará en la UI.
      );
      notifyListeners();
    }
  }
}
