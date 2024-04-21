import 'package:flutter/material.dart';
import 'package:jms_desktop/pages/login_screen.dart';

class AuthGuard {
  static bool isAuthenticated = false;

  static RouteFactory redirectUnauthorizedToLogin({
    required Widget Function(BuildContext) builder,
    required String redirectPath,
  }) {
    return (RouteSettings settings) {
      if (isAuthenticated) {
        return MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
      } else {
        return MaterialPageRoute(
          builder: (context) => LoginScreen(), // Redirect to login page
          settings: RouteSettings(name: redirectPath),
        );
      }
    };
  }
}