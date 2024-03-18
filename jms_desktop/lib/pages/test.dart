import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jms_desktop/widgets/dashboard_widget.dart';
import 'package:jms_desktop/widgets/side_menu_widget.dart';

class TestPage extends StatelessWidget {
  String companyName;

  TestPage({required this.companyName});
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
              child: DashboardWidget(),
            ),
            Expanded(
              flex: 3,
              child: Container(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
