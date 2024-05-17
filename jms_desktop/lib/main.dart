import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jms_desktop/auth/auth_guard.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/bulk_mail.dart';
import 'package:jms_desktop/pages/Main_Page.dart';
import 'package:jms_desktop/pages/create_officer_page.dart';
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
              Color.fromARGB(255, 90, 89, 88)), // Change thumb color
          trackColor: MaterialStateProperty.all(Colors.blue),
          thumbVisibility: const MaterialStatePropertyAll(true),
          thickness: MaterialStatePropertyAll(17), // Change track color
        ),
        appBarTheme: AppBarTheme(
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
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => Dashboard(),
        '/profile': (context) => ProfilePage(),
        '/logout': (context) => LoginScreen(),
        '/officer': (context) => OfficersPage(),
        '/MainPage': (context) => MainPage(),
        '/provider': (context) => JobProviders(),
        '/bin': (context) => RecycleBin(),
        '/bulkMail': (context) => BulkMailPage(),
        '/pendingApprovals': (context) => PendingApprovals(),
        '/report': (context) => Report(),
      },

      // ******************* auth guard file eke isAuthenticated = true karala inna weda krnna kalin *******************
      initialRoute: '/login',
      // onGenerateRoute: (RouteSettings settings) {
      //   switch (settings.name) {
      //     case '/':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => LoginScreen(), // Redirect to login page
      //         redirectPath: '/login',
      //       )(settings);
      //     case '/dashboard':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => Dashboard(),
      //         redirectPath: '/login',
      //       )(settings);
      //     case '/profile':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => ProfilePage(),
      //         redirectPath: '/login',
      //       )(settings);
      //     case '/officer':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => OfficersPage(),
      //         redirectPath: '/login',
      //       )(settings);
      //     case '/MainPage':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => MainPage(),
      //         redirectPath: '/login',
      //       )(settings);
      //     case '/provider':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => JobProviders(),
      //         redirectPath: '/login',
      //       )(settings);
      //     case '/bin':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => RecycleBin(),
      //         redirectPath: '/login',
      //       )(settings);
      //     case '/bulkMail':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => BulkMailPage(),
      //         redirectPath: '/login',
      //       )(settings);
      //     case '/pendingApprovals':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => PendingApprovals(),
      //         redirectPath: '/login',
      //       )(settings);
      //     case '/report':
      //       return AuthGuard.redirectUnauthorizedToLogin(
      //         builder: (_) => Report(),
      //         redirectPath: '/login',
      //       )(settings);
      //     default:
      //       return MaterialPageRoute(
      //         builder: (_) => LoginScreen(), // Redirect to login page
      //         settings: RouteSettings(name: '/login'),
      //       );
      //   }
      // },
    );
  }
}
