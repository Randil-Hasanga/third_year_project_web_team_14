import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/email_services.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/buttons.dart';

class BulkMailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BulkMailPageState();
  }
}

class _BulkMailPageState extends State<BulkMailPage> {
  double? _deviceWidth, _deviceHeight, _widthXheight;
  final GlobalKey<FormState> _mailFormKey = GlobalKey<FormState>();
  String? _recipientTypeDropDownValue = "Job Seekers";
  String? _locationDropdownValueFull = "Any";
  String? _EducationDropdownValue = "Any";
  String? _IndustryDropdownValue = "Any";
  String? englishDistrict;
  Set<String>? emailList;

  String? _subject, _body;

  // Define dropdown menus for each recipient type
  static const List<String> _recipientType = [
    "Job Providers",
    "Job Seekers",
  ];

  static const List<String> industries = [
    "Any",
    "Agriculture, Animal Husbandry and Forestry",
    "Fishing",
    "Mining and Quarrying",
    "Manufacturing",
    "Electricity Gas and Water Supply",
    "Construction",
    "Wholesale and Retail Trade",
    "Hotel and Restaurant",
    "Financial Services",
    "Real Estate Services",
    "Computer Related Services",
    "Research and Development Services",
    "Public Administration and Defence",
    "Health and Social Services",
    "Other Community, Social and Personal Services",
    "Private Household with Employed Personals",
    "Extra Territorial Organizations",
    "Transportation and Storage",
  ];

  static const List<String> _education = [
    "Any",
    'Below O/L',
    'Passed O/L',
    'Passed A/L',
    'undergraduate',
    'Graduate',
    'Post Graduate Diploma'
  ];

  static const List<String> _location = [
    "Any",
    'Ampara',
    'Anuradhapura',
    'Badulla',
    'Batticaloa',
    'Colombo',
    'Galle',
    'Gampaha',
    'Hambantota',
    'Jaffna',
    'Kalutara',
    'Kandy',
    'Kegalle',
    'Kilinochchi',
    'Kurunegala',
    'Mannar',
    'Matale',
    'Matara',
    'Monaragala',
    'Mullaitivu',
    'Nuwara Eliya',
    'Polonnaruwa',
    'Puttalam',
    'Ratnapura',
    'Trincomalee',
    'Vavuniya',
  ];

  bool isProviderSelected = false;
  bool isSeekerSelected = true;
  bool _isLoading = false;
  bool _isSending = false;

