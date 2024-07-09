import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/create_officer_page.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/Search_bar_widget.dart';
import 'package:jms_desktop/widgets/richText.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;
RichTextWidget? _richTextWidget;

class OfficersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OfficersPageStete();
  }
}

class _OfficersPageStete extends State<OfficersPage> {
  SearchBarWidget? _searchBarWidget;
  final TextEditingController _searchController =
      TextEditingController(); // search fuction
  FirebaseService? _firebaseService;
  List<Map<String, dynamic>>? officer;

  final ScrollController _scrollControllerLeft = ScrollController();
  bool _isDetailsVisible = false;
  Map<String, dynamic>? _selectedOfficer;
  bool _showLoader = true;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
    _searchBarWidget = GetIt.instance.get<SearchBarWidget>();
    _loadOfficer();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLoader = false;
        });
      }
    });
  }

  void _loadOfficer() async {
    List<Map<String, dynamic>>? data = await _firebaseService!.getOfficerData();
    if (mounted) {
      setState(() {
        officer = data;
      });
    }

    print(data);
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
              flex: 1,
              child: OfficersListWidget(),
            ),
            Expanded(
              flex: 2,
              child: _isDetailsVisible
                  ? SelectedOfficerDetailsWidget(_selectedOfficer)
                  : Container(
                      child: Center(
                        child: Text(
                          "Selected a officer to view details",
                          style: TextStyle(
                            fontSize: _widthXheight! * 0.5,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget OfficersListWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: _deviceWidth! * 0.01,
        bottom: _deviceHeight! * 0.02,
        top: _deviceHeight! * 0.02,
      ),
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
      decoration: BoxDecoration(
        color: cardBackgroundColorLayer2,
        borderRadius: BorderRadius.circular(_widthXheight! * 1),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 0)),
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
                children: [
                  Icon(
                    Icons.work,
                    size: 35,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Current Officer ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateOfficerPage()),
                    ),
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        color: Color.fromARGB(255, 47, 146, 50),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _searchBarWidget!.searchBar(_searchController, "Search Officers..."),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: officer == null,
                  child: Center(
                    child: Stack(
                      children: [
                        Visibility(
                          visible: _showLoader,
                          replacement: const Center(
                            child: Text("Officers"),
                          ),
                          child: const CircularProgressIndicator(
                            color: selectionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: officer != null,
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: officer?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return OfficerLisviewBuilderWidget(officer![index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget OfficerLisviewBuilderWidget(Map<String, dynamic> officer) {
    bool isSelected = _selectedOfficer == officer;

    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isDetailsVisible = true;
            _selectedOfficer = officer;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(microseconds: 300),
          height: _deviceHeight! * 0.08,
          width: _deviceWidth! * 0.175,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 201, 255, 203)
                : cardBackgroundColor,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: _deviceWidth! * 0.01,
                    ),
                    Icon(
                      Icons.developer_mode,
                      size: _widthXheight! * 1,
                    ),
                    SizedBox(
                      width: _deviceWidth! * 0.01,
                    ),
                    if (officer['username'] != null) ...{
                      Text(officer['username']),
                    },
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        String? uid = officer['uid'];
                        print(uid);
                        _showDeleteConfirmationDialog(context, uid!);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    SizedBox(
                      width: _deviceWidth! * 0.01,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                "Delete Officer",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this officer?",
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _firebaseService!.disableUser(uid);
                _loadOfficer();
                Navigator.pop(context);
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SelectedOfficerDetailsWidget extends StatelessWidget {
  final Map<String, dynamic>? officer;

  const SelectedOfficerDetailsWidget(this.officer);

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.01, vertical: _deviceHeight! * 0.02),
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.05, vertical: _deviceHeight! * 0.04),
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
            const Text(
              "Details of Selected Officer",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (officer != null) ...{
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _richTextWidget!.simpleText("Basic details", 20,
                                  Colors.black, FontWeight.w600),
                              const Divider(),
                              _richTextWidget!.KeyValuePairrichText(
                                "User Name:",
                                "${officer!['username']}",
                                15,
                              ),
                              const Divider(),
                              _richTextWidget!.KeyValuePairrichText(
                                "Registration No:",
                                "${officer!['reg_no']}",
                                15,
                              ),
                              const Divider(),
                              _richTextWidget!.KeyValuePairrichText(
                                "Gender:",
                                "${officer!['gender']}",
                                15,
                              ),
                              const Divider(),
                              _richTextWidget!.KeyValuePairrichText(
                                "Position:",
                                "${officer!['position']}",
                                15,
                              ),
                              const Divider(),
                              _richTextWidget!.KeyValuePairrichText(
                                "Contact No:",
                                "${officer!['contact']}",
                                15,
                              ),
                              const Divider(),
                              _richTextWidget!.KeyValuePairrichText(
                                "NIC",
                                "${officer!['nic']}",
                                15,
                              ),
                              const Divider(),
                              _richTextWidget!.KeyValuePairrichText(
                                "Email:",
                                "${officer!['email']}",
                                15,
                              ),
                              const Divider(),
                              _richTextWidget!.KeyValuePairrichText(
                                "Created By:",
                                "${officer!['created_by']}",
                                15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            }
          ],
        ),
      ),
    );
  }
}
