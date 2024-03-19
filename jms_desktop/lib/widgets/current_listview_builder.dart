import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/test.dart';

class CurrentListViewBuilderWidget extends StatelessWidget {
  double? _deviceWidth, _deviceHeight, _widthXheight;
  TestPage? testPage;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _widthXheight! * 0.5,
        bottom: _widthXheight! * 1,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestPage(
                companyName: "XYZ",
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: Duration(microseconds: 300),
          height: _deviceHeight! * 0.2,
          width: _deviceWidth! * 0.175,
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(_widthXheight! * 0.66),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth! * 0.01,
                vertical: _deviceHeight! * 0.015),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.developer_mode,
                  size: _widthXheight! * 1,
                ),
                Text("Company Name")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
