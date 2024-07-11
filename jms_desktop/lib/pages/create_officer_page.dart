import 'package:firebase_auth/firebase_auth.dart';
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
  final String _accountType = 'officer';
  final _createOfficerFormKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _confirmpasswordFocusNode = FocusNode();
  String? _userName,
      _fName,
      _lName,
      _regNo,
      _possition,
      _selectedGender,
      _contactNo,
      _email,
      _nic,
      _createdBy,
      _password,
      _confirmPassword;

  @override
  void initState() {
    super.initState();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
  }

  String? uid;
  Map? currentUser;

  // Function to save officer data to Firestore
  Future<void> _saveOfficerData() async {
    if (_createOfficerFormKey.currentState!.validate()) {
      _createOfficerFormKey.currentState!
          .save(); // Important to save form fields
      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }
      try {
        // Check if reg_no already exists in Firestore
        var existingRegNo = await FirebaseFirestore.instance
            .collection('users')
            .where('reg_no', isEqualTo: _regNo)
            .get();

        if (existingRegNo.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration number already exists")),
          );
          return;
        }
        // Create a user with Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        User? user = userCredential.user;

        if (user != null) {
          // Send email verification
          await user.sendEmailVerification();
          // Store additional user data in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'username': _userName,
            'fname': _fName,
            'lname': _lName,
            'reg_no': _regNo,
            'position': _possition,
            'gender': _selectedGender,
            'contact': _contactNo,
            'nic': _nic,
            'email': _email,
            'registered_date': FieldValue.serverTimestamp(),
            'disabled': false,
            'type': _accountType,
            'created_by': _createdBy,
            'isBeingUpdated': false,
            // Optional, to track when data is added
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Data saved successfully!")),
          );
          _clearForm(); // Call the clear function to reset the form
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  void _clearForm() {
    // Reset the form to clear validation errors
    _createOfficerFormKey.currentState!.reset();

    // Reset the string variables to clear the form data
    setState(() {
      _userName = null;
      _fName = null;
      _lName = null;
      _regNo = null;
      _possition = null;
      _contactNo = null;
      _email = null;
      _nic = null;
      _password = null;
      _confirmPassword = null;
      _selectedGender = null;
      _createdBy = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Form cleared successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: _deviceWidth! * 0.11,
          bottom: _deviceHeight! * 0.03,
          top: _deviceHeight! * 0.03,
          right: _deviceWidth! * 0.11,
        ),
        padding: EdgeInsets.only(
          top: _widthXheight! * 0.1,
          left: _deviceWidth! * 0.05,
          bottom: _widthXheight! * 0.7,
          right: _deviceWidth! * 0.05,
        ),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _createOfficerFormKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 12.0,
                ),
                _richTextWidget!.simpleText(
                    "Create New Officer", 25, Colors.black, FontWeight.w600),
                Divider(),
                const SizedBox(
                  height: 16.0,
                ),
                // User name field
                TextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _userName = _value!;
                    });
                  },
                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    icon: Icon(Icons.verified_user),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // First name Field
                TextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _fName = _value!;
                    });
                  },
                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // Last Name field
                TextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _lName = _value!;
                    });
                  },
                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // Registration no field
                TextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _regNo = _value!;
                    });
                  },
                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please enter registration no';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Registration No',
                    icon: Icon(Icons.app_registration),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                //position feild

                TextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _possition = _value!;
                    });
                  },
                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please enter position';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Position',
                    icon: Icon(Icons.manage_accounts),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                //select gender field
                const Text("Select Gender:"),
                Row(
                  children: [
                    Radio<String>(
                      value: "Male",
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
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
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    Text("Female"),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                //NIC field
                TextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _nic = _value!;
                    });
                  },
                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please enter NIC card number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'NIC',
                    icon: Icon(Icons.perm_identity),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                //Contact field
                TextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _contactNo = _value!;
                    });
                  },
                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please enter contact no';
                    }
                    final regex = RegExp(r'^\+?[0-9]{10,12}$');

                    if (!regex.hasMatch(_value)) {
                      return "Invalid contact number";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Contact No',
                    icon: Icon(Icons.mobile_friendly),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // Email field
                TextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _email = _value!;
                    });
                  },
                  validator: (_value) {
                    if (_value!.isEmpty) {
                      return 'Please enter email address';
                    }
                    bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
                    ).hasMatch(_value);
                    if (!emailValid) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // Created person
                TextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _createdBy = _value!;
                    });
                  },
                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please enter created person name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Created By',
                    icon: Icon(Icons.manage_accounts),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // Password field
                TextFormField(
                  // focusNode: _passwordFocusNode,
                  obscureText: true, // Hides the text for security
                  decoration: InputDecoration(
                    labelText: "Password",
                    icon: Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),

                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (_value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  onSaved: (_value) {
                    _password = _value!;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // confirm password field
                TextFormField(
                  // focusNode: _confirmpasswordFocusNode,
                  obscureText: true, // Hides the text for security
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    icon: Icon(Icons.password_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),

                  validator: (_value) {
                    if (_value == null || _value.isEmpty) {
                      return 'Please confirm your password';
                    }
                  },
                  onSaved: (_value) {
                    _confirmPassword = _value!;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _saveOfficerData, // Save the data
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue, // Text color
                          ),
                          child: Text('Submit'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _clearForm, // Clear the form
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red, // Text color
                          ),
                          child: Text('Clear'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
