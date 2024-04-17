import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';

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
    "NVQ4",
    "NVQ3",
    "Degree",
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
  bool isSeekerSelected = false;

  FirebaseService? _firebaseService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
    return Scaffold(
      body: SafeArea(
        child: Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _mailForm(),
                    _button(),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("To"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _selectedRecepientTypeDropdown(),
                              SizedBox(
                                width: _deviceWidth! * 0.05,
                              ),
                              Visibility(
                                visible: isSeekerSelected,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Education"),
                                    _educationDropdown(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: _deviceWidth! * 0.05,
                              ),
                              Visibility(
                                visible: isSeekerSelected,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Location"),
                                    _locationDropdown(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: _deviceWidth! * 0.02,
                              ),
                              Visibility(
                                visible: isProviderSelected,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Location"),
                                    _locationDropdown(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: _deviceWidth! * 0.02,
                              ),
                              Visibility(
                                visible: isSeekerSelected,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Industry"),
                                    _categoryDropdown(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: _deviceWidth! * 0.02,
                              ),
                              Visibility(
                                visible: isProviderSelected,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Industry"),
                                    _categoryDropdown(),
                                  ],
                                ),
                              ),
                            
                              
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mailForm() {
    return Form(
      key: _mailFormKey,
      child: Column(
        children: [
          _subjectTextField(),
          _messageBody(),
        ],
      ),
    );
  }

  Widget _button() {
    return MaterialButton(
        child: Text("Press"),
        onPressed: () {
          _firebaseService!.fetchData(_recipientTypeDropDownValue!,_locationDropdownValueFull!, _IndustryDropdownValue!);
        });
  }

  Widget _subjectTextField() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Subject",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _messageBody() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8),
      child: TextFormField(
        maxLines: 15,
        minLines: 5,
        decoration: InputDecoration(
          hintText: "Body",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _selectedRecepientTypeDropdown() {
    List<DropdownMenuItem<String>> _items = _recipientType
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
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
              style: TextStyle(
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
              style: TextStyle(
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
              style: TextStyle(
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