  FirebaseService? _firebaseService;
  EmailService? _emailService;
  ButtonWidgets? _buttonWidgets;
  double? totalWidth, totalHeight;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _emailService = GetIt.instance.get<EmailService>();
    _buttonWidgets = GetIt.instance.get<ButtonWidgets>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
    return Scaffold(
      body: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          totalWidth = constraints.maxWidth;
          totalHeight = constraints.maxHeight;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: totalHeight! * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: totalWidth! * 0.8,
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: cardBackgroundColorLayer2,
                          borderRadius:
                              BorderRadius.circular(_widthXheight! * 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  _mailForm(),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Text("To : "),
                                        _emailChips(),
                                        if (emailList != null &&
                                            emailList!.isNotEmpty) ...{
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              _buttonWidgets!
                                                  .simpleElevatedButtonWidget(
                                                onPressed: () {
                                                  setState(() {
                                                    emailList = {};
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 134, 145, 135),
                                                ),
                                                buttonText: "Clear",
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                        },
                                        const Divider(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(
                                              height: _deviceHeight! * 0.01,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: totalWidth! * 0.05,
                                                ),
                                                _selectedRecepientTypeDropdown(),
                                                SizedBox(
                                                  width: _deviceWidth! * 0.02,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Visibility(
                                                              visible:
                                                                  isSeekerSelected,
                                                              child: Material(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                elevation: 2,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          backgroundColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Text(
                                                                          "Highest Education"),
                                                                      _educationDropdown(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  _deviceWidth! *
                                                                      0.02,
                                                            ),
                                                            Visibility(
                                                              visible:
                                                                  isSeekerSelected,
                                                              child: Material(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                elevation: 2,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          backgroundColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Text(
                                                                          "District"),
                                                                      _locationDropdown(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  _deviceWidth! *
                                                                      0.02,
                                                            ),
                                                            Visibility(
                                                              visible:
                                                                  isProviderSelected,
                                                              child: Material(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                elevation: 2,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          backgroundColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Text(
                                                                          "District"),
                                                                      _locationDropdown(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              _deviceHeight! *
                                                                  0.02,
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              isSeekerSelected,
                                                          child: Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            elevation: 2,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      backgroundColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const Text(
                                                                      "Prefered Industry"),
                                                                  _categoryDropdown(),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              isProviderSelected,
                                                          child: Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            elevation: 2,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      backgroundColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const Text(
                                                                      "Industry"),
                                                                  _categoryDropdown(),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Visibility(
                                                  visible: isProviderSelected,
                                                  child:
                                                      _selectReciepientsButton(),
                                                ),
                                                Visibility(
                                                  visible: isSeekerSelected,
                                                  child:
                                                      _selectReciepientsButton(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _sendButton(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      )),
    );
  }

  // form for send email
  Widget _mailForm() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: Form(
        key: _mailFormKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: _deviceWidth! * 0.01,
                  ),
                  Icon(
                    Icons.mail,
                    size: _widthXheight! * 1.5,
                  ),
                  SizedBox(
                    width: _deviceWidth! * 0.01,
                  ),
                  Text(
                    "Bulk mail",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _widthXheight! * 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _subjectTextField(),
            _messageBody(),
          ],
        ),
      ),
    );
  }

  // subject text field widget
  Widget _subjectTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: "Subject",
            border: OutlineInputBorder(),
          ),
          onSaved: (newValue) {
            setState(() {
              _subject = newValue;
            });
          },
          validator: (value) {
            if (value == null) {
              return "Subject is Required";
            }
          },
        ),
      ),
    );
  }

  // message body textfield widget
  Widget _messageBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        color: Colors.white,
        child: TextFormField(
          maxLines: 15,
          minLines: 5,
          decoration: const InputDecoration(
            hintText: "Body",
            border: OutlineInputBorder(),
          ),
          onSaved: (newValue) {
            setState(() {
              _body = newValue;
            });
          },
          validator: (value) {
            if (value == null) {
              return "Message body is Required";
            }
          },
        ),
      ),
    );
  }

