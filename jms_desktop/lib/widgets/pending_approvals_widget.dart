import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/widgets/listView_builder.dart';

class ApprovalListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ApprovalListWidgetState();
  }
}

class _ApprovalListWidgetState extends State<ApprovalListWidget> {
  double? _deviceWidth, _deviceHeight, _widthXheight;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
      height: _deviceHeight! * 0.27,
      decoration: BoxDecoration(
        //color: Color.fromARGB(172, 255, 255, 255),
        color: cardBackgroundColorLayer2,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: _widthXheight! * 0.7, left: _widthXheight! * 0.1),
                child: Row(
                  children: [
                    Text(
                      "Pending Approvals (Scroll with Shift key)",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: _widthXheight! * 0.7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return ListViewBuilderWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}
