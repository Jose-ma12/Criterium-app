import 'package:flutter/material.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:criterium/screens/rubric_builder_screen.dart';
import 'package:provider/provider.dart';
import 'package:criterium/providers/teacher_provider.dart';
import 'package:file_picker/file_picker.dart';

class NewAssignmentScreen extends StatefulWidget {
  const NewAssignmentScreen({super.key});

  @override
  State<NewAssignmentScreen> createState() => _NewAssignmentScreenState();
}

class _NewAssignmentScreenState extends State<NewAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedClass = 'Seleccionar clase...';

  List<PlatformFile> _attachedFiles = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'mp4', 'mov', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _attachedFiles.addAll(result.files);
      });
    }
  }

  IconData _getFileIcon(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'mp4':
      case 'mov':
        return Icons.video_file;
      case 'jpg':
      case 'png':
      case 'jpeg':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<TeacherProvider>();
      if (provider.availableClasses.isEmpty) {
        provider.fetchTeacherData();
      }
    });
  }

  void _showClassSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Consumer<TeacherProvider>(
          builder: (context, teacherProv, child) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            final cardColor = Theme.of(ctx).cardColor;
            final textColor = isDark ? Colors.white : AppTheme.navyBlue;

            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Selecciona una clase',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Manejo de estados de carga y datos
                  if (teacherProv.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (teacherProv.availableClasses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: Text('No hay clases disponibles')),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: teacherProv.availableClasses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (ctxList, index) {
                        final cls = teacherProv.availableClasses[index];
                        final isSelected = _selectedClass == cls['name'];
                        return ListTile(
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.navyBlue.withOpacity(0.1)
                                  : (isDark
                                        ? const Color(0xFF334155)
                                        : Colors.grey[100]),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                cls['icon']!,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          title: Text(
                            cls['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? textColor
                                  : (isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[800]),
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF2ECC71),
                                )
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedClass = cls['name']!;
                            });
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;
    final hasClass = _selectedClass != 'Seleccionar clase...';

    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        title: Text(
          'Nueva Tarea',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
        leadingWidth: 100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador de Pasos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.navyBlue,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text(
                'Detalles de la tarea',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Paso 1: Ingresa la información básica de la asignación para tus alumnos.',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 32),

              // Formulario
              _buildLabel('Título de tarea'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Ej. Ensayo sobre la fotosíntesis',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 24),

              _buildLabel('Descripción'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
                decoration: const InputDecoration(
                  hintText:
                      'Describe los objetivos y requisitos de esta tarea...',
                  hintStyle: TextStyle(color: Colors.grey),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),

              _buildLabel('Fecha de entrega'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                ),
                onTap: () async {
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppTheme.navyBlue,
                            onSurface: AppTheme.navyBlue,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      _dateController.text =
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    });
                  }
                },
              ),

              const SizedBox(height: 24),

              _buildLabel('Asignar a clase'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: hasClass
                        ? AppTheme.navyBlue.withOpacity(0.3)
                        : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: hasClass
                          ? Colors.indigo[50]
                          : (isDark
                                ? const Color(0xFF334155)
                                : Colors.grey[100]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.school,
                      color: hasClass ? AppTheme.navyBlue : Colors.grey,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    _selectedClass,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: hasClass ? AppTheme.navyBlue : Colors.grey,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () => _showClassSelector(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildLabel('Archivos adjuntos (Opcional)'),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickFiles,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey[300]!,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: AppTheme.navyBlue.withOpacity(0.6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca para adjuntar PDFs, imágenes o videos',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              if (_attachedFiles.isNotEmpty) ...[
                const SizedBox(height: 16),
                ..._attachedFiles
                    .map(
                      (file) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(
                            _getFileIcon(file.extension),
                            color: AppTheme.electricBlue,
                          ),
                          title: Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${(file.size / 1024).toStringAsFixed(1)} KB',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _attachedFiles.remove(file);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],

              const SizedBox(height: 40),

              // Botón Siguiente
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0D47A1),
                      Color(0xFF00AA88),
                    ], // Azul a Verde azulado
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00AA88).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (_selectedClass == 'Seleccionar clase...') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, selecciona una clase'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RubricBuilderScreen(
                            title: _titleController.text,
                            description: _descController.text,
                            dueDate: _dateController.text,
                            className: _selectedClass,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Siguiente: Definir rúbrica',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
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

  Widget _buildLabel(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : AppTheme.navyBlue,
      ),
    );
  }
}
