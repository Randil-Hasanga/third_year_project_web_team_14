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

    return Container(
      margin: EdgeInsets.only(
        right: _deviceWidth! * 0.01,
        top: _deviceWidth! * 0.01,
        bottom: _deviceWidth! * 0.01,
      ),
      padding: EdgeInsets.all(_widthXheight! * 1),
      // height: _widthXheight! * 13,
      // width: _deviceWidth! * 0.2,
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
              IconButton(
                onPressed: () {
                  //Navigator.pop(context);
                },
                icon: const Icon(Icons.notifications_none_outlined),
                iconSize: _widthXheight! * 1.5,
              ),
            ],
          ),
          SizedBox(
            height: _deviceHeight! * 0.15,
          ),
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
                        fontSize: _widthXheight! * 0.9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$_regNo", //TODO: add name
                      style: TextStyle(
                        fontSize: _widthXheight! * 0.9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$_post", //TODO: add name
                      style: TextStyle(
                        fontSize: _widthXheight! * 0.9,
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
}
