import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:arogyamate/controllers/department_controller.dart';
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/controllers/doctor_form_controller.dart';
import 'package:arogyamate/controllers/navigation_controller.dart';
import 'package:arogyamate/controllers/session_controller.dart';
import 'package:arogyamate/controllers/analytics_controller.dart';
import 'package:arogyamate/controllers/notification_controller.dart';
import 'package:arogyamate/data/repositories/appointment_repository.dart';
import 'package:arogyamate/data/repositories/department_repository.dart';
import 'package:arogyamate/data/repositories/doctor_repository.dart';
import 'package:arogyamate/data/repositories/notification_repository.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/data_base/models/department_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/data_base/models/notification_model.dart';
import 'package:arogyamate/screens/login_info/splash_screen.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/core/theme/app_theme.dart';
import 'package:arogyamate/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters (guard against double-registration)
  if (!Hive.isAdapterRegistered(DepartmentModelAdapter().typeId)) {
    Hive.registerAdapter(DepartmentModelAdapter());
  }
  if (!Hive.isAdapterRegistered(DoctorModelAdapter().typeId)) {
    Hive.registerAdapter(DoctorModelAdapter());
  }
  if (!Hive.isAdapterRegistered(AppointModelAdapter().typeId)) {
    Hive.registerAdapter(AppointModelAdapter());
  }
  if (!Hive.isAdapterRegistered(NotificationModelAdapter().typeId)) {
    Hive.registerAdapter(NotificationModelAdapter());
  }

  // Open all Hive boxes once — repositories reuse these open boxes
  await DepartmentRepository.init();
  await DoctorRepository.init();
  await AppointmentRepository.init();
  await NotificationRepository.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => DepartmentController()..loadAll(),
        ),
        ChangeNotifierProvider(
          create: (_) => DoctorController()..loadAll(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppointmentController()..loadAll(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationController()..loadAll(),
        ),
        ChangeNotifierProvider(create: (_) => NavigationController()),
        ChangeNotifierProvider(create: (_) => DoctorFormController()),
        ChangeNotifierProvider(create: (_) => SessionController()..loadSessionData()),
        ChangeNotifierProvider(create: (_) => AnalyticsController()..refreshStats()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: Builder(
              builder: (context) {
                initMediaQuery(context);
                return const SplashScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
