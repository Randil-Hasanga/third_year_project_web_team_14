import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/auth/auth_guard.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/BulkMailPages/bulk_mail.dart';
import 'package:jms_desktop/pages/dashboard.dart';
import 'package:jms_desktop/pages/job_providers_page.dart';
import 'package:jms_desktop/pages/login_screen.dart';
import 'package:jms_desktop/pages/officers_page.dart';
import 'package:jms_desktop/pages/pending_approvals.dart';
import 'package:jms_desktop/pages/profile_page.dart';
import 'package:jms_desktop/pages/recycle_bin.dart';
import 'package:jms_desktop/services/firebase_services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 0;
  double? _deviceHeight;

  FirebaseService? _firebaseService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  final List<Widget> _pages = [
    const Dashboard(),
    ProfilePage(),
    OfficersPage(),
    JobProviders(),
    PendingApprovals(),
    BulkMailPage(),
    RecycleBin(),
    LoginScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    return AuthGuard.isAuthenticated
        ? Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  extended: true,
                  labelType: NavigationRailLabelType.none,
                  leading: SizedBox(
                    height: _deviceHeight! * 0.1,
                  ),
                  minWidth: 100,
                  onDestinationSelected: (int index) {
                    if (index == (_pages.length - 1)) {
                      _logout();
                    } else {
                      setState(() {
                        _currentPage = index;
                      });
                    }
                  },
                  indicatorColor: selectionColor,
                  destinations: const [
                    NavigationRailDestination(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      icon: Icon(Icons.dashboard),
                      label: Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      icon: Icon(Icons.account_box),
                      label: Text(
                        'Profile',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      icon: Icon(Icons.work),
                      label: Text(
                        'Officers',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      icon: Icon(Icons.handshake),
                      label: Text(
                        'Current\nJob Providers',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      icon: Icon(Icons.lock_clock),
                      label: Text(
                        'Pending\nJob Providers',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      icon: Icon(Icons.email),
                      label: Text(
                        'Bulk Mail',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      icon: Icon(Icons.recycling_rounded),
                      label: Text(
                        'Recycle Bin',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      icon: Icon(Icons.logout),
                      label: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                  selectedIndex: _currentPage,
                ),
                Expanded(child: _pages[_currentPage]),
              ],
            ),
          )
        : const LoginScreen(); // Redirect to login page if not authenticated
  }

  Future<void> _logout() async {
    try {
      _firebaseService!.logout();
      AuthGuard.isAuthenticated = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
