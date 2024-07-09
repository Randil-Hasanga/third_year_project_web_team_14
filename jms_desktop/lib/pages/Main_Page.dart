import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/pages/job_seeker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/bulk_mail.dart';
import 'package:jms_desktop/pages/dashboard.dart';
import 'package:jms_desktop/pages/job_providers_page.dart';

import 'package:jms_desktop/pages/login_screen.dart';
import 'package:jms_desktop/pages/officers_page.dart';
import 'package:jms_desktop/pages/pending_approvals.dart';
import 'package:jms_desktop/pages/profile_page.dart';
import 'package:jms_desktop/pages/recycle_bin.dart';
import 'package:jms_desktop/pages/report_page.dart';
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
  double? _deviceHeight, _deviceWidth;
  FirebaseService? _firebaseService;
  final PageController _pageController = PageController();
  String? _email, _password;
  double? _fontSize, _verticalSpace, _widthXheight;
  bool isExtended = true;
  WidgetBuilder? builder;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    if (_firebaseService!.currentUser == null) {
      initSharedPrefs();
    }
  }

  Future<void> initSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await _firebaseService!.auth.signOut();

    setState(() {
      _email = prefs.getString('email');
      _password = prefs.getString('password');
    });

    if (_email != null && _password != null) {
      loginUser2(_email!, _password!);
    } else {
      Navigator.popAndPushNamed(context, '/login');
    }
  }

  void loginUser2(String email, String password) async {
    bool _result =
        await _firebaseService!.loginUser(email: email, password: password);

    if (_result) {
      if (_firebaseService!.currentUser!['type'] == 'officer') {
        Navigator.popAndPushNamed(context, '/MainPage');
      }
    }
  }

  final List<Widget> _pages = [
    const Dashboard(),
    ProfilePage(),
    OfficersPage(),
    const JobProviders(),
    PendingApprovals(),
    const JobSeeker(),
    BulkMailPage(),
    RecycleBin(),
    Report(),
  ];

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = (_deviceHeight! * _deviceWidth!) / 50000;
    _fontSize = _deviceWidth! * 0.01;
    _verticalSpace = _deviceHeight! * 0.015;

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          NavigationRail(
            extended: isExtended,
            minExtendedWidth: _deviceWidth! * 0.15,
            labelType: NavigationRailLabelType.none,
            leading: IconButton(
              onPressed: () {
                setState(() {
                  isExtended = !isExtended;
                });
              },
              icon: extendedIcon(),
            ),
            onDestinationSelected: (int index) {
              if (index == (_pages.length)) {
                _logout();
              } else {
                setState(() {
                  _currentPage = index;
                });
                _pageController.jumpToPage(index);
              }
            },
            indicatorColor: selectionColor,
            destinations: [
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: _verticalSpace!),
                icon: Icon(
                  Icons.dashboard,
                  size: _deviceWidth! * 0.013,
                ),
                label: Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: _verticalSpace!),
                icon: Icon(
                  Icons.account_box,
                  size: _deviceWidth! * 0.013,
                ),
                label: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: _verticalSpace!),
                icon: Icon(
                  Icons.work,
                  size: _deviceWidth! * 0.013,
                ),
                label: Text(
                  'Officers',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: _verticalSpace!),
                icon: Icon(
                  Icons.handshake,
                  size: _deviceWidth! * 0.013,
                ),
                label: Text(
                  'Current\nJob Providers',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: _verticalSpace!),
                icon: Icon(
                  Icons.lock_clock,
                  size: _deviceWidth! * 0.013,
                ),
                label: Text(
                  'Pending\nJob Providers',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: _verticalSpace!),
                icon: Icon(Icons.person_search),
                label: Text(
                  'Job Seekers',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: _verticalSpace!),
                icon: Icon(
                  Icons.email,
                  size: _deviceWidth! * 0.013,
                ),
                label: Text(
                  'Bulk Mail',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: _verticalSpace!),
                icon: Icon(
                  Icons.recycling_rounded,
                  size: _deviceWidth! * 0.013,
                ),
                label: Text(
                  'Recycle Bin',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: _verticalSpace!),
                icon: Icon(
                  Icons.report,
                  size: _deviceWidth! * 0.013,
                ),
                label: Text(
                  'Report',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.logout,
                  size: _deviceWidth! * 0.013,
                ),
                label: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white, fontSize: _fontSize),
                ),
              ),
            ],
            selectedIndex: _currentPage,
          ),
          Expanded(
            child: Navigator(
              key: GlobalKey<NavigatorState>(),
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/':
                    builder = (BuildContext context) => _pages[_currentPage];
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute(builder: builder!, settings: settings);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget extendedIcon() {
    if (isExtended) {
      return const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      );
    } else {
      return const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      );
    }
  }

  Future<void> _logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('password');
      _firebaseService!.logout();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
