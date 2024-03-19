import 'package:flutter/material.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/data/side_menu_data.dart';
import 'package:jms_desktop/pages/main_screen.dart';
import 'package:jms_desktop/pages/profile_page.dart';
import 'package:jms_desktop/pages/test.dart';
import 'package:jms_desktop/services/sidemenu_provider.dart';
import 'package:jms_desktop/widgets/dashboard_widget.dart';
import 'package:provider/provider.dart';

class SideMenuWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SideMenuWidgetState();
  }
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  double? _deviceWidth, _deviceHeight;
  late int _currentPageIndex;
  String? currentPageRoute;

  //int seletedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final SideMenuData data = SideMenuData();
    final provider = Provider.of<SideMenuProvider>(context);
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _currentPageIndex = Provider.of<SideMenuProvider>(context).selectedIndex;
    currentPageRoute = data.menu[_currentPageIndex].routeName;

    print(currentPageRoute);

    return Container(
      constraints: BoxConstraints(
        minWidth: 200,
      ),
      color: backgroundColor2,
      padding: EdgeInsets.symmetric(
          vertical: _deviceHeight! * 0.1, horizontal: _deviceWidth! * 0.02),
      child: ListView.builder(
        itemCount: data.menu.length,
        itemBuilder: (context, index) => buildMenuEntry(data, index),
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final selectedIndex = Provider.of<SideMenuProvider>(context).selectedIndex;
    final isSelected = selectedIndex == index;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? selectionColor : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: InkWell(
            onTap: () {
              Provider.of<SideMenuProvider>(context, listen: false)
                  .setSelectedIndex(index);
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    _getRouteWidget(
                        data.menu[index].routeName),
              ));
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _deviceWidth! * 0.01,
                      vertical: _deviceHeight! * 0.015),
                  child: Icon(
                    data.menu[index].icon,
                    color: isSelected ? Colors.black : selectionColor,
                    size: _deviceWidth! * 0.015,
                  ),
                ),
                Text(
                  data.menu[index].title,
                  style: TextStyle(
                    fontSize: _deviceWidth! * 0.013,
                    color: isSelected ? Colors.black : selectionColor,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getRouteWidget(String routeName) {
    return FutureBuilder<Widget>(
      future: _loadPage(routeName),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPageWithLoader(
              routeName); // Show loader
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Widget _buildPageWithLoader(String routeName) {
    return FutureBuilder<Widget>(
      future: _loadPage(routeName),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If data is still loading, show the loading indicator

          return Stack(
            children: [
              if(currentPageRoute == "/dashboard")...{
                MainScreen(),
              }else if(currentPageRoute == "/profile")...{
                ProfilePage(),
              }
              ,
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          // If there's an error, show an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // Otherwise, return the loaded page widget
          return snapshot.data!;
        }
      },
    );
  }

  Future<Widget> _loadPage(String routeName) async {
    // Simulate a delay
    await Future.delayed(Duration(seconds: 2));

    switch (routeName) {
      case '/dashboard':
        return MainScreen();
      case '/profile':
        return ProfilePage();
      // Add more cases for all your routes
    }
    throw Exception('Invalid route: $routeName');
  }
}
