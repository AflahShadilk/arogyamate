import 'package:arogyamate/utilities/constant/theme_provid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:arogyamate/data_base/functions/db_appoinment.dart';
import 'package:arogyamate/data_base/functions/db_doctorfuctions.dart';
import 'package:arogyamate/data_base/functions/db_functions.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/data_base/models/department_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/login_info/splash_screen.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';


const saveKey = 'UserLoggedIn';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(DepartmentModelAdapter().typeId)) {
    Hive.registerAdapter(DepartmentModelAdapter());
  }
  await getAllDepartment();

  if (!Hive.isAdapterRegistered(DoctorModelAdapter().typeId)) {
    Hive.registerAdapter(DoctorModelAdapter());
  }
  await getAllDoctors();

  if (!Hive.isAdapterRegistered(AppointModelAdapter().typeId)) {
    Hive.registerAdapter(AppointModelAdapter());
  }
  await getAllAppoinments();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initMediaQuery(context);
    final themeProvider = Provider.of<ThemeProvider>(context); 

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, 
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
