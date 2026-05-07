import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:arogyamate/controllers/department_controller.dart';
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/data/repositories/appointment_repository.dart';
import 'package:arogyamate/data/repositories/department_repository.dart';
import 'package:arogyamate/data/repositories/doctor_repository.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/data_base/models/department_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/login_info/splash_screen.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/utilities/constant/theme_provid.dart';
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

  // Open all Hive boxes once — repositories reuse these open boxes
  await DepartmentRepository.init();
  await DoctorRepository.init();
  await AppointmentRepository.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initMediaQuery(context);

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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