  //send button widget
  Widget _sendButton() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MaterialButton(
            elevation: 0, // Set elevation to 0 to hide the button background
            color: const Color.fromARGB(255, 150, 255, 124),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: _isLoading ? null : _sendMails,
            child: const Row(
              children: [
                Text(
                  "Send Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.send),
              ],
            ), // Disable button when loading
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: _isSending
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  )
                : const SizedBox(), // Empty SizedBox when not loading
          ),
        ),
      ],
    );
  }

  // function for send mails
  Future<void> _sendMails() async {
    _mailFormKey.currentState!.save();

    if (emailList == null) {
      print('Error: emailList is null.');
      return;
    } else {
      try {
        setState(() {
          _isSending = true;
        });

        List<String> _emailList = emailList!.toList();
        await _emailService!.sendEmail(_emailList, _subject!, _body!);
        print('All emails sent successfully.');
      } catch (error) {
        print('Error sending emails: $error');
      } finally {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

//show email list using flutter chip widget

  Widget _emailChips() {
    if (emailList != null && emailList!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 10.0, // Horizontal spacing between chips
          runSpacing: 8.0, // Vertical spacing between chip rows
          alignment:
              WrapAlignment.start, // Align chips to the start of the container
          children: emailList!.map((email) {
            return Chip(
              label: Text(email),
              onDeleted: () {
                setState(() {
                  emailList!.remove(email);
                });
              },
            );
          }).toList(),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  // button for confirm required recipients

  Widget _selectReciepientsButton() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MaterialButton(
            elevation: 0, // Set elevation to 0 to hide the button background
            color: const Color.fromARGB(255, 255, 170, 124),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: _isLoading ? null : _getEmails,
            child: const Text(
              "Select Recipients",
              style: TextStyle(fontWeight: FontWeight.bold),
            ), // Disable button when loading
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  )
                : const SizedBox(), // Empty SizedBox when not loading
          ),
        ),
      ],
    );
  }

  // retrieving email addresses according to drop down values
  Future<void> _getEmails() async {
    setState(() {
      _isLoading = true;
    });
    // Fetch new emails from the db
    List<String>? newEmailList = await _firebaseService!.getEmails(
      _recipientTypeDropDownValue!,
      _locationDropdownValueFull!,
      _IndustryDropdownValue!,
      _EducationDropdownValue,
    );

    // Ensure emailList is initialized
    emailList ??= {};

    // Add new emails to the emailList set if they are not null
    if (newEmailList != null) {
      for (String email in newEmailList) {
        emailList!.add(email);
      }
    }

    List<String> emailListAsList = emailList!.toList();
    print(emailListAsList);
    setState(() {
      _isLoading = false;
    });

    // Update UI
    setState(() {});
  }

  // drop down for select reciepient type
  Widget _selectedRecepientTypeDropdown() {
    List<DropdownMenuItem<String>> _items = _recipientType
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();

    return Center(
      child: DropdownButton(
        value: _recipientTypeDropDownValue,
        items: _items,
        onChanged: (_value) {
          setState(() {
            _recipientTypeDropDownValue = _value;
            emailList = {};

            shouldDropdownBeVisible();
          });
        },
        dropdownColor: backgroundColor3,
        borderRadius: BorderRadius.circular(10),
        iconSize: 20,
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black,
        ),
        underline: Container(),
      ),
    );
  }

  // mechanism for show or hide dropdowns when change reciepient type
  void shouldDropdownBeVisible() {
    if (_recipientTypeDropDownValue == "Job Seekers") {
      setState(() {
        isSeekerSelected = true;
        isProviderSelected = false;
      });
    } else if (_recipientTypeDropDownValue == "Job Providers") {
      setState(() {
        isSeekerSelected = false;
        isProviderSelected = true;
      });
    }
  }

  Widget _locationDropdown() {
    List<DropdownMenuItem<String>> _items = _location
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.black,
                //fontSize: _widthXheight! * 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();

    return Center(
      child: DropdownButton(
        value: _locationDropdownValueFull,
        items: _items,
        onChanged: (_value) {
          //print(_value);
          print(_locationDropdownValueFull);
          List<String> parts = _value!.split(" - ");
          englishDistrict = parts[0];
          setState(() {
            _locationDropdownValueFull = _value;
            print(englishDistrict);
          });
          //_getDataFromDB();
        },
        dropdownColor: backgroundColor3,
        borderRadius: BorderRadius.circular(10),
        iconSize: 20,
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black,
        ),
        underline: Container(),
      ),
    );
  }

  Widget _educationDropdown() {
    List<DropdownMenuItem<String>> _items = _education
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.black,
                //fontSize: _widthXheight! * 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();

    return Center(
      child: DropdownButton(
        value: _EducationDropdownValue,
        items: _items,
        onChanged: (_value) {
          setState(() {
            _EducationDropdownValue = _value;
            print(_EducationDropdownValue);
          });
          //_getDataFromDB();
        },
        dropdownColor: backgroundColor3,
        borderRadius: BorderRadius.circular(10),
        iconSize: 20,
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black,
        ),
        underline: Container(),
      ),
    );
  }

  Widget _categoryDropdown() {
    List<DropdownMenuItem<String>> _items = industries
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.black,
                //fontSize: _widthXheight! * 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();

    return Center(
      child: DropdownButton(
        value: _IndustryDropdownValue,
        items: _items,
        onChanged: (_value) {
          setState(() {
            _IndustryDropdownValue = _value;
            print(_IndustryDropdownValue);
          });
          //_getDataFromDB();
        },
        dropdownColor: backgroundColor3,
        borderRadius: BorderRadius.circular(10),
        iconSize: 20,
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black,
        ),
        underline: Container(),
      ),
    );
  }
}
