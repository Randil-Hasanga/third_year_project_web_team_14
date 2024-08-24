import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/richText.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  bool _isLoading = false;
  bool _isSending = false;

  late final List<String> _monthList = _generateMonthList();

  late String _providerMonth = _genarateFirstMonth();
  late String _seekerMonth = _genarateFirstMonth();
  late String _vacancyMonth = _genarateFirstMonth();

  String _genarateFirstMonth() {
    String firstMonth;
    if (_monthList.isNotEmpty) {
      firstMonth = _monthList[0]; // Access the first element safely
    } else {
      firstMonth = 'List is empty'; // Default value if the list is empty
    }
    return firstMonth;
  }

  Future<void> _selectDate(BuildContext context, String reportType) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            hintColor: Colors.black,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final monthName = _monthList[selectedDate.month - 1];
      setState(() {
        if (reportType == 'provider') {
          _providerMonth = monthName;
        } else if (reportType == 'seeker') {
          _seekerMonth = monthName;
        } else if (reportType == 'vacancy') {
          _vacancyMonth = monthName;
        }
      });
    }
  }

  //generate month list
  List<String> _generateMonthList() {
    DateTime currentDate = DateTime.now();
    List<String> monthList = [];

    // Map for month names
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    for (int i = 0; i < 12; i++) {
      // Get a Year and Month for the past 12 months
      DateTime pastDate = DateTime(
        currentDate.year,
        currentDate.month -
            i, //one month will be deducted from the relevent month
      );

      // Adjust year and month if it goes out of bounds
      while (pastDate.month < 1) {
        pastDate = DateTime(pastDate.year - 1, 12 + pastDate.month);
      }

      String year = pastDate.year.toString();
      String monthName =
          monthNames[pastDate.month - 1]; // Get month name from map

      String element = '$monthName $year'; // Using month name
      monthList.add(element);
    }

    return monthList;
  }

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
  }

  pw.Widget _createProviderSummaryTable(Map<String, String> data) {
    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start, // Aligns text to the start (left)
      children: [
        // Display "DISTRICT: MATARA" only once
        pw.Row(
          children: [
            pw.Text(
              'DISTRICT: MATARA',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),

        // Display the rest of the data
        ...data.entries.map((entry) {
          return pw.Row(
            children: [
              pw.Text(
                '${entry.key}:', // Key (field name)
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(width: 10), // Space between key and value
              pw.Text(entry.value), // Value (field data)
            ],
          );
        }).toList(),
      ],
    );
  }

  //feach the provider data and map the details
  pw.Widget _createProviderTable(List<Map<String, String>> data) {
    // ignore: deprecated_member_use
    return pw.Table.fromTextArray(
      // Setting the style for the table headers
      headerStyle: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold, // Make the headers bold
      ),
      // Setting the style for the table body cells
      cellStyle: const pw.TextStyle(
        fontSize: 8,
      ),
      cellAlignment: pw.Alignment.centerLeft, // Align text in cells to the left
      border: pw.TableBorder.all(), // Adding borders to the table
      data: <List<String>>[
        [
          'Campany Name',
          'Address',
          'Contact Parson Name',
          'Position',
          'Contact No',
          'Contact Person Email'
        ], // Table headers
        for (var row in data)
          [
            row['company_name']!,
            row['company_address']!,
            row['repName']!,
            row['repPost']!,
            row['repMobile']!,
            row['repEmail']!
          ],
      ],
    );
  }

  //
  pw.Widget _createSeekerSummaryTable(Map<String, String> data) {
    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start, // Aligns text to the start (left)
      children: [
        // Display "DISTRICT: MATARA" only once
        pw.Row(
          children: [
            pw.Text(
              'DISTRICT: MATARA',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        // Display the rest of the data
        ...data.entries.map((entry) {
          return pw.Row(
            children: [
              pw.Text(
                '${entry.key}:', // Key (field name)
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(width: 10), // Space between key and value
              pw.Text(entry.value), // Value (field data)
            ],
          );
        }).toList(),
      ],
    );
  }

  //feach the seeker data and map the details
  pw.Widget _createSeekerTable(List<Map<String, String>> data) {
    // Convert null values to "N/A"
    List<List<String>> tableData = [
      [
        'Name of the Job Seeker',
        'Address',
        'Gender',
        'Contact No',
        'Name of the Placed Company',
        'Job Position',
        'Company Contact'
      ], // Table headers
    ];

    for (var row in data) {
      tableData.add([
        row['fullname'] ?? 'N/A',
        row['address'] ?? 'N/A',
        row['gender'] ?? 'N/A',
        row['contact'] ?? 'N/A',
        row['placed_company_name'] ?? 'N/A',
        row['job_position'] ?? 'N/A',
        row['company_contact'] ?? 'N/A',
      ]);
    }

    // ignore: deprecated_member_use
    return pw.Table.fromTextArray(
      // Setting the style for the table headers
      headerStyle: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold, // Make the headers bold
      ),
      // Setting the style for the table body cells
      cellStyle: const pw.TextStyle(
        fontSize: 8,
      ),
      cellAlignment: pw.Alignment.centerLeft, // Align text in cells to the left
      border: pw.TableBorder.all(), // Adding borders to the table
      data: tableData,
    );
  }

  pw.Widget _createVacancySummaryTable(Map<String, String> data) {
    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start, // Aligns text to the start (left)
      children: [
        // Display "DISTRICT: MATARA" only once
        pw.Row(
          children: [
            pw.Text(
              'DISTRICT: MATARA',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),

        // Display the rest of the data
        ...data.entries.map((entry) {
          return pw.Row(
            children: [
              pw.Text(
                '${entry.key}:', // Key (field name)
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(width: 10), // Space between key and value
              pw.Text(entry.value), // Value (field data)
            ],
          );
        }).toList(),
      ],
    );
  }

  //feach the vacancy data and map the details
  pw.Widget _createVacancyTable(List<Map<String, String>> data) {
    // ignore: deprecated_member_use
    return pw.Table.fromTextArray(
      // Setting the style for the table headers
      headerStyle: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold, // Make the headers bold
      ),
      // Setting the style for the table body cells
      cellStyle: const pw.TextStyle(
        fontSize: 8,
      ),
      cellAlignment: pw.Alignment.centerLeft, // Align text in cells to the left
      border: pw.TableBorder.all(), // Adding borders to the table
      data: <List<String>>[
        [
          'Campany',
          'Address',
          'Contact No',
          'Contact Parson Name',
          'Position',
          'Vacancy Type',
          'Salary Level',
          'No:of'
        ], // Table headers
        for (var row in data)
          [
            row['company_name'] ?? 'N/A',
            row['address'] ?? 'N/A',
            row['contactNo'] ?? 'N/A',
            row['applied_by'] ?? 'N/A',
            row['job_position'] ?? 'N/A',
            row['job_type'] ?? 'N/A',
            row['minimum_salary'] ?? 'N/A',
            row['noOf'] ?? 'N/A',
          ],
      ],
    );
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
                        margin: EdgeInsets.only(
                          left: _deviceWidth! * 0.01,
                          bottom: _deviceHeight! * 0.02,
                          top: _deviceHeight! * 0.02,
                          right: _deviceWidth! * 0.01,
                        ),
                        padding: EdgeInsets.only(
                            top: _widthXheight! * 0.7,
                            left: _widthXheight! * 0.1),
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
                                  _richTextWidget!.simpleText(
                                      "Job Providers Report",
                                      20,
                                      Colors.black,
                                      FontWeight.w600),
                                  const Divider(),
                                  _richTextWidget!.simpleText("Select Month",
                                      15, Colors.black, FontWeight.w600),
                                  _providerMonthPicker(),
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: SizedBox(
                                width: 5,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _providerGenerateButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: _deviceHeight! * 0.02),
                      Container(
                        margin: EdgeInsets.only(
                          left: _deviceWidth! * 0.01,
                          bottom: _deviceHeight! * 0.02,
                          top: _deviceHeight! * 0.02,
                          right: _deviceWidth! * 0.01,
                        ),
                        padding: EdgeInsets.only(
                            top: _widthXheight! * 0.7,
                            left: _widthXheight! * 0.1),
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
                                  _richTextWidget!.simpleText(
                                      "Job Seekers Report",
                                      20,
                                      Colors.black,
                                      FontWeight.w600),
                                  const Divider(),
                                  _richTextWidget!.simpleText("Select Month",
                                      15, Colors.black, FontWeight.w600),
                                  _seekerMonthPicker(),
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: SizedBox(
                                width: 5,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _seekerGenerateButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: _deviceHeight! * 0.02),
                      Container(
                        margin: EdgeInsets.only(
                          left: _deviceWidth! * 0.01,
                          bottom: _deviceHeight! * 0.02,
                          top: _deviceHeight! * 0.02,
                          right: _deviceWidth! * 0.01,
                        ),
                        padding: EdgeInsets.only(
                            top: _widthXheight! * 0.7,
                            left: _widthXheight! * 0.1),
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
                                  _richTextWidget!.simpleText(
                                      "Job Vacancy Report",
                                      20,
                                      Colors.black,
                                      FontWeight.w600),
                                  const Divider(),
                                  _richTextWidget!.simpleText("Select Month",
                                      15, Colors.black, FontWeight.w600),
                                  _vacancyMonthPicker(),
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: SizedBox(
                                width: 5,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _vacancyGenerateButton(),
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

//----Provider report-----------------
  // Widget _providerMonthList() {
  //   List<DropdownMenuItem<String>> _items = _monthList
  //       .map(
  //         (e) => DropdownMenuItem(
  //           value: e,
  //           child: Text(
  //             e,
  //             style: const TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //       )
  //       .toList();

  //   return Center(
  //     child: DropdownButton(
  //       value: _providerMonth,
  //       items: _items,
  //       onChanged: (_value) {
  //         setState(() {
  //           _providerMonth = _value!;
  //         });
  //       },
  //       dropdownColor: backgroundColor3,
  //       borderRadius: BorderRadius.circular(10),
  //       iconSize: 20,
  //       icon: const Icon(
  //         Icons.arrow_drop_down_sharp,
  //         color: Colors.black,
  //       ),
  //       underline: Container(),
  //     ),
  //   );
  // }

  Widget _providerGenerateButton() {
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
            onPressed: _isLoading ? null : _generateProviderPdf,
            child: const Row(
              children: [
                Text(
                  "Genarate PDF",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.send),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _generateProviderPdf() async {
    final pdf = pw.Document();
    int index = _monthList.indexOf(_providerMonth);
    int _providerCount = await _firebaseService!.getMonthlyProviderCount(index);
    final data_ = {
      'MONTH': _providerMonth,
      'TOTAL COMPANY REGISTRATION': _providerCount.toString(),
    };
    // Load the logo image from assets
    final logoBytes = await rootBundle.load('assets/images/logo.jpg');
    final logoImage = pw.MemoryImage(
      logoBytes.buffer.asUint8List(),
    );

    //get provider list from DB
    // get String month list index,
    List<Map<String, String>>? data;
    List<Map<String, dynamic>>? _data =
        await _firebaseService!.getJobProviderReport(index);
    data = convertToListOfStringMaps(_data);
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Add the logo at the top
              pw.Image(logoImage, height: 50, width: 50),
              pw.SizedBox(height: 15.0),
              // Title at the top
              pw.Text(
                "DISTRICT RAKIYA KENDRAYA - MONTHLY PROGRESS REPORT",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "COMPANY DETAILS",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              // Spacer to create some space between the title and the content
              pw.SizedBox(height: 20),
              if (data == null ||
                  data.isEmpty) // Check if data is empty or null
                pw.Text(
                  "No data available.",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.normal,
                  ),
                )
              else ...[
                // If data is not empty, render the data tables
                _createProviderSummaryTable(
                    data_), // Your function to create summary
                pw.SizedBox(height: 20),
                _createProviderTable(
                    data), // Your function to create the detailed table
              ],
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Provider_$_providerMonth.pdf',
    );
  }

  List<Map<String, String>>? convertToListOfStringMaps(
      List<Map<String, dynamic>>? dynamicList) {
    if (dynamicList == null) {
      return null; // Handle the null case if the input list is nullable
    }

    return dynamicList.map((dynamicMap) {
      Map<String, String> stringMap = {};

      dynamicMap.forEach((key, value) {
        stringMap[key] = value?.toString() ??
            'null'; // Convert value to string, handle nulls
      });

      return stringMap;
    }).toList();
  }

  // Seeker reprot*********************************

  // Widget _seekerMonthList() {
  //   List<DropdownMenuItem<String>> _items = _monthList
  //       .map(
  //         (e) => DropdownMenuItem(
  //           value: e,
  //           child: Text(
  //             e,
  //             style: const TextStyle(
  //               color: Colors.black,
  //               //fontSize: _widthXheight! * 0.7,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //       )
  //       .toList();

  //   return Center(
  //     child: DropdownButton(
  //       value: _seekerMonth,
  //       items: _items,
  //       onChanged: (_value) {
  //         setState(() {
  //           _seekerMonth = _value!;
  //         });
  //       },
  //       dropdownColor: backgroundColor3,
  //       borderRadius: BorderRadius.circular(10),
  //       iconSize: 20,
  //       icon: const Icon(
  //         Icons.arrow_drop_down_sharp,
  //         color: Colors.black,
  //       ),
  //       underline: Container(),
  //     ),
  //   );
  // }

  Widget _seekerGenerateButton() {
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
            onPressed: _isLoading ? null : _generateSeekerPdf,
            child: const Row(
              children: [
                Text(
                  "Genarate PDF",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.send),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _generateSeekerPdf() async {
    final pdf = pw.Document();
    int index = _monthList.indexOf(_seekerMonth);
    int seekerCount = await _firebaseService!.getMonthlySeekerCount(index);
    final data_ = {
      'MONTH': _seekerMonth,
      'TOTAL SEEKERS REGISTRATION': seekerCount.toString(), //modify this after
    };

    // Load the logo image from assets
    final logoBytes = await rootBundle.load('assets/images/logo.jpg');
    final logoImage = pw.MemoryImage(
      logoBytes.buffer.asUint8List(),
    );

    List<Map<String, String>>? data;
    List<Map<String, dynamic>>? _data =
        await _firebaseService!.getSeekerReport(index);
    data = convertToListOfStringMaps(_data);
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Add the logo at the top
              pw.Image(logoImage, height: 50, width: 50),
              pw.SizedBox(height: 15.0),
              // Title at the top
              pw.Text(
                "DISTRICT RAKIYA KENDRAYA - MONTHLY PROGRESS REPORT",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "SEEKER DETAILS AND SELECTED COMPANY DETAILS",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              // Spacer to create some space between the title and the content
              pw.SizedBox(height: 20),
              if (data == null ||
                  data.isEmpty) // Check if data is empty or null
                pw.Text(
                  "No data available.",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.normal,
                  ),
                )
              else ...[
                // If data is not empty, render the data tables
                _createSeekerSummaryTable(
                    data_), // Your function to create summary
                pw.SizedBox(height: 20),
                _createSeekerTable(
                    data), // Your function to create the detailed table
              ],
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Seeker_$_seekerMonth.pdf',
    );
  }

  //-----Vacancy Report-------------

  // Widget _vacancyMonthList() {
  //   List<DropdownMenuItem<String>> _items = _monthList
  //       .map(
  //         (e) => DropdownMenuItem(
  //           value: e,
  //           child: Text(
  //             e,
  //             style: const TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //       )
  //       .toList();

  //   return Center(
  //     child: DropdownButton(
  //       value: _vacancyMonth,
  //       items: _items,
  //       onChanged: (_value) {
  //         setState(() {
  //           _vacancyMonth = _value!;
  //         });
  //       },
  //       dropdownColor: backgroundColor3,
  //       borderRadius: BorderRadius.circular(10),
  //       iconSize: 20,
  //       icon: const Icon(
  //         Icons.arrow_drop_down_sharp,
  //         color: Colors.black,
  //       ),
  //       underline: Container(),
  //     ),
  //   );
  // }

  Widget _vacancyGenerateButton() {
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
            onPressed: _isLoading ? null : _generateVacancyPdf,
            child: const Row(
              children: [
                Text(
                  "Genarate PDF",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.send),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _generateVacancyPdf() async {
    final pdf = pw.Document();
    int index = _monthList.indexOf(_vacancyMonth);
    int _vacancyCount = await _firebaseService!.getMonthlyVacancyCount(index);
    final data_ = {
      'MONTH': _vacancyMonth,
      'TOTAL VANANCY REGISTRATION': _vacancyCount.toString(),
    };
    // Load the logo image from assets
    final logoBytes = await rootBundle.load('assets/images/logo.jpg');
    final logoImage = pw.MemoryImage(
      logoBytes.buffer.asUint8List(),
    );

    //get VACANCY list from DB
    // get String month list index,
    List<Map<String, String>>? data;
    List<Map<String, dynamic>>? _data =
        await _firebaseService!.getVacancyReport(index);
    data = convertToListOfStringMaps(_data);
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Add the logo at the top
              pw.Image(logoImage, height: 50, width: 50),
              pw.SizedBox(height: 15.0),
              // Title at the top
              pw.Text(
                "DISTRICT RAKIYA KENDRAYA - MONTHLY PROGRESS REPORT",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "COMPANY AND VACANCIES DETAILS",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              // Spacer to create some space between the title and the content
              pw.SizedBox(height: 20),
              if (data == null ||
                  data.isEmpty) // Check if data is empty or null
                pw.Text(
                  "No data available.",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.normal,
                  ),
                )
              else ...[
                // If data is not empty, render the data tables
                _createVacancySummaryTable(
                    data_), // Your function to create summary
                pw.SizedBox(height: 20),
                _createVacancyTable(
                    data), // Your function to create the detailed table
              ],
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Vacancy_$_vacancyMonth.pdf',
    );
  }

  Widget _providerMonthPicker() {
    return ElevatedButton(
      onPressed: () => _selectDate(context, 'provider'),
      child: Text('Select Month: $_providerMonth'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _seekerMonthPicker() {
    return ElevatedButton(
      onPressed: () => _selectDate(context, 'seeker'),
      child: Text('Select Month: $_seekerMonth'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _vacancyMonthPicker() {
    return ElevatedButton(
      onPressed: () => _selectDate(context, 'vacancy'),
      child: Text('Select Month: $_vacancyMonth'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
