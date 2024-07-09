import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/alert_box_widget.dart';
import 'package:jms_desktop/widgets/buttons.dart';
import 'package:jms_desktop/widgets/richText.dart';
import 'package:jms_desktop/widgets/textFieldWidget.dart';
import 'package:path_provider/path_provider.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  FirebaseService? _firebaseService;
  RichTextWidget _richTextWidget = RichTextWidget();
  TextFieldWidgets _textFieldWidgets = TextFieldWidgets();
  ButtonWidgets _buttonWidgets = ButtonWidgets();
  final GlobalKey<FormState> _officerUpdateFormKey = GlobalKey<FormState>();
  XFile? selectedImage;
  String? _imageLink;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  dynamic imageFile;
  String? imageName, imageLink;
  bool isUploading = false;

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController regNoController = TextEditingController();
  TextEditingController positionController = TextEditingController();

  AlertBoxWidgets _alertBoxWidgets = AlertBoxWidgets();
  Color warningColor = const Color.fromARGB(255, 255, 242, 125);
  Color successColor = const Color.fromARGB(255, 162, 255, 165);
  Color errorColor = const Color.fromARGB(255, 255, 153, 145);

  double? width, height, _widthXheight;

  Map<String, dynamic>? officer;

  String? _Fname, _Lname, _contact, _regNo, _position;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    getDataFromDB();
  }

  Future<void> getDataFromDB() async {
    officer = await _firebaseService!.getCurrentOfficerData();

    if (officer != null) {
      if (mounted) {
        setState(() {
          _imageLink = officer!['profile_image'];
          _Fname = officer!['fname'];
          _Lname = officer!['lname'];

          _contact = officer!['contact'];
          _regNo = officer!['reg_no'];
          _position = officer!['position'];

          fnameController.text = _Fname ?? '';
          lnameController.text = _Lname ?? '';

          contactController.text = _contact ?? '';
          regNoController.text = _regNo ?? '';
          positionController.text = _position ?? '';
        });
      }
    } else {
      print("officer is null");
    }

    print(officer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        _widthXheight = (height! * width!) / 50000;
        return _editProfile();
      },
    ));
  }

  Widget _currentDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackgroundColorLayer2,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
      child: const Column(),
    );
  }

  Widget _editProfile() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackgroundColorLayer2,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 35,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _richTextWidget!.simpleText(
                      "Edit Profile", 25, Colors.black, FontWeight.w600),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectImageWidget(),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            _officerUpdateForm(),
          ],
        ),
      ),
    );
  }

  Widget _officerUpdateForm() {
    return Form(
      key: _officerUpdateFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width! * 0.1),
        child: Column(
          children: [
            _textFieldWidgets.outlinedNormalTextFieldwithValidate((value) {
              setState(
                () {
                  _Fname = value;
                },
              );
            }, "First Name", validate: true, fnameController),
            _textFieldWidgets.outlinedNormalTextFieldwithValidate((value) {
              setState(
                () {
                  _Lname = value;
                },
              );
            }, "Last Name", validate: true, lnameController),
            _textFieldWidgets.outlinedNormalTextFieldwithValidate((value) {
              setState(
                () {
                  _regNo = value;
                },
              );
            }, "Registration Number", validate: true, regNoController),
            _textFieldWidgets.outlinedContactTextFieldwithValidate((value) {
              setState(
                () {
                  _contact = value;
                },
              );
            }, "Contact Number", validate: true, contactController),
            _textFieldWidgets.outlinedNormalTextFieldwithValidate((value) {
              setState(
                () {
                  _position = value;
                },
              );
            }, "Position", validate: true, positionController),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      if (!isUploading) ...{
                        ElevatedButton(
                          onPressed: _updateOfficer,
                          child: Text("Update"),
                        ),
                      } else ...{
                        CircularProgressIndicator(),
                      }
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateOfficer() async {
    try {
      if (_officerUpdateFormKey.currentState!.validate()) {
        _officerUpdateFormKey.currentState!.save();

        print("$_Fname $_Lname $_contact $_position $_regNo");

        setState(() {
          isUploading = true;
        });

        await _firebaseService!.updateOfficerProfile(_Fname, _Lname, _contact,
            _position, _regNo, imageFile, imageName, imageLink);

        setState(() {
          isUploading = false;
        });

        await getDataFromDB();
        _alertBoxWidgets.showAlert(
            context, "Success", "Profile successfully updated", successColor);
      }
    } catch (e) {
      print("Error updatin officer : $e");
      _alertBoxWidgets.showAlert(
          context, "Error", "Profile update failed\n$e", errorColor);
    }
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
                  height: _widthXheight! * 15,
                  width: _widthXheight! * 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_widthXheight! * 9),
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
                  width: _widthXheight! * 15,
                  height: _widthXheight! * 15,
                  child: CircleAvatar(
                    radius: _widthXheight! * 7.5,
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
                  width: _widthXheight! * 15,
                  height: _widthXheight! * 15,
                  child: CircleAvatar(
                    radius: _widthXheight! * 7.5,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpmMLA8odEi8CaMK39yvrOg-EGJP6127PmCjqURn_ssg&s'),
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
