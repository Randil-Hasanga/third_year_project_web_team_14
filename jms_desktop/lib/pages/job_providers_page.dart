import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/Search_bar_widget.dart';
import 'package:jms_desktop/widgets/richText.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;
RichTextWidget? _richTextWidget;

class JobProviders extends StatefulWidget {
  const JobProviders({super.key});

  @override
  State<StatefulWidget> createState() {
    return _JobProvidersState();
  }
}

class _JobProvidersState extends State<JobProviders> {
  FirebaseService? _firebaseService;
  SearchBarWidget? _searchBarWidget;
  final TextEditingController _searchController =
      TextEditingController(); // search fuction
  List<Map<String, dynamic>>? jobProviders;
  List<Map<String, dynamic>>? filteredJobProviders;

  final ScrollController _scrollControllerLeft = ScrollController();
  bool _isDetailsVisible = false;
  Map<String, dynamic>? _selectedProvider;
  bool _showLoader = true;
  bool _showNoProvidersFound = false;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
    _searchBarWidget = GetIt.instance.get<SearchBarWidget>();
    _loadJobProviders();
    // Add listener to search controller
    _searchController.addListener(_filterJobProviders); // search fuction
  }

  // search fuction
  void _filterJobProviders() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredJobProviders = jobProviders?.where((provider) {
        // Check if company_name exists and contains the query
        if (provider['company_name'] != null &&
            provider['company_name'].toLowerCase().contains(query)) {
          return true;
        }
        // If company_name doesn't exist, check username
        if (provider['username'] != null &&
            provider['username'].toLowerCase().contains(query)) {
          return true;
        }
        return false;
      }).toList();
    });
  }

  void _loadJobProviders() async {
    try {
      List<Map<String, dynamic>>? data =
          await _firebaseService!.getJobProviderData();

      if (mounted) {
        setState(() {
          jobProviders = data;
          filteredJobProviders = data;
          _showLoader = false;
          _showNoProvidersFound = data == null || data.isEmpty;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
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
            Expanded(
              flex: 1,
              child: CurrentProvidersListWidget(),
            ),
            Expanded(
              flex: 2,
              child: _isDetailsVisible
                  ? SelectedProviderDetailsWidget(_selectedProvider)
                  : Center(
                      child: _richTextWidget!.simpleText(
                          "Select a provider to view details",
                          18,
                          Colors.black,
                          null),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget CurrentProvidersListWidget() {
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
                  Icon(
                    Icons.handshake,
                    size: _widthXheight! * 1.5,
                  ),
                  SizedBox(width: _deviceWidth! * 0.01),
                  _richTextWidget!.simpleText(
                      "Current Providers", 25, Colors.black, FontWeight.w600),
                ],
              ),
            ),
          ),
          _searchBarWidget!.searchBar(_searchController, "Search Provider..."),
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
                        _richTextWidget!
                            .simpleText("Loading...", null, Colors.black, null),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !(filteredJobProviders == null ||
                      filteredJobProviders!.isEmpty),
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: (filteredJobProviders ?? []).length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return CurrentListViewBuilderWidget(
                            (filteredJobProviders ?? [])[index]);
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _showNoProvidersFound,
                  child: Center(
                    child: _richTextWidget!.simpleText(
                        "No job providers found.", null, Colors.black, null),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget CurrentListViewBuilderWidget(Map<String, dynamic> provider) {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isDetailsVisible = true;
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
                    if (provider['company_name'] != null) ...{
                      _richTextWidget!.simpleText(
                          provider['company_name'], null, Colors.black, null),
                    } else ...{
                      _richTextWidget!.simpleText(
                          provider['username'], null, Colors.black, null),
                    },
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        String? uid = await _firebaseService!
                            .getUidByEmail(provider['email']);
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
          title: Row(
            children: [
              const Icon(
                Icons.warning,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              _richTextWidget!
                  .simpleText("Delete Job Provider", null, Colors.red, null),
            ],
          ),
          content: _richTextWidget!.simpleText(
              "Are you sure you want to delete this job provider?",
              null,
              Colors.black87,
              null),
          actions: [
            TextButton(
              onPressed: () async {
                await _firebaseService!.deleteUser(uid);
                _loadJobProviders();
                Navigator.pop(context);
              },
              child: _richTextWidget!.simpleText("Yes", null, Colors.red, null),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  _richTextWidget!.simpleText("No", null, Colors.black, null),
            ),
          ],
        );
      },
    );
  }
}

class SelectedProviderDetailsWidget extends StatefulWidget {
  final Map<String, dynamic>? provider;

  const SelectedProviderDetailsWidget(this.provider, {super.key});

  @override
  State<SelectedProviderDetailsWidget> createState() =>
      _SelectedProviderDetailsWidgetState();
}

class _SelectedProviderDetailsWidgetState
    extends State<SelectedProviderDetailsWidget> {
  @override
  void initState() {
    super.initState();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _richTextWidget!.simpleText("Details of Selected Job Provider",
                    _widthXheight! * 0.9, Colors.black, FontWeight.bold),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _richTextWidget!.simpleText("Basic data", 20,
                                      Colors.black, FontWeight.w600),
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _richTextWidget!.simpleText(
                                        "Contact person details",
                                        20,
                                        Colors.black,
                                        FontWeight.w600),
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
                      SizedBox(
                          width: _deviceHeight! *
                              0.02), // Add space between the containers
          
                      if (widget.provider!['company_name'] != null) ...{
                        Expanded(
                          child: Column(
                            children: [
                              if (widget.provider!['logo'] != null) ...{
                                _logo(),
                              },
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
                                    _richTextWidget!.simpleText("Company details", 20,
                                        Colors.black, FontWeight.w600),
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
          ),
        ],
      ),
    );
  }

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
          widget.provider!['logo'], //TODO: profile pic
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
