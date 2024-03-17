import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jms_desktop/widgets/activity_details_card.dart';
import 'package:jms_desktop/widgets/pending_approvals_widget.dart';

class DashboardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<DashboardWidget> {
  double? _deviceWidth, _deviceHeight, _widthXheight;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    return Column(
      children: [
        SizedBox(
          height: _widthXheight! * 0.2,
        ),
        ActivityDetailsCardWidget(),
        SizedBox(
          height: _widthXheight! * 0.2,
        ),
        ApprovalListWidget(),
      ],
    );
  }
}
