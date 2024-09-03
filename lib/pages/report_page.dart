import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
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

  DateTime? _providerStartDate;
  DateTime? _providerEndDate;
  DateTime? _seekerStartDate;
  DateTime? _seekerEndDate;
  DateTime? _vacancyStartDate;
  DateTime? _vacancyEndDate;

  Future<void> _selectStartDate(BuildContext context, String reportType) async {
    // Select the start date first
    final DateTime? selectedStartDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            hintColor: Colors.black,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    setState(() {
      if (reportType == 'provider') {
        _providerStartDate = selectedStartDate;
      } else if (reportType == 'seeker') {
        _seekerStartDate = selectedStartDate;
      } else {
        _vacancyStartDate = selectedStartDate;
      }
    });
  }

  Future<void> _selectEndDate(BuildContext context, String reportType) async {
    // Select the start date first
    final DateTime? selectedEndDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            hintColor: Colors.black,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    setState(() {
      if (reportType == 'provider') {
        _providerEndDate = selectedEndDate;
      } else if (reportType == 'seeker') {
        _seekerEndDate = selectedEndDate;
      } else {
        _vacancyEndDate = selectedEndDate;
      }
    });
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
                                    FontWeight.w600,
                                  ),
                                  const Divider(),
                                  _richTextWidget!.simpleText(
                                    "Select Date Range",
                                    15,
                                    Colors.black,
                                    FontWeight.w600,
                                  ),
                                  Column(
                                    children: [
                                      _providerStartMonthPicker(),
                                      const SizedBox(height: 2),
                                      _providerEndMonthPicker(),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
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
                                  _richTextWidget!.simpleText(
                                      "Select Date Range",
                                      15,
                                      Colors.black,
                                      FontWeight.w600),
                                  _seekerStartMonthPicker(),
                                  const SizedBox(height: 2),
                                  _seekerEndMonthPicker(),
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
                                  _richTextWidget!.simpleText(
                                      "Select Date Range",
                                      15,
                                      Colors.black,
                                      FontWeight.w600),
                                  _vacancyStartMonthPicker(),
                                  const SizedBox(height: 2),
                                  _vacancyEndMonthPicker(),
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
  Widget _providerStartMonthPicker() {
    return ElevatedButton(
      onPressed: () => _selectStartDate(context, 'provider'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text.rich(
        TextSpan(
          text: 'From: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: _providerStartDate != null
                  ? DateFormat('yyyy-MMM-dd').format(_providerStartDate!)
                  : 'Select Start Date',
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _providerEndMonthPicker() {
    return ElevatedButton(
      onPressed: () => _selectEndDate(context, 'provider'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text.rich(
        TextSpan(
          text: 'To: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: _providerEndDate != null
                  ? DateFormat('yyyy-MMM-dd').format(_providerEndDate!)
                  : 'Select End Date',
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

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

    if (_providerStartDate != null && _providerEndDate != null) {
      List<Map<String, dynamic>>? _data = await _firebaseService!
          .getJobProviderReport(_providerStartDate!, _providerEndDate!);
      List<Map<String, String>>? data = convertToListOfStringMaps(_data);

      final DateFormat dateFormatter = DateFormat('yyyy-MMMM -dd');
      final data_ = {
        'FROM':
            dateFormatter.format(_providerStartDate!), // Format the start date
        'TO': dateFormatter.format(_providerEndDate!), // Format the end date
        'TOTAL COMPANY REGISTRATION':
            data != null ? data.length.toString() : '0',
      };

      final logoBytes = await rootBundle.load('assets/images/logo.jpg');
      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(logoImage, height: 50, width: 50),
                pw.SizedBox(height: 15.0),
                pw.Text(
                  "DISTRICT RAKIYA KENDRAYA - MONTHLY PROGRESS REPORT",
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  "COMPANY DETAILS",
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                if (data == null || data.isEmpty)
                  pw.Text(
                    "No data available.",
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.normal),
                  )
                else ...[
                  _createProviderSummaryTable(data_),
                  pw.SizedBox(height: 20),
                  _createProviderTable(data),
                ],
              ],
            );
          },
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename:
            'Provider_Report_${_providerStartDate!.year}-${_providerStartDate!.month}-${_providerStartDate!.day}_to_${_providerEndDate!.year}-${_providerEndDate!.month}-${_providerEndDate!.day}.pdf',
      );
    } else {
      print("Start date or end date not selected");
    }
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
  Widget _seekerStartMonthPicker() {
    return ElevatedButton(
      onPressed: () => _selectStartDate(context, 'seeker'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text.rich(
        TextSpan(
          text: 'From: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: _seekerStartDate != null
                    ? DateFormat('yyyy-MMM-dd').format(_seekerStartDate!)
                    : 'Select Start Date',
                style: const TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _seekerEndMonthPicker() {
    return ElevatedButton(
      onPressed: () => _selectEndDate(context, 'seeker'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text.rich(
        TextSpan(
          text: 'To: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: _seekerEndDate != null
                    ? DateFormat('yyyy-MMM-dd').format(_seekerEndDate!)
                    : 'Select End Date',
                style: const TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }

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
    if (_seekerStartDate != null && _seekerEndDate != null) {
      List<Map<String, dynamic>>? _data = await _firebaseService!
          .getSeekerReport(_seekerStartDate!, _seekerEndDate!);
      List<Map<String, String>>? data = convertToListOfStringMaps(_data);

      final DateFormat dateFormatter = DateFormat('yyyy-MMMM -dd');
      final data_ = {
        'FROM':
            dateFormatter.format(_seekerStartDate!), // Format the start date
        'TO': dateFormatter.format(_seekerEndDate!), // Format the end date
        'TOTAL SEEKERS REGISTRATION':
            data != null ? data.length.toString() : '0',
      };

      // Load the logo image from assets
      final logoBytes = await rootBundle.load('assets/images/logo.jpg');
      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

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
        filename:
            'Seeker_${_seekerStartDate!.year}-${_seekerStartDate!.month}-${_seekerStartDate!.day}_to_${_seekerEndDate!.year}-${_providerEndDate!.month}-${_seekerEndDate!.day}.pdf',
      );
    }
  }

  //-----Vacancy Report-------------
  Widget _vacancyStartMonthPicker() {
    return ElevatedButton(
      onPressed: () => _selectStartDate(context, 'vacancy'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text.rich(
        TextSpan(
          text: 'From: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: _vacancyStartDate != null
                    ? DateFormat('yyyy-MMM-dd').format(_vacancyStartDate!)
                    : 'Select Start Date',
                style: const TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _vacancyEndMonthPicker() {
    return ElevatedButton(
      onPressed: () => _selectEndDate(context, 'vacancy'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text.rich(
        TextSpan(
          text: 'To: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: _vacancyEndDate != null
                    ? DateFormat('yyyy-MMM-dd').format(_vacancyEndDate!)
                    : 'Select End Date',
                style: const TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }

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

    if (_vacancyStartDate != null && _vacancyEndDate != null) {
      List<Map<String, dynamic>>? _data = await _firebaseService!
          .getVacancyReport(_vacancyStartDate!, _vacancyEndDate!);
      List<Map<String, String>>? data = convertToListOfStringMaps(_data);

      final DateFormat dateFormatter = DateFormat('yyyy-MMMM -dd');
      final data_ = {
        'FROM':
            dateFormatter.format(_vacancyStartDate!), // Format the start date
        'TO': dateFormatter.format(_vacancyEndDate!), // Format the end date
        'TOTAL VACANCY REGISTRATION':
            data != null ? data.length.toString() : '0',
      };

      // Load the logo image from assets
      final logoBytes = await rootBundle.load('assets/images/logo.jpg');
      final logoImage = pw.MemoryImage(
        logoBytes.buffer.asUint8List(),
      );

      //get VACANCY list from DB

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
        filename:
            'Vacancy_${_vacancyStartDate!.year}-${_vacancyStartDate!.month}-${_vacancyStartDate!.day}_to_${_vacancyEndDate!.year}-${_vacancyEndDate!.month}-${_vacancyEndDate!.day}.pdf',
      );
    } else {
      print("Start date or end date not selected");
    }
  }
}
