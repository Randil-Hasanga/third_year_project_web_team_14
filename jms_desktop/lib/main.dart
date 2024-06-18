import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/bulk_mail.dart';
import 'package:jms_desktop/pages/main_page.dart';
import 'package:jms_desktop/pages/create_officer_page.dart';
import 'package:jms_desktop/pages/edit_profile.dart';
import 'package:jms_desktop/pages/job_providers_page.dart';
import 'package:jms_desktop/pages/login_screen.dart';
import 'package:jms_desktop/pages/dashboard.dart';
import 'package:jms_desktop/pages/officers_page.dart';
import 'package:jms_desktop/pages/pending_approvals.dart';
import 'package:jms_desktop/pages/profile_page.dart';
import 'package:jms_desktop/pages/recycle_bin.dart';
import 'package:jms_desktop/pages/report_page.dart';
import 'package:jms_desktop/services/email_services.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/Search_bar_widget.dart';
import 'package:jms_desktop/widgets/buttons.dart';
import 'package:jms_desktop/widgets/richText.dart';

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

  if (kIsWeb) {
    FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  GetIt.instance.registerSingleton<FirebaseService>(
    FirebaseService(),
  );
  GetIt.instance.registerSingleton<EmailService>(
    EmailService(),
  );
  GetIt.instance.registerSingleton<RichTextWidget>(
    RichTextWidget(),
  );
  GetIt.instance.registerSingleton<SearchBarWidget>(
    SearchBarWidget(),
  );
  GetIt.instance.registerSingleton<ButtonWidgets>(
    ButtonWidgets(),
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 90, 89, 88)), // Change thumb color
          trackColor: MaterialStateProperty.all(Colors.blue),
          thumbVisibility: const MaterialStatePropertyAll(true),
          thickness: const MaterialStatePropertyAll(17), // Change track color
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor3,
        ),
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
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const Dashboard(),
        '/profile': (context) => ProfilePage(),
        '/logout': (context) => const LoginScreen(),
        '/officer': (context) => OfficersPage(),
        '/MainPage': (context) => const MainPage(),
        '/provider': (context) => const JobProviders(),
        '/bin': (context) => RecycleBin(),
        '/bulkMail': (context) => BulkMailPage(),
        '/pendingApprovals': (context) => PendingApprovals(),
        '/report': (context) => Report(),
        '/edit_profile': (context) => EditProfile()
      },
      initialRoute: '/login',
    );
  }
}
