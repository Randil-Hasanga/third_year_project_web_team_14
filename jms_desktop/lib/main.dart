import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/login_screen.dart';
import 'package:jms_desktop/pages/main_screen.dart';
import 'package:jms_desktop/pages/profile_page.dart';
import 'package:jms_desktop/services/sidemenu_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SideMenuProvider(),
      child: const MyApp(),
    ),
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
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routes: {
        '/dashboard': (context) => MainScreen(),
        '/profile': (context) => ProfilePage(),
        // '/job_seekers': (context) => JobSeekersScreen(),
        // '/job_providers_page': (context) => JobProvidersScreen(),
        // '/settings': (context) => SettingsScreen(),
        '/logout': (context) => LoginScreen(),
      },
      initialRoute: '/dashboard',
    );
  }
}
