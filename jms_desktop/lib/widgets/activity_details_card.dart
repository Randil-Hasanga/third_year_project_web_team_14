import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActivityDetailsCardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActivityDetailsCardState();
  }
}

class _ActivityDetailsCardState extends State<ActivityDetailsCardWidget> {
  double? _deviceWidth, _deviceHeight, _fontSize;
  

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _fontSize = _deviceHeight! * _deviceWidth! / 50000;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Total",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _deviceWidth! * 0.02,
                  ),
                ),
              ),
              SizedBox(
                width: _deviceWidth! * 0.02,
              ),
              Expanded(
                child: Text(
                  "Pending",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _deviceWidth! * 0.02,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
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
                    color: Color.fromARGB(55, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  height: _deviceHeight! * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Job Seekers ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _fontSize! * 1,
                            ),
                          ),
                          Text(
                            // TODO: get data from DB
                            "20",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _fontSize! * 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 1,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(55, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  height: _deviceHeight! * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon(Icons.search,
                      //     size: _deviceWidth! * 0.03, color: Colors.white),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Job Providers ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _fontSize! * 1,
                            ),
                          ),
                          Text(
                            // TODO: get data from DB
                            "20",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _fontSize! * 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 1,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(55, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  height: _deviceHeight! * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon(Icons.search,
                      //     size: _deviceWidth! * 0.03, color: Colors.white),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Job Providers ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _fontSize! * 1,
                            ),
                          ),
                          Text(
                            // TODO: get data from DB
                            "20",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _fontSize! * 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
