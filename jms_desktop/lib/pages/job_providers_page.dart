import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/pages/test.dart';
import 'package:jms_desktop/services/firebase_services.dart';

class JobProviders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JobProvidersState();
  }
}

class _JobProvidersState extends State<JobProviders> {
  FirebaseService? _firebaseService;
  List<Map<String, dynamic>>? jobProviders;
  double? _deviceWidth, _deviceHeight, _widthXheight;
  ScrollController _scrollControllerLeft = ScrollController();

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _loadJobProviders();
  }

  void _loadJobProviders() async {
    List<Map<String, dynamic>>? data =
        await _firebaseService!.getJobProviderData();
    setState(() {
      jobProviders = data;
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
              child: CurrentProvidersListWidget(),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.amber,
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
        left: _deviceWidth! * 0.01, bottom: _deviceHeight! * 0.02),
    padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
    // height: _deviceHeight! * 0.27,
    decoration: BoxDecoration(
      //color: Color.fromARGB(172, 255, 255, 255),
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
                    "Current Job Providers",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _widthXheight! * 0.7,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
        Expanded(
          child: Stack(
            children: [
              Visibility(
                visible: jobProviders == null,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: selectionColor,
                  ),
                ),
              ),
              Visibility(
                visible: jobProviders != null,
                child: Scrollbar(
                  controller: _scrollControllerLeft,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollControllerLeft,
                    shrinkWrap: true,
                    itemCount: jobProviders?.length ?? 0,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return CurrentListViewBuilderWidget(index);
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

  Widget CurrentListViewBuilderWidget(int index) {
    Map<String, dynamic> provider = jobProviders?[index] ?? {};
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
        onTap: (){

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
                if (provider['fname'] != null) ...{
                  Text(provider['fname']),
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:jms_desktop/const/constants.dart';
// class JobProviders extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _JobProvidersState();
//   }
// }

// class _JobProvidersState extends State<JobProviders> {
//   JobProvider? selectedJobProvider;
//   double? _deviceWidth, _deviceHeight, _widthXheight;
//   ScrollController _scrollControllerLeft = ScrollController();

//   onJobProviderTapped(JobProvider jobProvider) {
//     setState(() {
//       selectedJobProvider = jobProvider;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _deviceHeight = MediaQuery.of(context).size.height;
//     _deviceWidth = MediaQuery.of(context).size.width;
//     _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
//     return Scaffold(
//       body: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: CurrentProvidersListWidget(
//                 onTap: onJobProviderTapped,
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: selectedJobProvider == null
//                   ? Center(
//                       child: Text("No job provider selected"),
//                     )
//                   : JobProviderDetails(
//                       jobProvider: selectedJobProvider!,
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget CurrentProvidersListWidget({required Function(JobProvider) onTap}) {
//     return Container(
//       margin: EdgeInsets.only(
//           left: _deviceWidth! * 0.01, bottom: _deviceHeight! * 0.02),
//       padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
//       // height: _deviceHeight! * 0.27,
//       decoration: BoxDecoration(
//         //color: Color.fromARGB(172, 255, 255, 255),
//         color: cardBackgroundColorLayer2,
//         borderRadius: BorderRadius.circular(_widthXheight! * 1),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 5,
//             offset: Offset(0, 0),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     top: _widthXheight! * 0.7, left: _widthXheight! * 0.1),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Current Job Providers",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: _widthXheight! * 0.7,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//           Expanded(
//             child: Scrollbar(
//               controller: _scrollControllerLeft,
//               thumbVisibility: true,
//               child: ListView.builder(
//                 controller: _scrollControllerLeft,
//                 shrinkWrap: true,
//                 itemCount: 10,
//                 scrollDirection: Axis.vertical,
//                 itemBuilder: (context, index) {
//                   return CurrentListViewBuilderWidget(
//                     onTap: onTap,
//                     jobProvider: JobProvider(name: "XYS"),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget CurrentListViewBuilderWidget({
//     required Function(JobProvider) onTap,
//     required JobProvider jobProvider,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(
//         right: _deviceWidth! * 0.0125,
//         top: _deviceHeight! * 0.01,
//       ),
//       child: GestureDetector(
//         onTap: () {
//           onTap(jobProvider);
//         },
//         child: AnimatedContainer(
//           duration: Duration(microseconds: 300),
//           height: _deviceHeight! * 0.08,
//           width: _deviceWidth! * 0.175,
//           decoration: BoxDecoration(
//             color: cardBackgroundColor,
//             borderRadius: BorderRadius.circular(_widthXheight! * 0.66),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 5,
//                 offset: Offset(0, 0),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: _deviceWidth! * 0.001,
//                 vertical: _deviceHeight! * 0.015),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: _deviceWidth! * 0.01,
//                 ),
//                 Icon(
//                   Icons.developer_mode,
//                   size: _widthXheight! * 1,
//                 ),
//                 Text(jobProvider.name)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class JobProviderDetails extends StatelessWidget {
//   final JobProvider jobProvider;

//   JobProviderDetails({required this.jobProvider});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Text(jobProvider.name),
//         ],
//       ),
//     );
//   }
// }


// class JobProvider {
//   String name;
//   // Add other job provider details here

//   JobProvider({required this.name});

//   // Add other job provider methods here
// }