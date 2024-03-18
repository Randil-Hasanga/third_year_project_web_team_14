// import 'package:flutter/material.dart';
// import 'package:jms_desktop/const/constants.dart';
// import 'package:jms_desktop/data/side_menu_data.dart';
// import 'package:jms_desktop/pages/main_screen.dart';
// import 'package:jms_desktop/pages/test.dart';
// import 'package:jms_desktop/services/sidemenu_provider.dart';
// import 'package:provider/provider.dart';

// class SideMenuWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _SideMenuWidgetState();
//   }
// }

// class _SideMenuWidgetState extends State<SideMenuWidget> {
//   double? _deviceWidth, _deviceHeight;
//   //int seletedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<SideMenuProvider>(context);
//     _deviceHeight = MediaQuery.of(context).size.height;
//     _deviceWidth = MediaQuery.of(context).size.width;

//     final SideMenuData data = SideMenuData();
//     return Container(
//       constraints: BoxConstraints(
//         minWidth: 200,
//       ),
//       color: Color(0xFF21222D),
//       padding: EdgeInsets.symmetric(
//           vertical: _deviceHeight! * 0.1, horizontal: _deviceWidth! * 0.02),
//       child: ListView.builder(
//         itemCount: data.menu.length,
//         itemBuilder: (context, index) => buildMenuEntry(data, index),
//       ),
//     );
//   }

//   Widget buildMenuEntry(SideMenuData data, int index) {
//     final selectedIndex = Provider.of<SideMenuProvider>(context).selectedIndex;
//     final isSelected = selectedIndex == index;
//     return Column(
//       children: [
//         // SizedBox(height: _deviceHeight! * 0.02,),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           decoration: BoxDecoration(
//             color: isSelected ? selectionColor : Colors.transparent,
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: InkWell(
//             onTap: () {
//               Provider.of<SideMenuProvider>(context, listen: false)
//                   .setSelectedIndex(index);
//               Navigator.of(context).push(PageRouteBuilder(
//                 pageBuilder: (context, animation, secondaryAnimation) =>
//                     _getRouteWidget(data.menu[index].routeName),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   var begin = Offset(1.0, 0.0);
//                   var end = Offset.zero;
//                   var curve = Curves.ease;

//                   var tween = Tween(begin: begin, end: end)
//                       .chain(CurveTween(curve: curve));

//                   return SlideTransition(
//                     position: animation.drive(tween),
//                     child: child,
//                   );
//                 },
//               ));
//             },
//             child: Row(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: _deviceWidth! * 0.01,
//                       vertical: _deviceHeight! * 0.015),
//                   child: Icon(
//                     data.menu[index].icon,
//                     color: isSelected ? Colors.black : selectionColor,
//                     size: _deviceWidth! * 0.015,
//                   ),
//                 ),
//                 Text(
//                   data.menu[index].title,
//                   style: TextStyle(
//                     fontSize: _deviceWidth! * 0.013,
//                     color: isSelected ? Colors.black : selectionColor,
//                     fontWeight:
//                         isSelected ? FontWeight.w600 : FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _getRouteWidget(String routeName) {
//     return FutureBuilder<Widget>(
//       future: _loadPage(routeName),
//       builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           return snapshot.data!;
//         }
//       },
//     );
//   }

//   Future<Widget> _loadPage(String routeName) async {
//     // Simulate a delay
//     await Future.delayed(Duration(seconds: 2));

//     switch (routeName) {
//       case '/dashboard':
//         return MainScreen();
//       case '/profile':
//         return TestPage(
//           companyName: "abc",
//         );
//       // Add more cases for all your routes
//     }
//     throw Exception('Invalid route: $routeName');
//   }
// }

import 'package:flutter/material.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/data/side_menu_data.dart';
import 'package:jms_desktop/pages/main_screen.dart';
import 'package:jms_desktop/pages/test.dart';
import 'package:jms_desktop/services/sidemenu_provider.dart';
import 'package:provider/provider.dart';

class SideMenuWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SideMenuWidgetState();
  }
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  double? _deviceWidth, _deviceHeight;
  //int seletedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SideMenuProvider>(context);
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    final SideMenuData data = SideMenuData();
    return Container(
      constraints: BoxConstraints(
        minWidth: 200,
      ),
      color: Color(0xFF21222D),
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
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    _getRouteWidget(data.menu[index].routeName),
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
          return _buildPageWithLoader(); // Show loader
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Widget _buildPageWithLoader() {
    return Stack(
      children: [
        // Your page content goes here
        MainScreen(), // Placeholder, replace with your actual content widget
        // Circular progress indicator overlay
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Future<Widget> _loadPage(String routeName) async {
    // Simulate a delay
    await Future.delayed(Duration(seconds: 2));

    switch (routeName) {
      case '/dashboard':
        return MainScreen();
      case '/profile':
        return TestPage(
          companyName: "abc",
        );
      // Add more cases for all your routes
    }
    throw Exception('Invalid route: $routeName');
  }
}

