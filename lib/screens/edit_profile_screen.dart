import 'package:flutter/material.dart';
import 'package:criterium/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentBio;
  final String currentPhone;
  final String email;
  final String role;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentBio,
    required this.currentPhone,
    required this.email,
    required this.role,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _bioController = TextEditingController(text: widget.currentBio);
    _phoneController = TextEditingController(text: widget.currentPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, {
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'phone': _phoneController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            color: AppTheme.navyBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: AppTheme.navyBlue,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leadingWidth: 90,
        actions: [
          TextButton(
            onPressed: _save,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.navyBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Avatar con icono de cámara ──
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Cambiar foto próximamente'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=5',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.navyBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Campos del formulario ──
              _buildField(
                label: 'Nombre completo',
                controller: _nameController,
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildField(
                label: 'Teléfono',
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              _buildField(
                label: 'Acerca de mí',
                controller: _bioController,
                icon: Icons.info_outline,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // ── Campos deshabilitados (institucionales) ──
              _buildDisabledField(
                label: 'Correo institucional',
                value: widget.email,
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),

              _buildDisabledField(
                label: 'Rol',
                value: widget.role,
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 40),

              // ── Botón guardar grande ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navyBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Guardar cambios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Campo editable ──
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.navyBlue.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.navyBlue,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: AppTheme.navyBlue.withOpacity(0.5),
              size: 20,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppTheme.electricBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  // ── Campo deshabilitado ──
  Widget _buildDisabledField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.navyBlue.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.lock_outline, size: 14, color: Colors.grey[400]),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[400], size: 20),
              const SizedBox(width: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
