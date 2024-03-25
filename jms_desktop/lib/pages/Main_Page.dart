import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/dashboard.dart';
import 'package:jms_desktop/pages/officers_page.dart';
import 'package:jms_desktop/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 0;
  double? _deviceWidth, _deviceHeight, _widthXheight;

  final List<Widget> _pages = [
    Dashboard(),
    ProfilePage(),
    OfficersPage(),
  ];
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceWidth! * _deviceHeight! / 50000;
    return Scaffold(
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
              setState(() {
                _currentPage = index;
              });
            },
            indicatorColor: selectionColor,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_box),
                label: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.work),
                label: Text(
                  'Officers',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
            selectedIndex: _currentPage,
          ),
          Expanded(child: _pages[_currentPage]),
        ],
      ), // show page
    );
  }
}
