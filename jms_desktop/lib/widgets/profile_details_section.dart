import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';

class ProfileDetailsSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileDetailsSectionState();
  }
}

class _ProfileDetailsSectionState extends State<ProfileDetailsSection> {
  double? _deviceWidth, _deviceHeight, _widthXheight;
  FirebaseService? _firebaseService;
  String? _fname, _lname, _regNo, _post;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //  late final List<String> notifications;
  Future<List<Map<String, dynamic>>> _getNotifications() async {
    try {
      List<Map<String, dynamic>>? providerList =
          await _firebaseService!.getLastHoursJobProvider();
      List<Map<String, dynamic>>? seekerList =
          await _firebaseService!.getLastHoursJobSeeker();

      List<Map<String, dynamic>>? list = [...?providerList, ...?seekerList];
      if (list == null) {
        return []; // Return an empty list if the result is null
      }
      // print(list);
      return list;
    } catch (e) {
      // Handle errors gracefully
      print('Error fetching notifications: $e');
      return []; // Return an empty list in case of error
    }
  }

  @override
  void initState() {
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

    return Scaffold(
      backgroundColor: backgroundColor3,
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator()); // Loading state
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error loading notifications'));
            }

            var notifications = snapshot.data ?? [];
            if (notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No notifications available.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return ListView(
              children: [
                DrawerHeader(
                  child: Text('Notifications'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ..._buildNotificationTiles(notifications),
              ],
            );
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          right: _deviceWidth! * 0.01,
          top: _deviceWidth! * 0.01,
          bottom: _deviceWidth! * 0.01,
        ),
        padding: EdgeInsets.all(_widthXheight! * 1),
        decoration: BoxDecoration(
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
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _deviceHeight! * 0.1,
                  width: _deviceWidth! * 0.001,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.notifications,
                    size: _widthXheight! * 1.5,
                  ),
                  onTap: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                ),
              ],
            ),
            // SizedBox(
            //   height: _deviceHeight! * 0.15,
            // ),
            Container(
              child: Column(
                children: [
                  _profileImage(),
                  SizedBox(
                    height: _widthXheight! * 0.5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$_fname $_lname", //TODO: add name
                        style: TextStyle(
                          fontSize: _deviceWidth! * 0.0135,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "$_regNo", //TODO: add name
                        style: TextStyle(
                          fontSize: _deviceWidth! * 0.0135,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "$_post", //TODO: add name
                        style: TextStyle(
                          fontSize: _deviceWidth! * 0.0135,
                          fontWeight: FontWeight.w600,
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

  Widget _profileImage() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight! * 0.01),
      height: _widthXheight! * 6,
      width: _widthXheight! * 6,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50000),
        child: Image.network(
          "https://avatar.iran.liara.run/public/3", //TODO: profile pic
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

  // Function to create ListTile widgets from the list of notifications
  List<Widget> _buildNotificationTiles(
      List<Map<String, dynamic>> notifications) {
    return notifications.map((notification) {
      return ListTile(
        title: Text(notification['title']),
        subtitle: Text(notification['username']),
        // onTap: () {
        //   // Handle notification tap (e.g., navigate to a different screen, mark as read, etc.)
        //   print('${notification['title']} tapped');
        // },
      );
    }).toList();
  }

  List<Map<String, String>>? convertToListOfStringMaps(
      List<Map<String, dynamic>>? dynamicList) {
    if (dynamicList == null) {
      return null; // Handle the null case if the input list is nullable
    }

    return dynamicList.map((dynamicMap) {
      Map<String, String> stringMap = {};

      dynamicMap.forEach((key, value) {
        stringMap[key] = value?.toString() ??
            'null'; // Convert value to string, handle nulls
      });

      return stringMap;
    }).toList();
  }
}
