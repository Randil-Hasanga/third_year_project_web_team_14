import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/job_providers_page.dart';
import 'package:jms_desktop/pages/pending_approvals.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/richText.dart';

class DashboardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<DashboardWidget> {
  FirebaseService? _firebaseService;
  List<Map<String, dynamic>>? jobProviders;
  List<Map<String, dynamic>>? pendingApprovals;
  Map<String, dynamic>? _selectedProvider;
  int? _JobProvidersCount, _PendingApprovalsCount, _jobSeekerCount;
  bool _showLoaderCurrent = false;
  bool _showLoaderApprovals = false;
  RichTextWidget _richTextWidget = RichTextWidget();

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _getDataFromDB();
    _GetCounts();
  }

  void _GetCounts() async {
    // Fetch counts asynchronously
    Future.wait([
      _firebaseService!.getProviderCount(),
      _firebaseService!.getJobSeekerCount(),
      _firebaseService!.getApprovalsCount(),
    ]).then((List<int> counts) {
      if (mounted) {
        setState(() {
          _JobProvidersCount = counts[0];
          _jobSeekerCount = counts[1];
          _PendingApprovalsCount = counts[2];
        });
      }
    }).catchError((error) {
      print('Error fetching counts: $error');
    });
  }

  void _getDataFromDB() async {
    try {
      setState(() {
        _showLoaderCurrent = true;
        _showLoaderApprovals = true;
      });

      // Fetch data asynchronously from multiple sources
      List<List<Map<String, dynamic>>?> results = await Future.wait([
        _firebaseService!.getJobProviderData(),
        _firebaseService!.getApprovalsData(),
      ]);

      List<Map<String, dynamic>>? data = results[0];
      List<Map<String, dynamic>>? data2 = results[1];

      if (mounted) {
        setState(() {
          jobProviders = data;
          pendingApprovals = data2;
          _showLoaderCurrent = false;
          _showLoaderApprovals = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  double? _deviceWidth, _deviceHeight, _widthXheight;
  ScrollController _scrollControllerRight = ScrollController();
  ScrollController _scrollControllerLeft = ScrollController();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    return Column(
      children: [
        ActivityDetailsCardWidget(),
        SizedBox(
          height: _deviceHeight! * 0.006,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: CurrentProvidersListWidget(),
              ),
              Expanded(
                flex: 1,
                child: ApprovalListWidget(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget ApprovalListWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: _deviceWidth! * 0.005,
        bottom: _deviceHeight! * 0.02,
        right: _deviceWidth! * 0.01,
        //top: _deviceHeight! * 0.02,
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
                    "Pending Job Providers",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _deviceWidth! * 0.0135,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PendingApprovals(),
                        ),
                      );
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: _deviceWidth! * 0.0085,
                        fontWeight: FontWeight.w400,
                      ),
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
                  visible: _showLoaderApprovals,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: selectionColor,
                    ),
                  ),
                ),
                Visibility(
                  visible: !_showLoaderApprovals && pendingApprovals == null,
                  child: Center(
                    child: Text("No pending approvals found."),
                  ),
                ),
                Visibility(
                  visible: !_showLoaderApprovals && pendingApprovals != null,
                  child: Scrollbar(
                    controller: _scrollControllerRight,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerRight,
                      shrinkWrap: true,
                      itemCount: pendingApprovals?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return ApprovalListViewBuilderWidget(
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

  Widget ApprovalListViewBuilderWidget(Map<String, dynamic> provider) {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PendingApprovals(),
            ),
          );
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
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.pending_actions,
                  size: 25,
                ),
                const SizedBox(
                  width: 15,
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

  Widget ActivityDetailsCardWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.all(_deviceWidth! * 0.01),
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
            child: Padding(
              padding: EdgeInsets.all(_widthXheight! * 0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Current",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: _deviceWidth! * 0.0135,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: _deviceWidth! * 0.02,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _deviceHeight! * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cardBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(_widthXheight! * 0.66),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          height: _deviceHeight! * 0.25,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceWidth! * 0.01,
                                vertical: _deviceHeight! * 0.015),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Seekers ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _deviceWidth! * 0.0111,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Visibility(
                                            visible: _jobSeekerCount == null,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: selectionColor,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: _jobSeekerCount != null,
                                            child: Center(
                                              child: Text(
                                                _jobSeekerCount.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: _widthXheight! * 2,
                                                ),
                                              ),
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
                        ),
                      ),
                      SizedBox(
                        width: _deviceWidth! * 0.0125,
                      ),
                      Expanded(
                        flex: 1,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cardBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(_widthXheight! * 0.66),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          height: _deviceHeight! * 0.25,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceWidth! * 0.01,
                                vertical: _deviceHeight! * 0.015),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Providers ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _deviceWidth! * 0.0111,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Visibility(
                                            visible: _JobProvidersCount == null,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: selectionColor,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: _JobProvidersCount != null,
                                            child: Center(
                                              child: Text(
                                                _JobProvidersCount.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: _widthXheight! * 2,
                                                ),
                                              ),
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(right: _deviceWidth! * 0.01),
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
            child: Padding(
              padding: EdgeInsets.all(_widthXheight! * 0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Pending",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: _deviceWidth! * 0.0135,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: _deviceWidth! * 0.02,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _deviceHeight! * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cardBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(_widthXheight! * 0.66),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          height: _deviceHeight! * 0.25,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceWidth! * 0.01,
                                vertical: _deviceHeight! * 0.015),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Providers ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _deviceWidth! * 0.0111,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Visibility(
                                            visible:
                                                _PendingApprovalsCount == null,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: selectionColor,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                _PendingApprovalsCount != null,
                                            child: Center(
                                              child: Text(
                                                _PendingApprovalsCount
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: _widthXheight! * 2,
                                                ),
                                              ),
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget CurrentProvidersListWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: _deviceWidth! * 0.01,
        bottom: _deviceHeight! * 0.02,
        right: _deviceWidth! * 0.005,
        //top: _deviceHeight! * 0.02,
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
                    "Current Job Providers",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _deviceWidth! * 0.0135,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => JobProviders(),
                        ),
                      );
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: _deviceWidth! * 0.0085,
                        fontWeight: FontWeight.w400,
                      ),
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
                  visible: _showLoaderCurrent,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: selectionColor,
                    ),
                  ),
                ),
                Visibility(
                  visible: !_showLoaderCurrent && jobProviders == null,
                  child: Center(
                    child: Text("No job providers found."),
                  ),
                ),
                Visibility(
                  visible: !_showLoaderCurrent && jobProviders != null,
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: jobProviders?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return CurrentProvidersListViewBuilderWidget(
                            jobProviders![index]);
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

  Widget CurrentProvidersListViewBuilderWidget(Map<String, dynamic> provider) {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => JobProviders(),
            ),
          );
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.handshake,
                  size: 25,
                ),
                const SizedBox(
                  width: 20,
                ),
                if (provider['company_name'] != null) ...{
                  Expanded(
                    child: _richTextWidget!.simpleText(
                        provider['company_name'], null, Colors.black, null),
                  ),
                } else ...{
                  Expanded(
                    child: _richTextWidget!.simpleText(
                        provider['username'], null, Colors.black, null),
                  ),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}
