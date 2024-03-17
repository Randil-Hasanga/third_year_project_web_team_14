import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jms_desktop/const/constants.dart';

class ActivityDetailsCardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActivityDetailsCardState();
  }
}

class _ActivityDetailsCardState extends State<ActivityDetailsCardWidget> {
  double? _deviceWidth, _deviceHeight, _widthXheight;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

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
                            borderRadius: BorderRadius.circular(_widthXheight! * 0.66),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          height: _deviceHeight! * 0.2,
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
                            borderRadius: BorderRadius.circular(_widthXheight! * 0.66),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          height: _deviceHeight! * 0.2,
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
                            borderRadius: BorderRadius.circular(_widthXheight! * 0.66),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          height: _deviceHeight! * 0.2,
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
}
