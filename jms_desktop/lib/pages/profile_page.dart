import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/edit_profile.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/richText.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  double? _deviceWidth, _deviceHeight, _widthXheight;
  FirebaseService? _firebaseService;
  RichTextWidget? _richTextWidget;
  String? _fname, _lname, _regNo, _post, _email, _contactNo, _imageLink;
  Map<String, dynamic>? officer;
  dynamic imageFile;
  String? imageName;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
    getDataFromDB();
  }

  Future<void> getDataFromDB() async {
    officer = await _firebaseService!.getCurrentOfficerData();

    if (officer != null) {
      if (mounted) {
        setState(() {
          _imageLink = officer!['profile_image'];
          _fname = officer!['fname'];
          _lname = officer!['lname'];
          _email = officer!['email'];
          _contactNo = officer!['contact'];
          _regNo = officer!['reg_no'];
          _post = officer!['position'];
        });
      }
    } else {
      print("officer is null");
    }

    print(officer);
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

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
                  _selectImageWidget(),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_fname != null) ...{
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
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(),
                                ),
                              );
                            },
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
                  } else ...{
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  }
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
          _richTextWidget!.KeyValuePairrichText(
              "Name : ", "$_fname $_lname", _deviceWidth! * 0.014),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          _richTextWidget!.KeyValuePairrichText(
              "Reg No : ", "$_regNo", _deviceWidth! * 0.014),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          _richTextWidget!.KeyValuePairrichText(
              "Position : ", "$_post", _deviceWidth! * 0.014),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          _richTextWidget!.KeyValuePairrichText(
              "Contact No : ", "$_contactNo", _deviceWidth! * 0.014),
          SizedBox(
            height: _widthXheight! * 0.35,
          ),
          _richTextWidget!.KeyValuePairrichText(
              "E-Mail : ", "$_email", _deviceWidth! * 0.014),
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

  Widget _selectImageWidget() {
    return Column(
      children: [
        if (imageFile != null) ...{
          GestureDetector(
            onTap: () async {
              await pickImage();
            },
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.memory(imageFile),
                  ),
                ),
                const Icon(Icons.add_a_photo),
              ],
            ),
          ),

          // Display the picked image
        } else if (_imageLink != null) ...{
          GestureDetector(
            onTap: () async {
              await pickImage();
            },
            child: Stack(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(_imageLink!),
                  ),
                ),
                const Icon(Icons.add_a_photo),
              ],
            ),
          ),
        } else ...{
          GestureDetector(
            onTap: () async {
              await pickImage();
            },
            child: Stack(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: const CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/jobcenter-app-74ca3.appspot.com/o/images%2FJIwYENZjwIOSicyjGEaWK7mTCvB2%2Flogo.jpg?alt=media&token=12ae69bd-5832-4420-bf2f-814bafdc5563"),
                  ),
                ),
                const Icon(Icons.add_a_photo),
              ],
            ),
          ),
        }
      ],
    );
  }

  Future<void> pickImage() async {
    FilePickerResult? resultFilePicker = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (resultFilePicker != null && resultFilePicker.files.isNotEmpty) {
      // Ensure that files is not empty
      Uint8List? bytes = resultFilePicker.files.first.bytes;
      if (bytes != null) {
        setState(() {
          imageFile = bytes;
          imageName = resultFilePicker.files.first.name;
        });
      } else {
        print("Error: Picked file doesn't contain image data.");
      }
    } else {
      print("Error: No file picked.");
    }
  }
}
