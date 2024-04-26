import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/BulkMailPages/bulk_mail.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/Search_bar_widget.dart';
import 'package:jms_desktop/widgets/buttons.dart';
import 'package:jms_desktop/widgets/richText.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;
FirebaseService? _firebaseService;
RichTextWidget? _richTextWidget;

class Report extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReportState();
  }
}

class _ReportState extends State<Report> {
  final ScrollController _scrollControllerLeft = ScrollController();
  String? _timePeriod = "This month";
  bool _isLoading = false;
  bool _isSending = false;
  List<Map<String, dynamic>>? vacancies;
  static const List<String> _timePeriodList = [
    "This month",
    "Last month",
    "Last two month",
    "Last tree month",
    "Last six month",
    "Last year",
  ];

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
    _loadVacancies();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
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
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  const Text("Time period"),
                                  _timePeriodDropdown(),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _generateButton(),
                                ],
                              ),
                            ),
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
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  _richTextWidget!.simpleText("Vacancies", 20,
                                      Colors.black, FontWeight.w600),
                                  const Divider(),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  _richTextWidget!.simpleText("Vacancies", 20,
                                      Colors.black, FontWeight.w600),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _timePeriodDropdown() {
    List<DropdownMenuItem<String>> _items = _timePeriodList
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
        value: _timePeriod,
        items: _items,
        onChanged: (_value) {
          setState(() {
            _timePeriod = _value;
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

  Widget _generateButton() {
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
            onPressed: _isLoading ? null : _loadVacancies,
            child: const Row(
              children: [
                Text(
                  "Genarate",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
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

  void _loadVacancies() async {
    DateTime currentDate = DateTime.now();
    DateTime startDate = currentDate;
    DateTime endDate = currentDate;
    if (_timePeriod == "This month") {
      startDate = DateTime(currentDate.year, currentDate.month);
    } else if (_timePeriod == "Last month") {
      startDate =
          DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    } else if (_timePeriod == "Last two month") {
      startDate =
          DateTime(currentDate.year, currentDate.month - 2, currentDate.day);
    } else if (_timePeriod == "Last tree month") {
      startDate =
          DateTime(currentDate.year, currentDate.month - 3, currentDate.day);
    } else if (_timePeriod == "Last six month") {
      startDate =
          DateTime(currentDate.year, currentDate.month - 6, currentDate.day);
    } else {
      startDate =
          DateTime(currentDate.year - 1, currentDate.month, currentDate.day);
    }

    // print(startDate);

    List<Map<String, dynamic>>? data =
        await _firebaseService!.getVacancyData(startDate, endDate);
    // print(data);
    setState(() {
      vacancies = data;
    });
  }

  Widget VacancyListWidget() {
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
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: vacancies == null,
                  child: Center(
                    child: Stack(
                      children: [
                        Visibility(
                          // visible: _showLoader,
                          replacement: const Center(
                            child: Text("Vacancies"),
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
                  visible: vacancies != null,
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: vacancies?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return VacancyListViewBuilderWidget(vacancies![index]);
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

  Widget VacancyListViewBuilderWidget(Map<String, dynamic> vacancies) {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
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
                    if (vacancies['job_position'] != null) ...{
                      Text(vacancies['job_position']),
                    },
                  ],
                ),
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
                    if (vacancies['company_name'] != null) ...{
                      Text(vacancies['company_name']),
                    },
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
