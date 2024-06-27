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
  List<Map<String, dynamic>>? _deletedUsers;
  bool _showLoader = true;
  bool _showNoProvidersFound = false;
  bool _showNoSeekersFound = false;
  bool _showNoUsersFound = false;
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
        setState(() {
          if (_dropDownValue == "Job Providers") {
            _deletedJobProviders = data;
            _showNoProvidersFound =
                _deletedJobProviders == null || _deletedJobProviders!.isEmpty;
          } else if (_dropDownValue == "Job Seekers") {
            _deletedJobSeekers = data;
            _showNoSeekersFound =
                _deletedJobSeekers == null || _deletedJobSeekers!.isEmpty;
          }
        });
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
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    _firebaseService = GetIt.instance.get<FirebaseService>();
    _getDataFromDB();

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    size: _widthXheight! * 1.5,
                  ),
                  SizedBox(
                    width: _deviceWidth! * 0.01,
                  ),
                  Text(
                    "Recycle bin",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _widthXheight! * 1,
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
                  }

                  // Expanded(
                  //   flex: 1,
                  //   child: _DeletedSeekersListWidget(),
                  // ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Container(
                  //     color: Colors.green,
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Job Providers",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _widthXheight! * 0.7,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                        return _deletedProvidersListViewBuilder(
                            _deletedJobProviders![index]);
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

  Widget _deletedProvidersListViewBuilder(Map<String, dynamic> provider) {
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
            // Icon(
            //   Icons.developer_mode,
            //   size: _widthXheight! * 1,
            // ),
            if (provider['company_name'] != null) ...{
              _richTextWidget.deletedProviderTableRow(
                  provider['repEmail'],
                  provider['company_name'],
                  provider['repName'],
                  provider['repTelephone'],
                  provider['disabled_by'],
                  provider['disabled_date'],
                  15,
                  Colors.black,
                  Colors.white, function: () {
                _showRestoreConfirmationDialog(context, provider['uid']);
              }, "Restore"),
            } else ...{
              Text(provider['username']),
            },
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
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: _widthXheight! * 0.7, left: _widthXheight! * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Job Seekers",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: _widthXheight! * 0.7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _selectedUserDropdown(),
                  ],
                ),
              )),
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
                      itemCount: _deletedJobProviders?.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return _deletedSeekersListViewBuilder(
                            _deletedJobProviders![index]);
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

  Widget _deletedSeekersListViewBuilder(Map<String, dynamic> provider) {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedProvider = provider;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(microseconds: 300),
          height: _deviceHeight! * 0.08,
          width: _deviceWidth! * 0.175,
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(_widthXheight! * 0.66),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth! * 0.001,
                vertical: _deviceHeight! * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: _deviceWidth! * 0.01,
                ),
                Icon(
                  Icons.developer_mode,
                  size: _widthXheight! * 1,
                ),
                if (provider['username'] != null) ...{
                  Text(provider['username']),
                }
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _restoreUser(String uid) async {
  //   await _firebaseService!.restoreUser(uid);
  //   _getDataFromDB();
  // }

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
                          await _firebaseService!.restoreUser(uid);

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
    List<String> _userType = [
      "Job Providers",
      "Job Seekers",
    ];
    List<DropdownMenuItem<String>> _items = _userType
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
                color: Colors.black,
                fontSize: _widthXheight! * 0.7,
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
