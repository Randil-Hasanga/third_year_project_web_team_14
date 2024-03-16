import 'package:flutter/material.dart';
import 'package:jms_desktop/models/menu_model.dart';

class SideMenuData{
  final menu = <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.person, title: 'Profile'),
    MenuModel(icon: Icons.search, title: 'Job Seekers'),
    MenuModel(icon: Icons.handshake, title: 'Job Providers'),
    MenuModel(icon: Icons.settings, title: 'Settings'),
    MenuModel(icon: Icons.logout, title: 'Logout'),
  ];
}