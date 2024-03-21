import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jms_desktop/widgets/dashboard_widget.dart';
import 'package:jms_desktop/widgets/profile_details_section.dart';
import 'package:jms_desktop/widgets/side_menu_widget.dart';
import 'package:flutter/src/material/data_table.dart';

class OfficersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OfficersPageStete();
  }
}

class _OfficersPageStete extends State<OfficersPage> {
  double? _deviceWidth, _deviceHeight;

  List<Map<String, String>> officer = [
    {
      'name': 'John Doe',
      'reg_no': '2020690',
      'Position': 'Admin',
      'contact_no': '0712345678',
      'e_mail': 'jobcenter@gmail.com',
      'job_description': 'description12'
    },
    {
      'name': 'Randil Hasanga',
      'reg_no': '2020691',
      'Position': 'Admin',
      'contact_no': '0713847619',
      'e_mail': 'hasanga@gmail.com',
      'job_description': 'description123'
    },
    {
      'name': 'Dinuka Dulanjana',
      'reg_no': '2020692',
      'Position': 'Admin',
      'contact_no': '0712988102',
      'e_mail': 'dinuka@gmail.com',
      'job_description': 'description1234'
    },
    {
      'name': 'Deshani Bandara',
      'reg_no': '2020693',
      'Position': 'Admin',
      'contact_no': '0779915002',
      'e_mail': 'deshani@gmail.com',
      'job_description': 'description12345'
    },
    {
      'name': 'Vinod Kavinda',
      'reg_no': '2020694',
      'Position': 'Admin',
      'contact_no': '0710013248',
      'e_mail': 'kavinda@gmail.com',
      'job_description': 'description123456'
    },
  ];
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              child: SideMenuWidget(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.02),
            child: const VerticalDivider(
              width: 3,
              color: Colors.grey,
            ),
          ),
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    '     Officers Table',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Reg_No')),
                      DataColumn(label: Text('Position')),
                      DataColumn(label: Text('Contact_No')),
                      DataColumn(label: Text('E_mail')),
                      DataColumn(label: Text('Job_Description')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: officer
                        .map(
                          (user) => DataRow(cells: [
                            DataCell(Text(user['name']!)),
                            DataCell(Text(user['reg_no']!)),
                            DataCell(Text(user['Position']!)),
                            DataCell(Text(user['contact_no']!)),
                            DataCell(Text(user['e_mail']!)),
                            DataCell(Text(user['job_description']!)),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      officer.remove(user);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.update),
                                  onPressed: () {
                                    // Handle update action here
                                  },
                                ),
                              ],
                            )),
                          ]),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add'),
                      ),
                      const SizedBox(width: 40.0)
                    ],
                  ),
                ])),
          )
        ],
      )),
    );
  }
}
