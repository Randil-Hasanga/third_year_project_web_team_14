import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/richText.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;
FirebaseService? _firebaseService;
RichTextWidget? _richTextWidget;

class CreateOfficerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateOfficerPageState();
  }
}

class _CreateOfficerPageState extends State<CreateOfficerPage> {
  List<Map<String, dynamic>>? officer;

  get sha256 => null;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
  }

  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final regNoController = TextEditingController();
  final positionController = TextEditingController();
  String? selectedGender;
  final contactNoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    regNoController.dispose();
    positionController.dispose();
    contactNoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to hash a password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashedBytes = sha256.convert(bytes);
    return hashedBytes.toString();
  }

  // Function to validate a strong password
  bool _isStrongPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#\$&*~]'));
  }

  // Function to save officer data to Firestore
  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      String hashedPassword = _hashPassword(passwordController.text);
      // Check if form is valid
      await FirebaseFirestore.instance.collection('users').add({
        'username': userNameController.text,
        'fname': firstNameController.text,
        'lname': lastNameController.text,
        'reg_no': regNoController.text,
        'position': positionController.text,
        'gender': selectedGender,
        'contact': contactNoController.text,
        'email': emailController.text,
        'registered_date': FieldValue.serverTimestamp(),
        'disabled': false,
        'type': "officer",
        'hashed_password':
            hashedPassword, // Optional, to track when data is added
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data saved successfully!")),
      );

      // Clear fields
      userNameController.clear();
      firstNameController.clear();
      lastNameController.clear();
      regNoController.clear();
      positionController.clear();
      setState(() {
        selectedGender = null;
      });
      contactNoController.clear();
      emailController.clear();
    }
  }

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 12.0,
                ),
                _richTextWidget!.simpleText(
                    "Create New Officer", 20, Colors.black, FontWeight.w600),
                SizedBox(
                  height: 16.0,
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
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a last name';
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
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter registration no';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: 'Position',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter position';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text("Select Gender:"),
                Row(
                  children: [
                    Radio<String>(
                      value: "Male",
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text("Male"),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Female",
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text("Female"),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: contactNoController,
                  decoration: InputDecoration(
                    labelText: 'Contact No',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter contact no';
                    }
                    final regex = RegExp(r'^\+?[0-9]{10,15}$');

                    if (!regex.hasMatch(value)) {
                      return "Invalid contact number";
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email address';
                    }
                    bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
                    ).hasMatch(value);
                    if (!emailValid) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true, // Hides the text for security
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }

                    if (!_isStrongPassword(value)) {
                      return "Password must be at least 8 characters long, with uppercase, lowercase, digits, and special characters";
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true, // Hides the text for security
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }

                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _saveData, child: Text('Submit')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
