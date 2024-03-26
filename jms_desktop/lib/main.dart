import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/Main_Page.dart';
import 'package:jms_desktop/pages/login_screen.dart';
import 'package:jms_desktop/pages/dashboard.dart';
import 'package:jms_desktop/pages/officers_page.dart';
import 'package:jms_desktop/pages/profile_page.dart';
import 'package:jms_desktop/services/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBX-f2VAYW6NZOS-1Ra4PvsjYbnA4Xzvcg",
      projectId: "jobcenter-app-74ca3",
      messagingSenderId: "352414474958",
      storageBucket: "jobcenter-app-74ca3.appspot.com",
      appId: "1:352414474958:web:9aaf2f85d78b4e4a71669f",
    ),
  );
  GetIt.instance.registerSingleton<FirebaseService>(
    FirebaseService(),
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: backgroundColor2,
          unselectedIconTheme: IconThemeData(
            color: selectionColor,
          ),
        ),
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routes: {
        '/Login': (context) => LoginScreen(),
        '/dashboard': (context) => Dashboard(),
        '/profile': (context) => ProfilePage(),
        // '/job_seekers': (context) => JobSeekersScreen(),
        // '/job_providers_page': (context) => JobProvidersScreen(),
        // '/settings': (context) => SettingsScreen(),
        '/logout': (context) => LoginScreen(),
        '/officer': (context) => OfficersPage(),
        '/MainPage': (context) => MainPage(),
      },
      initialRoute: '/Login',
    );
  }
}
