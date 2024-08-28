import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:intl/intl.dart';

class ProfileDetailsSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileDetailsSectionState();
  }
}

class _ProfileDetailsSectionState extends State<ProfileDetailsSection> {
  FirebaseService? _firebaseService;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double? _deviceWidth = null;
  double? _deviceHeight = null;
  double? _widthXheight = null;
  String? _fname = null;
  String? _lname = null;
  String? _regNo = null;
  String? _post = null;
  String? _imageLink;

  Future<List<Map<String, dynamic>>?> _getNotifications() async {
    try {
      List<Map<String, dynamic>>? providerList =
          await _firebaseService!.getLastHoursJobProvider() ?? [];
      List<Map<String, dynamic>>? seekerList =
          await _firebaseService!.getLastHoursJobSeeker() ?? [];
      List<Map<String, dynamic>>? vacancyList =
          await _firebaseService!.getLastHoursVacancy() ?? [];
      List<Map<String, dynamic>>? companyList =
          await _firebaseService!.getLastHoursNewCompany() ?? [];

      // Combine all notifications into a single list
      List<Map<String, dynamic>> allNotifications = [];
      allNotifications.addAll(providerList);
      allNotifications.addAll(seekerList);
      allNotifications.addAll(vacancyList);
      allNotifications.addAll(companyList);

      // Sort allNotifications by 'registered_date' in descending order
      allNotifications.sort((a, b) {
        DateTime dateA = a['registered_date'] is Timestamp
            ? (a['registered_date'] as Timestamp).toDate()
            : DateTime.parse(a['registered_date']);
        DateTime dateB = b['registered_date'] is Timestamp
            ? (b['registered_date'] as Timestamp).toDate()
            : DateTime.parse(b['registered_date']);
        return dateB.compareTo(dateA);
      });
      if (allNotifications.isNotEmpty) {
        return allNotifications;
      } else {
        print("Empty");
        return null;
      }
    } catch (e) {
      print("Error getting notifications: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  Future<void> loadData() async {
    if (mounted) {
      setState(() {
        _deviceHeight = MediaQuery.of(context).size.height;
        _deviceWidth = MediaQuery.of(context).size.width;
        _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
        _fname = _firebaseService!.currentUser!['fname'];
        _lname = _firebaseService!.currentUser!['lname'];
        _regNo = _firebaseService!.currentUser!['reg_no'];
        _post = _firebaseService!.currentUser!['position'];
        _imageLink = _firebaseService!.currentUser!['profile_image'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor3,
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: _getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading notifications'));
            }

            var notifications = snapshot.data ?? [];
            if (notifications.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
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
                const DrawerHeader(
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
      body: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildProfileDetails();
        },
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Container(
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
          Container(
            child: Column(
              children: [
                //_profileImage(),
                _imageWidget(),
                SizedBox(
                  height: _widthXheight! * 0.5,
                ),
                if (_fname == null) ...{
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                } else ...{
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_fname != null && _lname != null) ...{
                        Text(
                          "$_fname $_lname",
                          style: TextStyle(
                            fontSize: _deviceWidth! * 0.0135,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      },
                      if (_regNo != null) ...{
                        Text(
                          "$_regNo",
                          style: TextStyle(
                            fontSize: _deviceWidth! * 0.0135,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      },
                      if (_post != null) ...{
                        Text(
                          "$_post",
                          style: TextStyle(
                            fontSize: _deviceWidth! * 0.0135,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      },
                    ],
                  ),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileImage() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight! * 0.01),
      height: _widthXheight! * 6,
      width: _widthXheight! * 6,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(500)),
      child: Column(
        children: [
          if (_imageLink != null) ...{
            ClipRRect(
              borderRadius: BorderRadius.circular(50000),
              child: Image.network(
                _imageLink!,
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
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          } else ...{
            ClipRRect(
              borderRadius: BorderRadius.circular(50000),
              child: Image.network(
                "https://avatar.iran.liara.run/public/3",
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
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          },
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return Column(
      children: [
        if (_imageLink != null) ...{
          Container(
            width: _widthXheight! * 6,
            height: _widthXheight! * 6,
            child: CircleAvatar(
              radius: _widthXheight! * 3,
              backgroundImage: NetworkImage(_imageLink!),
            ),
          ),
        } else if (_fname == null) ...{
          const Center(
            child: SizedBox(
              height: 50,
            ),
          )
        } else ...{
          Container(
            width: _widthXheight! * 6,
            height: _widthXheight! * 6,
            child: CircleAvatar(
              radius: _widthXheight! * 3,
              backgroundImage:
                  NetworkImage("https://avatar.iran.liara.run/public/3"),
            ),
          ),
        }
      ],
    );
  }

  List<Widget> _buildNotificationTiles(
      List<Map<String, dynamic>> notifications) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy \'at\' h:mm:ss a');

    return notifications.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> notification = entry.value;

      String formattedDate;
      if (notification['registered_date'] is Timestamp) {
        // Convert Firestore Timestamp to DateTime
        DateTime dateTime = notification['registered_date'].toDate();
        // Format DateTime to desired string format
        formattedDate = formatter.format(dateTime);
      } else {
        // Fallback for any other type (just in case)
        formattedDate = notification['registered_date'].toString();
      }

      // Alternate colors between notifications
      Color tileColor = index % 2 == 0 ? Colors.blue[100]! : Colors.grey[200]!;

      return ListTile(
        title: Text(notification['description']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${notification['name'] ?? 'N/A'}'),
            Text(formattedDate),
          ],
        ),
        tileColor: tileColor, // Set the background color
      );
    }).toList();
  }
}
