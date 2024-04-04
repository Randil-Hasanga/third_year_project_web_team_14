import 'package:flutter/material.dart';
import 'package:jms_desktop/const/constants.dart';

class CreateOfficerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateOfficerPageState();
  }
}

class _CreateOfficerPageState extends State<CreateOfficerPage> {
  double? _deviceWidth, _deviceHeight, _widthXheight;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Registration No'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Position'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Contact No'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality to save officer details
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(
                            fontSize: _deviceWidth! * 0.012,
                            color: selectionColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality to clear the form
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: _deviceWidth! * 0.012,
                            color: selectionColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(
                flex: 2,
                child: SizedBox(
                  width: 1.0,
                ))
          ],
        ),
      ),
    );
  }
}
