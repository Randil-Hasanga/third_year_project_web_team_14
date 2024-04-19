import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/test.dart';
import 'package:jms_desktop/services/firebase_services.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;

class PendingApprovals extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PendingApprovalsState();
  }
}

class _PendingApprovalsState extends State<PendingApprovals> {
  FirebaseService? _firebaseService;
  List<Map<String, dynamic>>? pendingApprovals;
    bool _showLoader = true;

  ScrollController _scrollControllerLeft = ScrollController();
  bool _isDetailsVisible = false;
  Map<String, dynamic>? _selectedApproval;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _loadJobProviders();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLoader = false;
        });
      }
    });
  }

  void _loadJobProviders() async {
    List<Map<String, dynamic>>? data =
        await _firebaseService!.getApprovalsData();
    setState(() {
      pendingApprovals = data;
    });
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
              child: ApprovalListWidget(),
            ),
            Expanded(
              flex: 2,
              child: _isDetailsVisible
                  ? SelectedApprovalDetailsWidget(_selectedApproval)
                  : Container(
                      child: Center(
                          child: Text(
                        "Select a provider to view details",
                        style: TextStyle(
                          fontSize: _widthXheight! * 0.5,
                        ),
                      )),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget ApprovalListWidget() {
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
                  top: _widthXheight! * 0.7, left: _widthXheight! * 0.1),
              child: Row(
                children: [
                  Text(
                    "Pending Job Providers",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _widthXheight! * 0.7,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: pendingApprovals == null,
                  child: Center(
                    child: Stack(
                      children: [
                        Visibility(
                          visible: _showLoader,
                          child: const CircularProgressIndicator(
                            color: selectionColor,
                          ),
                          replacement: const Center(
                            child: Text(
                              "No pending approvals found."
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: pendingApprovals != null,
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: pendingApprovals?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return PendingListViewBuilderWidget(
                            pendingApprovals![index]);
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

  Widget PendingListViewBuilderWidget(Map<String, dynamic> provider) {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isDetailsVisible = true;
            _selectedApproval = provider;
          });
        },
        child: AnimatedContainer(
          duration: Duration(microseconds: 300),
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
}

class SelectedApprovalDetailsWidget extends StatelessWidget {
  final Map<String, dynamic>? provider;

  const SelectedApprovalDetailsWidget(this.provider);

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: _deviceWidth! * 0.01, vertical: _deviceHeight! * 0.02),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Details of Selected Job Provider",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          if (provider != null) ...{
            Text("Name: ${provider!['username']}"),
            Text("Email: ${provider!['email']}"),
            // Add more details as needed
          }
        ],
      ),
    );
  }
}
