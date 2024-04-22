import 'package:flutter/material.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;

class CreateOfficerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateOfficerPageState();
  }
}

class _CreateOfficerPageState extends State<CreateOfficerPage> {
  FirebaseService? _firebaseService;
  List<Map<String, dynamic>>? officer;

  final userNameController = TextEditingController();
  final regNoController = TextEditingController();
  final positionController = TextEditingController();
  final genderController = TextEditingController();
  final contactNoController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
            left: _deviceWidth! * 0.3,
            bottom: _deviceHeight! * 0.02,
            top: _deviceHeight! * 0.02,
            right: _deviceWidth! * 0.3),
        child: Form(
          child: Column(
            children: [
              const SizedBox(
                height: 30.0,
                child: Text(
                  'Create new officer',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: regNoController,
                decoration: InputDecoration(
                    labelText: 'Registration No',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: positionController,
                decoration: InputDecoration(
                    labelText: 'Position',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: contactNoController,
                decoration: InputDecoration(
                    labelText: 'Contact No',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        CollectionReference addOfficer =
                            FirebaseFirestore.instance.collection('users');
                        addOfficer.add({
                          'username': userNameController.text,
                          'reg_no': regNoController.text,
                          'position': positionController.text,
                          'gender': genderController.text,
                          'contact': contactNoController.text,
                          'email': emailController.text
                        });
                      },
                      child: Text('Submit')))
            ],
          ),
        ),
      ),
    );
  }
}
