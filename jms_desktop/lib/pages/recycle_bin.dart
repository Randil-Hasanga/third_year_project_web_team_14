import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/richText.dart';

class RecycleBin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecycleBinState();
  }
}

class _RecycleBinState extends State<RecycleBin> {
  RichTextWidget _richTextWidget = RichTextWidget();
  double? _deviceWidth, _deviceHeight, _widthXheight;
  ScrollController _scrollControllerLeft = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  List<Map<String, dynamic>>? _deletedJobProviders;
  List<Map<String, dynamic>>? _deletedJobSeekers;
  List<Map<String, dynamic>>? _deletedOfficers;
  bool _showLoader = true;
  bool _showNoProvidersFound = false;
  bool _showNoSeekersFound = false;
  bool _showNoOfficersFound = false;
  Map<String, dynamic>? _selectedProvider, _selecteduser, _selectedSeeker;
  FirebaseService? _firebaseService;
  String? _dropDownValue = "Job Providers";

  @override
  void initState() {
    super.initState();
  }

  void _getDataFromDB() async {
    try {
      List<Map<String, dynamic>>? data =
          await _firebaseService!.getDeletedUsersData(_dropDownValue);

      if (mounted) {
        setState(
          () {
            if (_dropDownValue == "Job Providers") {
              _deletedJobProviders = data;
              print("Deleted job providers : $_deletedJobProviders");
              _showNoProvidersFound =
                  _deletedJobProviders == null || _deletedJobProviders!.isEmpty;
            } else if (_dropDownValue == "Job Seekers") {
              _deletedJobSeekers = data;
              print("Deleted job seekers : $_deletedJobSeekers");
              _showNoSeekersFound =
                  _deletedJobSeekers == null || _deletedJobSeekers!.isEmpty;
            } else if (_dropDownValue == "Officers") {
              _deletedOfficers = data;
              print("Deleted officers : $_deletedOfficers");
              _showNoOfficersFound =
                  _deletedOfficers == null || _deletedOfficers!.isEmpty;
            }
          },
        );
      }

      setState(() {
        _showLoader = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _getDataFromDB();

    return Scaffold(
      body: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          _deviceHeight = constraints.maxHeight;

          _deviceWidth = constraints.maxWidth;
          _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: _widthXheight! * 0.7, left: _widthXheight! * 0.7),
                child: Row(
                  children: [
                    Icon(
                      Icons.recycling_rounded,
                      size: _widthXheight! * 1,
                    ),
                    SizedBox(
                      width: _deviceWidth! * 0.007,
                    ),
                    Text(
                      "Recycle bin",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: _deviceWidth! * 0.017,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_dropDownValue == "Job Providers") ...{
                      Expanded(
                        flex: 1,
                        child: _deletedProvidersListWidget(),
                      ),
                    } else if (_dropDownValue == "Job Seekers") ...{
                      Expanded(
                        flex: 1,
                        child: _deletedSeekersListWidget(),
                      ),
                    } else if (_dropDownValue == "Officers") ...{
                      Expanded(
                        flex: 1,
                        child: _deletedOfficersListWidget(),
                      ),
                    }
                  ],
                ),
              ),
            ],
          );
        },
      )),
    );
  }

  Widget _deletedProvidersListWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: _deviceWidth! * 0.01,
        right: _deviceWidth! * 0.005,
        bottom: _deviceHeight! * 0.02,
        top: _deviceHeight! * 0.02,
        // /top: _deviceHeight! * 0.02,
      ),
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: _widthXheight! * 0.7, left: _widthXheight! * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text(
                  //   "Job Providers",
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: _deviceWidth! * 0.02,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  _selectedUserDropdown(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _widthXheight! * 0.7,
                left: _widthXheight! * 0.1,
                bottom: _deviceHeight! * 0.005),
            child: _richTextWidget.deletedProviderTableRow(
                "Contact Email",
                "Company Name",
                "REP name",
                "Contact No",
                "Disabled by",
                "Disabled date",
                15,
                Colors.black,
                Color.fromARGB(255, 199, 197, 197), function: () {
              print("TESTING");
            }, "Actions"),
          ),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: _showLoader,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: selectionColor,
                        ),
                        const SizedBox(height: 8),
                        if (_deletedJobProviders == null ||
                            _deletedJobProviders!.isEmpty) ...{
                          _richTextWidget!.simpleText(
                              "Loading...", null, Colors.black, null),
                        } else ...{
                          _richTextWidget!.simpleText(
                              "Fetching database...", null, Colors.black, null),
                        }
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _deletedJobProviders != null,
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: _deletedJobProviders?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> provider =
                            _deletedJobProviders![index];
                        return FutureBuilder<Map?>(
                          future: _firebaseService!
                              .getUserData(uid: provider['disabled_by']),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              Map? deletedBy = snapshot.data;
                              String? fname = deletedBy?['fname'];
                              String? lname = deletedBy?['lname'];
                              print("Deleted data $fname $lname");

                              return _deletedProvidersListViewBuilder(
                                provider,
                                deletedByName: '$fname $lname',
                              );
                            } else {
                              return const Center(
                                  child: LinearProgressIndicator(
                                color: backgroundColor,
                              ));
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _showNoProvidersFound,
                  child: Center(
                    child: _richTextWidget!.simpleText(
                        "No providers found.", null, Colors.black, null),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deletedProvidersListViewBuilder(Map<String, dynamic> provider,
      {required String deletedByName}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProvider = provider;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.001,
            vertical: _deviceHeight! * 0.005),
        child: Stack(
          children: [
            if (provider['company_name'] != null) ...{
              _richTextWidget.deletedProviderTableRow(
                  provider['repEmail'],
                  provider['company_name'],
                  provider['repName'],
                  provider['repTelephone'],
                  deletedByName,
                  provider['disabled_date'],
                  15,
                  Colors.black,
                  Colors.white, function: () {
                _showRestoreConfirmationDialog(context, provider['uid']);
              }, "Restore"),
            }
          ],
        ),
      ),
    );
  }

  Widget _deletedSeekersListWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: _deviceWidth! * 0.005,
        right: _deviceWidth! * 0.01,
        bottom: _deviceHeight! * 0.02,
        top: _deviceHeight! * 0.02,
        // /top: _deviceHeight! * 0.02,
      ),
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: _widthXheight! * 0.7, left: _widthXheight! * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text(
                  //   "Job Seekers",
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: _widthXheight! * 0.7,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  _selectedUserDropdown(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _widthXheight! * 0.7,
                left: _widthXheight! * 0.1,
                bottom: _deviceHeight! * 0.005),
            child: _richTextWidget.deletedSeekerTableRow(
                "Username",
                "Email",
                "Disabled by",
                "Disabled date",
                15,
                Colors.black,
                Color.fromARGB(255, 199, 197, 197), function: () {
              print("TESTING");
            }, "Actions"),
          ),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: _showLoader,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: selectionColor,
                        ),
                        const SizedBox(height: 8),
                        if (_deletedJobSeekers == null ||
                            _deletedJobSeekers!.isEmpty) ...{
                          _richTextWidget!.simpleText(
                              "Loading...", null, Colors.black, null),
                        } else ...{
                          _richTextWidget!.simpleText(
                              "Fetching database...", null, Colors.black, null),
                        }
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _deletedJobSeekers != null &&
                      _dropDownValue == 'Job Seekers',
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: _deletedJobSeekers?.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> seeker =
                            _deletedJobSeekers![index];
                        return FutureBuilder<Map?>(
                          future: _firebaseService!
                              .getUserData(uid: seeker['disabled_by']),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              Map? deletedBy = snapshot.data;
                              String? fname = deletedBy?['fname'];
                              String? lname = deletedBy?['lname'];
                              print("Deleted data $fname $lname");

                              return _deletedSeekersListViewBuilder(
                                seeker,
                                deletedByName: '$fname $lname',
                              );
                            } else {
                              return const Center(
                                child: LinearProgressIndicator(
                                  color: backgroundColor,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _showNoSeekersFound,
                  child: Center(
                    child: _richTextWidget!.simpleText(
                        "No job seekers found.", null, Colors.black, null),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deletedSeekersListViewBuilder(Map<String, dynamic> seeker,
      {required String deletedByName}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth! * 0.001, vertical: _deviceHeight! * 0.005),
      child: Stack(
        children: [
          _richTextWidget.deletedSeekerTableRow(
              seeker['username'],
              seeker['email'],
              deletedByName,
              seeker['disabled_date'],
              15,
              Colors.black,
              Colors.white, function: () {
            _showRestoreConfirmationDialog(context, seeker['uid']);
          }, "Restore"),
        ],
      ),
    );
  }

  Widget _deletedOfficersListWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: _deviceWidth! * 0.005,
        right: _deviceWidth! * 0.01,
        bottom: _deviceHeight! * 0.02,
        top: _deviceHeight! * 0.02,
        // /top: _deviceHeight! * 0.02,
      ),
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: _widthXheight! * 0.7, left: _widthXheight! * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text(
                  //   "Deleted Officers",
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: _widthXheight! * 0.7,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  _selectedUserDropdown(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _widthXheight! * 0.7,
                left: _widthXheight! * 0.1,
                bottom: _deviceHeight! * 0.005),
            child: _richTextWidget.deletedOfficerTableRow(
                "Reg No",
                "Name",
                "Email",
                "Contact No",
                "Deleted by",
                "Deleted date",
                15,
                Colors.black,
                Color.fromARGB(255, 199, 197, 197), function: () {
              print("TESTING");
            }, "Actions"),
          ),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: _showLoader,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: selectionColor,
                        ),
                        const SizedBox(height: 8),
                        if (_deletedOfficers == null ||
                            _deletedOfficers!.isEmpty) ...{
                          _richTextWidget!.simpleText(
                              "Loading...", null, Colors.black, null),
                        } else ...{
                          _richTextWidget!.simpleText(
                              "Fetching database...", null, Colors.black, null),
                        }
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      _deletedOfficers != null && _dropDownValue == 'Officers',
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: _deletedOfficers?.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> officer = _deletedOfficers![index];
                        return FutureBuilder<Map?>(
                          future: _firebaseService!
                              .getUserData(uid: officer['disabled_by']),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              Map? deletedBy = snapshot.data;
                              String? fname = deletedBy?['fname'];
                              String? lname = deletedBy?['lname'];
                              print("Deleted data $fname $lname");

                              return _deletedOfficersListViewBuilder(
                                officer,
                                deletedByName: '$fname $lname',
                              );
                            } else {
                              return const Center(
                                child: LinearProgressIndicator(
                                  color: backgroundColor,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _showNoSeekersFound,
                  child: Center(
                    child: _richTextWidget!.simpleText(
                        "No job seekers found.", null, Colors.black, null),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deletedOfficersListViewBuilder(Map<String, dynamic> officer,
      {required String deletedByName}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth! * 0.001, vertical: _deviceHeight! * 0.005),
      child: Stack(
        children: [
          _richTextWidget.deletedOfficerTableRow(
              officer['reg_no'],
              "${officer['fname']} ${officer['lname']}",
              officer['email'],
              officer['contact'],
              deletedByName,
              officer['disabled_date'],
              15,
              Colors.black,
              Colors.white, function: () {
            _showRestoreConfirmationDialog(context, officer['uid']);
          }, "Restore"),
        ],
      ),
    );
  }

  void _showRestoreConfirmationDialog(BuildContext context, String uid) {
    showDialog(
      barrierDismissible: false, // Prevent dismissing when clicking outside
      context: context,
      builder: (BuildContext context) {
        bool _deleting = false; // State variable to track deletion process

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.symmetric(
                vertical: _deleting
                    ? 10
                    : 20, // Adjust content padding based on _deleting state
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  _richTextWidget!
                      .simpleText("Restore User", null, Colors.red, null),
                ],
              ),
              content: _deleting
                  ? const SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _richTextWidget!.simpleText(
                          "Are you sure you want to restore this user?",
                          null,
                          Colors.black87,
                          null),
                    ),
              actions: _deleting
                  ? []
                  : [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            _deleting = true; // Start deletion process
                          });
                          await _firebaseService!.restoreSeeker(uid);

                          _getDataFromDB();
                          Navigator.pop(context);
                        },
                        child: _richTextWidget!
                            .simpleText("Yes", null, Colors.red, null),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: _richTextWidget!
                            .simpleText("No", null, Colors.black, null),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  Widget _selectedUserDropdown() {
    List<String> _userType = ["Job Providers", "Job Seekers", "Officers"];
    List<DropdownMenuItem<String>> _items = _userType
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
                color: Colors.black,
                fontSize: _deviceWidth! * 0.017,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();

    return Center(
      child: DropdownButton(
        value: _dropDownValue,
        items: _items,
        onChanged: (_value) {
          //print(_value);
          print(_dropDownValue);
          setState(() {
            _dropDownValue = _value;
            _showLoader = true;
            _deletedJobProviders = [];
            _deletedJobSeekers = [];
            _deletedOfficers = [];
          });
          _getDataFromDB();
        },
        dropdownColor: backgroundColor3,
        borderRadius: BorderRadius.circular(10),
        iconSize: 20,
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.white,
        ),
        underline: Container(),
      ),
    );
  }
}
