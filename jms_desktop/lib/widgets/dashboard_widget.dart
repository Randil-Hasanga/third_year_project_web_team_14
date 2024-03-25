// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/widgets/activity_details_card.dart';
import 'package:jms_desktop/widgets/current_providers_widget.dart';
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
          height: _deviceHeight! * 0.006,
        ),
        ActivityDetailsCardWidget(),
        SizedBox(
          height: _deviceHeight! * 0.006,
        ),
        ApprovalListWidget(),
        SizedBox(
          height:_deviceHeight! * 0.03,
        ),
        CurrentProvidersListWidget(),
        
      ],
    );
  }
}
