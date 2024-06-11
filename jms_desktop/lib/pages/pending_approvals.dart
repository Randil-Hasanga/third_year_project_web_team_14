import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/Search_bar_widget.dart';
import 'package:jms_desktop/widgets/buttons.dart';
import 'package:jms_desktop/widgets/downloadFile.dart';
import 'package:jms_desktop/widgets/richText.dart';
import 'package:url_launcher/url_launcher.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;
RichTextWidget? _richTextWidget;
ButtonWidgets? _buttonWidgets;
FirebaseService? _firebaseService;

DownloadFile _downloadFile = DownloadFile();

class PendingApprovals extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PendingApprovalsState();
  }
}

class _PendingApprovalsState extends State<PendingApprovals> {
  SearchBarWidget? _searchBarWidget;
  List<Map<String, dynamic>>? pendingApprovals;
  bool _showLoader = true;
  TextEditingController _searchController = TextEditingController();

  ScrollController _scrollControllerLeft = ScrollController();
  bool _isDetailsVisible = false;
  Map<String, dynamic>? _selectedApproval;
  List<Map<String, dynamic>>? filteredJobProviders;
  List<Map<String, dynamic>>? approvals;

  bool _showNoApprovalsFound = false;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _searchBarWidget = GetIt.instance.get<SearchBarWidget>();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
    _buttonWidgets = GetIt.instance.get<ButtonWidgets>();
    _loadJobProviders();
    _searchController.addListener(_filterJobProviders);
  }

  Future<void> _loadJobProviders() async {
    try {
      List<Map<String, dynamic>>? data =
          await _firebaseService!.getApprovalsData();

      if (mounted) {
        setState(() {
          pendingApprovals = data;
          filteredJobProviders = data;
          _showLoader = false;
          _showNoApprovalsFound = data == null || data.isEmpty;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  //filter for search function
  void _filterJobProviders() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredJobProviders = pendingApprovals;
      } else {
        filteredJobProviders = pendingApprovals
            ?.where((approval) =>
                (approval['company_name'] ?? '')
                    .toLowerCase()
                    .contains(query) ||
                (approval['username'] ?? '').toLowerCase().contains(query))
            .toList();
      }

      _showNoApprovalsFound =
          filteredJobProviders == null || filteredJobProviders!.isEmpty;
    });
  }

  void _updateUIAfterAction() async {
    setState(() {
      _isDetailsVisible = false;
      _showLoader = true;
    });

    try {
      await _loadJobProviders();
      setState(() {
        _showLoader = false;
      });
    } catch (error) {
      print('Error loading job providers: $error');
      setState(() {
        _showLoader = false;
      });
    }
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
            //first part of the row : pending providers list
            Expanded(
              flex: 1,
              child: pendingApprovalsListWidget(),
            ),
            Expanded(
              // second part of row : detais of selected provider (Using another class)
              flex: 2,
              child: _isDetailsVisible
                  ? SelectedApprovalDetailsWidget(
                      provider: _selectedApproval,
                      onUpdateUI: _updateUIAfterAction,
                    )
                  : Container(
                      child: Center(
                        child: Text(
                          "Select a provider to view details",
                          style: TextStyle(
                            fontSize: _widthXheight! * 0.5,
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  //pending providers list

  Widget pendingApprovalsListWidget() {
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
                top: _widthXheight! * 0.7,
                left: _widthXheight! * 0.1,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.pending_actions,
                    size: 35,
                  ),
                  SizedBox(width: _deviceWidth! * 0.005),
                  Expanded(
                    child: _richTextWidget!.simpleText(
                        "Pending Approvals", 25, Colors.black, FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
          //search widget
          _searchBarWidget!.searchBar(_searchController, "Search Provider..."),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: _showLoader,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: selectionColor,
                        ),
                        SizedBox(height: 8),
                        Text("Loading..."),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _showNoApprovalsFound,
                  child: const Center(
                    child: Text("No pending approvals found."),
                  ),
                ),
                Visibility(
                  visible: filteredJobProviders != null &&
                      filteredJobProviders!.isNotEmpty,
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: filteredJobProviders?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return pendingListViewBuilderWidget(
                            filteredJobProviders![index]);
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

  Widget pendingListViewBuilderWidget(Map<String, dynamic> provider) {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isDetailsVisible = true;
            _selectedApproval = provider; // save selected provider
          });
        },
        child: AnimatedContainer(
          duration: const Duration(microseconds: 300),
          height: 80,
          width: _deviceWidth! * 0.175,
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(20),
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
              vertical: _deviceHeight! * 0.015,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.pending_actions,
                  size: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                if (provider['username'] != null) ...{
                  Expanded(
                    child: _richTextWidget!.simpleText(
                        provider['username'], null, Colors.black, null),
                  ),
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// selected provider details are shown using this class

class SelectedApprovalDetailsWidget extends StatefulWidget {
  final Map<String, dynamic>? provider;
  final Function onUpdateUI;

  const SelectedApprovalDetailsWidget(
      {required this.provider, required this.onUpdateUI});

  @override
  State<SelectedApprovalDetailsWidget> createState() =>
      _SelectedApprovalDetailsWidgetState();
}

class _SelectedApprovalDetailsWidgetState
    extends State<SelectedApprovalDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: _deviceWidth! * 0.01, vertical: _deviceHeight! * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth! * 0.01,
        vertical: _widthXheight! * 0.7,
      ),
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

      //selected provider details
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Details of Selected Job Provider",
                style: TextStyle(
                  fontSize: _widthXheight! * 0.9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (widget.provider != null) ...{
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

                            // show basic data of provider
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Basic data",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Divider(),
                                _richTextWidget!.KeyValuePairrichText(
                                  "User Name : ",
                                  "${widget.provider!['username']}",
                                  18,
                                ),
                                _richTextWidget!.KeyValuePairrichText(
                                  "Email : ",
                                  "${widget.provider!['email']}",
                                  18,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: _deviceHeight! * 0.02),
                          if (widget.provider!['company_name'] != null) ...{
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
                              // if company details are filled by provider,
                              // show contact person details
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Contact person details",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Divider(),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Name : ",
                                    "${widget.provider!['repName']}",
                                    18,
                                  ),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Designation : ",
                                    "${widget.provider!['repPost']}",
                                    18,
                                  ),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Email : ",
                                    "${widget.provider!['repEmail']}",
                                    18,
                                  ),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Mobile : ",
                                    "${widget.provider!['repMobile']}",
                                    18,
                                  ),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Telephone : ",
                                    "${widget.provider!['repTelephone']}",
                                    18,
                                  ),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Fax : ",
                                    "${widget.provider!['repFax']}",
                                    18,
                                  ),
                                ],
                              ),
                            ),
                          }
                        ],
                      ),
                    ),
                    SizedBox(width: _deviceHeight! * 0.02),
                    if (widget.provider!['company_name'] != null) ...{
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.provider!['logo'] != null) ...{
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _logo(), // show logo
                                ],
                              )
                            },
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(16.0),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //show business registration document
                                  _richTextWidget!.simpleText(
                                      "Business Registration Document",
                                      18,
                                      const Color.fromARGB(255, 255, 0, 0),
                                      FontWeight.w600),
                                  _buttonWidgets!.simpleElevatedButtonWidget(
                                    onPressed: () {
                                      // _downloadFile.launchPDF(
                                      //     widget.provider!['businessRegDoc']);
                                      // _launchPDF(
                                      //     widget.provider!['businessRegDoc']);
                                      _downloadFile.downloadFile(
                                          widget.provider!['businessRegDoc']);
                                    },
                                    buttonText: "Show Document",
                                    style: null,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: _deviceHeight! * 0.02),
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

                                // show company details
                                children: [
                                  const Text(
                                    "Company details",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Divider(),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Company Name : ",
                                    "${widget.provider!['company_name']}",
                                    18,
                                  ),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Address : ",
                                    "${widget.provider!['company_address']}",
                                    18,
                                  ),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "District : ",
                                    "${widget.provider!['district']}",
                                    18,
                                  ),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Industry : ",
                                    "${widget.provider!['industry']}",
                                    18,
                                  ),
                                  _richTextWidget!.KeyValuePairrichText(
                                    "Organization type : ",
                                    "${widget.provider!['org_type']}",
                                    18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    }
                  ],
                ),
              }
            ],
          ),
          if (widget.provider!['company_name'] != null) ...{
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                      // show give approval card for approve or decline
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Give Approval ?",
                              style: TextStyle(
                                fontSize: 18, // Adjust font size as needed
                                fontWeight: FontWeight
                                    .bold, // Adjust font weight as needed
                                color:
                                    Colors.black, // Adjust text color as needed
                              ),
                            ),
                          ),
                          SizedBox(
                              height: _deviceHeight! *
                                  0.05), // Add spacing between text and buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: _deviceWidth! * 0.02,
                              ),
                              _buttonWidgets!.simpleElevatedButtonWidget(
                                  onPressed: () {
                                    _showConfirmationDialog(
                                        "Approve", widget.provider);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 120, 255, 124),
                                  ),
                                  buttonText: "Approve"),
                              SizedBox(
                                width: _deviceWidth! * 0.02,
                              ),
                              _buttonWidgets!.simpleElevatedButtonWidget(
                                  onPressed: () {
                                    _showConfirmationDialog(
                                        "Reject", widget.provider);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 120, 120),
                                  ),
                                  buttonText: "Reject"),
                              SizedBox(
                                width: _deviceWidth! * 0.02,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: _deviceHeight! * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          }
        ],
      ),
    );
  }

  // approve or decline confirmation dialog
  void _showConfirmationDialog(String action, Map<String, dynamic>? provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool _loading = false; // Track loading state

        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: SizedBox(
                height: 200, // Set a fixed height for the AlertDialog
                child: AlertDialog(
                  title: const Text("Confirmation"),
                  content: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : Text("Are you sure you want to $action?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () async {
                              setState(() {
                                _loading = true; // Show loading indicator
                              });

                              try {
                                // Dismiss the dialog before performing the action
                                if (action == "Reject") {
                                  await _firebaseService!
                                      .deleteProvider(provider!['uid']);
                                } else if (action == "Approve") {
                                  await _firebaseService!
                                      .approveProvider(provider!['uid']);
                                }
                                widget.onUpdateUI();
                              } catch (error) {
                                print('Error performing action: $error');
                              } finally {
                                setState(() {
                                  _loading = false; // Hide loading indicator
                                });
                                Navigator.of(context).pop(); // Close dialog
                              }
                            },
                      child: Text(action),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // company logo widget
  Widget _logo() {
    return Container(
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      margin: EdgeInsets.only(bottom: _deviceHeight! * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          widget.provider!['logo'],
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
}
