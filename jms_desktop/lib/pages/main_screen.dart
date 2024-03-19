import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/widgets/dashboard_widget.dart';
import 'package:jms_desktop/widgets/profile_details_section.dart';
import 'package:jms_desktop/widgets/side_menu_widget.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  double? _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: SizedBox(
                  child: SideMenuWidget(),
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.02),
              child: const VerticalDivider(
                width: 3,
                color: Colors.grey,
              ),
            ),
            Expanded(
              flex: 7,
              //   child: Navigator(
              //   initialRoute: '/',
              //   onGenerateRoute: (RouteSettings settings) {
              //     WidgetBuilder builder;
              //     // Manage your route names here
              //     switch (settings.name) {
              //       case '/':
              //         builder = (BuildContext _) => DashboardWidget();
              //         break;
              //       default:
              //         throw Exception('Invalid route: ${settings.name}');
              //     }
              //     return MaterialPageRoute(builder: builder, settings: settings);
              //   },
              // ),
              child: SizedBox(
                child: DashboardWidget(),
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                child: ProfileDetailsSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
