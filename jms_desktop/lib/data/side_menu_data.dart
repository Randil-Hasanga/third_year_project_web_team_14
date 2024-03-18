import 'package:flutter/material.dart';

class SideMenuData {
  final List<SideMenuItem> menu = [
    SideMenuItem(icon: Icons.home, title: 'Dashboard', routeName: '/dashboard'),
    SideMenuItem(icon: Icons.person, title: 'Profile', routeName: '/profile'),
    SideMenuItem(icon: Icons.search, title: 'Job Seekers', routeName: '/job_seekers'),
    SideMenuItem(icon: Icons.handshake, title: 'Job Providers', routeName: '/job_providers'),
    SideMenuItem(icon: Icons.settings, title: 'Settings', routeName: '/settings'),
    SideMenuItem(icon: Icons.logout, title: 'Logout', routeName: '/logout'),
  ];
}

class SideMenuItem {
  final IconData icon;
  final String title;
  final String routeName;

  SideMenuItem({required this.icon, required this.title, required this.routeName});
}
