import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jms_desktop/widgets/activity_details_card.dart';

class DashboardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 18,
        ),
        ActivityDetailsCardWidget(),
      ],
    );
  }
}
