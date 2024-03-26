// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/test.dart';

class DashboardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<DashboardWidget> {
  double? _deviceWidth, _deviceHeight, _widthXheight;
  ScrollController _scrollControllerRight = ScrollController();
  ScrollController _scrollControllerLeft = ScrollController();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    return Column(
      children: [
        
        ActivityDetailsCardWidget(),
        SizedBox(
          height: _deviceHeight! * 0.006,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: CurrentProvidersListWidget(),
              ),
              Expanded(
                flex: 1,
                child: ApprovalListWidget(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget ApprovalListWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: _deviceWidth! * 0.01,
        bottom: _deviceHeight! * 0.02,
        right: _deviceWidth! * 0.01,
      ),
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
      // /height: _deviceHeight! * 0.27,
      decoration: BoxDecoration(
        //color: Color.fromARGB(172, 255, 255, 255),
        color: cardBackgroundColorLayer2,
        borderRadius: BorderRadius.circular(_widthXheight! * 1),
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
                      "Pending Approvals",
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
            child: Scrollbar(
              controller: _scrollControllerRight,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollControllerRight,
                shrinkWrap: true,
                itemCount: 10,
                scrollDirection: Axis.vertical,
                //always show scroll bar
                itemBuilder: (context, index) {
                  return PendingListViewBuilderWidget();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget PendingListViewBuilderWidget() {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
        //bottom: _widthXheight! * 1,
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
          height: _deviceHeight! * 0.08,
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
                horizontal: _deviceWidth! * 0.001,
                vertical: _deviceHeight! * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: _deviceWidth! * 0.01,
                ),
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

  Widget ActivityDetailsCardWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.all(_deviceWidth! * 0.01),
            decoration: BoxDecoration(
              //color: Color.fromARGB(172, 255, 255, 255),
              color: cardBackgroundColorLayer2,
              borderRadius: BorderRadius.circular(_widthXheight! * 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            //color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(_widthXheight! * 0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: _widthXheight! * 0.7,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: _deviceWidth! * 0.02,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _deviceHeight! * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cardBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(_widthXheight! * 0.66),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          height: _deviceHeight! * 0.25,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceWidth! * 0.01,
                                vertical: _deviceHeight! * 0.015),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Seekers ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _widthXheight! * 0.6,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // TODO: get data from DB
                                      "20",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: _widthXheight! * 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _deviceWidth! * 0.0125,
                      ),
                      Expanded(
                        flex: 1,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cardBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(_widthXheight! * 0.66),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          height: _deviceHeight! * 0.25,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceWidth! * 0.01,
                                vertical: _deviceHeight! * 0.015),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Providers ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _widthXheight! * 0.6,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      // TODO: get data from DB
                                      "20",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: _widthXheight! * 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(right: _deviceWidth! * 0.01),
            decoration: BoxDecoration(
              //color: Color.fromARGB(172, 255, 255, 255),
              color: cardBackgroundColorLayer2,
              borderRadius: BorderRadius.circular(_widthXheight! * 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            //color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(_widthXheight! * 0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Pending",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: _widthXheight! * 0.7,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: _deviceWidth! * 0.02,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _deviceHeight! * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cardBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(_widthXheight! * 0.66),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          height: _deviceHeight! * 0.25,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceWidth! * 0.01,
                                vertical: _deviceHeight! * 0.015),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Providers ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _widthXheight! * 0.6,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // TODO: get data from DB
                                      "20",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: _widthXheight! * 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget CurrentProvidersListWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: _deviceWidth! * 0.01, bottom: _deviceHeight! * 0.02),
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
      // height: _deviceHeight! * 0.27,
      decoration: BoxDecoration(
        //color: Color.fromARGB(172, 255, 255, 255),
        color: cardBackgroundColorLayer2,
        borderRadius: BorderRadius.circular(_widthXheight! * 1),
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
                      "Current Job Providers",
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
            child: Scrollbar(
              controller: _scrollControllerLeft,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollControllerLeft,
                shrinkWrap: true,
                itemCount: 10,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return CurrentListViewBuilderWidget();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CurrentListViewBuilderWidget() {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
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
          height: _deviceHeight! * 0.08,
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
                horizontal: _deviceWidth! * 0.001,
                vertical: _deviceHeight! * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: _deviceWidth! * 0.01,
                ),
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
