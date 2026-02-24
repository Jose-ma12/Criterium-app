class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'teacher' o 'student'
  final String avatar;
  final String institution;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatar,
    required this.institution,
  });
}
