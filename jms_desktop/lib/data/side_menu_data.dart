import 'package:flutter/material.dart';

class SideMenuData {
  final List<SideMenuItem> menu = [
    SideMenuItem(
      icon: Icons.home,
      title: 'Dashboard',
      routeName: '/dashboard',
    ),
    SideMenuItem(
      icon: Icons.person,
      title: 'Profile',
      routeName: '/profile',
    ),
    SideMenuItem(
      icon: Icons.handshake,
      title: 'Job Providers',
      routeName: '/job_providers_page',
    ),
    SideMenuItem(
      icon: Icons.search,
      title: 'Job Seekers',
      routeName: '/job_seekers_page',
    ),
    SideMenuItem(
      icon: Icons.work,
      title: 'Officers',
      routeName: '/officers_page',
    ),
    SideMenuItem(
      icon: Icons.settings,
      title: 'Settings',
      routeName: '/settings_page',
    ),
    SideMenuItem(
      icon: Icons.logout,
      title: 'Logout',
      routeName: '/logout_page',
    ),
  ];
}

class SideMenuItem {
  final IconData icon;
  final String title;
  final String routeName;

  SideMenuItem(
      {required this.icon, required this.title, required this.routeName});
}
