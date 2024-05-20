import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:path_provider/path_provider.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  XFile? selectedImage;
  String? _imageLink;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  dynamic imageFile;
  String? imageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [Expanded(child: _editProfile())],
            ),
          ),
          Expanded(flex: 1, child: _currentDetails())
        ],
      ),
    );
  }

  Widget _currentDetails() {
    return Container(
      padding: EdgeInsets.all(20),
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
      margin: EdgeInsets.only(top: 20, bottom: 20, right: 20),
      child: Column(
        children: [
          ElevatedButton(
            child: Text("Pick Image"),
            onPressed: () async {
              await pickImage();
            },
          ),
          if (imageFile != null) ...{
            Image.memory(imageFile), // Display the picked image
          }
        ],
      ),
    );
  }

  Widget _editProfile() {
    return Container(
      padding: EdgeInsets.all(20),
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
      margin: EdgeInsets.all(20),
      child: Column(
        children: [],
      ),
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
          imageFile = bytes; // Set imageFile to the bytes of the picked image
          imageName = resultFilePicker.files.first.name;
        });
      } else {
        // Handle if the picked file doesn't contain bytes
        print("Error: Picked file doesn't contain image data.");
      }
    } else {
      // Handle if no file is picked
      print("Error: No file picked.");
    }
  }
}
