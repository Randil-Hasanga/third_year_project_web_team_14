import 'package:flutter/material.dart';
import 'package:jms_desktop/widgets/dashboard_widget.dart';
import 'package:jms_desktop/widgets/profile_details_section.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  // ignore: unused_field
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
