import 'package:flutter/material.dart';
import 'package:criterium/screens/splash_screen.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:criterium/providers/auth_provider.dart';
import 'package:criterium/providers/teacher_provider.dart';
import 'package:criterium/providers/student_provider.dart';
import 'package:criterium/providers/dashboard_provider.dart';
import 'package:criterium/providers/app_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Global notifier controlado desde el Switch de perfil.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Leer preferencia guardada
  final prefs = await SharedPreferences.getInstance();
  final isDarkSaved = prefs.getBool('isDarkMode') ?? false;
  themeNotifier.value = isDarkSaved ? ThemeMode.dark : ThemeMode.light;

  // Guardar cada vez que el usuario cambia el tema
  themeNotifier.addListener(() {
    prefs.setBool('isDarkMode', themeNotifier.value == ThemeMode.dark);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, mode, __) {
          return MaterialApp(
            title: 'Criterium',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
