import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/dashboard_widget.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  double? _deviceWidth, _deviceHeight, _widthXheight;
  FirebaseService? _firebaseService;
  String? _fname, _lname, _regNo, _post, _email, _contactNo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    _fname = _firebaseService!.currentUser!['fname'];
    _lname = _firebaseService!.currentUser!['lname'];
    _regNo = _firebaseService!.currentUser!['reg_no'];
    _post = _firebaseService!.currentUser!['position'];
    _email = _firebaseService!.currentUser!['email'];
    _contactNo = _firebaseService!.currentUser!['contact'];

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _profileImage(),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _profileDetails(),
                  SizedBox(
                    height: _deviceHeight! * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: _deviceHeight! * 0.04),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor2,
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceWidth! * 0.02,
                                vertical: _deviceHeight! * 0.01),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: _deviceWidth! * 0.014,
                              color: selectionColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileDetails() {
    return Container(
      padding: EdgeInsets.all(_widthXheight! * 1),
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
      margin: EdgeInsets.only(right: _deviceHeight! * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name : ",
                style: TextStyle(
                  fontSize: _deviceWidth! * 0.014,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: _widthXheight! * 4,
                  ),
                  Text(
                    "$_fname $_lname", //TODO: add name
                    style: TextStyle(
                      fontSize: _deviceWidth! * 0.014,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          Container(
            color: Colors.grey,
            height: 1,
          ),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reg No : ",
                style: TextStyle(
                  fontSize: _deviceWidth! * 0.014,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: _widthXheight! * 4,
                  ),
                  Text(
                    "$_regNo", //TODO: add reg no
                    style: TextStyle(
                      fontSize: _deviceWidth! * 0.014,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          Container(
            color: Colors.grey,
            height: 1,
          ),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Position : ",
                style: TextStyle(
                  fontSize: _deviceWidth! * 0.014,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: _widthXheight! * 4,
                  ),
                  Text(
                    "$_post", //TODO: add position
                    style: TextStyle(
                      fontSize: _deviceWidth! * 0.014,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          Container(
            color: Colors.grey,
            height: 1,
          ),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contact No : ",
                style: TextStyle(
                  fontSize: _deviceWidth! * 0.014,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: _widthXheight! * 4,
                  ),
                  Text(
                    "$_contactNo", //TODO: add contact no
                    style: TextStyle(
                      fontSize: _deviceWidth! * 0.014,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          Container(
            color: Colors.grey,
            height: 1,
          ),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "E-Mail : ",
                style: TextStyle(
                  fontSize: _deviceWidth! * 0.014,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: _widthXheight! * 4,
                  ),
                  Text(
                    "$_email", //TODO: add gmail
                    style: TextStyle(
                      fontSize: _deviceWidth! * 0.014,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileImage() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight! * 0.02),
      height: _widthXheight! * 10,
      width: _widthXheight! * 10,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: Image.network(
          "https://i.pravatar.cc/150?img=3", //TODO: profile pic
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(Icons.error);
          },
        ),
      ),
    );
  }
}
