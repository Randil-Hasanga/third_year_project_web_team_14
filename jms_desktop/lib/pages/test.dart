import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jms_desktop/widgets/dashboard_widget.dart';


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
