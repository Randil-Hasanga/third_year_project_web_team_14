import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jms_desktop/pages/PDFViewPage.dart';
import 'package:path_provider/path_provider.dart';

class JobSeeker extends StatefulWidget {
  const JobSeeker({Key? key}) : super(key: key);

  @override
  State<JobSeeker> createState() => _JobSeekerState();
}

class _JobSeekerState extends State<JobSeeker> {
  late Future<List<Map<String, dynamic>>?> _futureJobSeekers;
  Map<String, dynamic>? _selectedJobSeeker;
  Map<String, dynamic>? _cvDetails;
  
  get http => null; // To store CVDetails for selected job seeker

  @override
  void initState() {
    super.initState();
    _futureJobSeekers = getJobSeekerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Seekers'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Panel: User List
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue[100], // Set background color for left panel
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Map<String, dynamic>>?>(
                future: _futureJobSeekers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No job seekers found.'));
                  }

                  // Display List of Job Seekers
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var jobSeeker = snapshot.data![index];
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            _selectedJobSeeker = jobSeeker;
                            _cvDetails = null; // Clear previous CV details
                          });

                          // Load CVDetails for the selected job seeker
                          if (_selectedJobSeeker != null) {
                            String userId = _selectedJobSeeker!['id'];
                            Map<String, dynamic>? cvDetails =
                                await getCVDetails(userId);
                            if (cvDetails != null) {
                              setState(() {
                                _cvDetails = cvDetails;
                              });
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person), // Icon in front of username
                            title: Text(jobSeeker['username'] ?? 'Name not found'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteJobSeeker(jobSeeker['id']); // Assuming 'id' is the document ID
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Right Panel: User Details
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200], // Set background color for right panel
              padding: const EdgeInsets.all(16.0),
              child: _selectedJobSeeker != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Details of Selected Job Seeker',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16.0),
                          _buildSectionContainer(
                            'Basic Data',
                            [
                              _buildDetailRow('Username:', _selectedJobSeeker!['username'] ?? 'Not found'),
                              _buildDetailRow('Email:', _selectedJobSeeker!['email'] ?? 'Not found'),
                            ],
                            Colors.orange[100]!,
                          ),
                          const SizedBox(height: 16.0),
                          _buildSectionContainer(
                            'Personal Details',
                            [
                              _buildDetailRow('Full Name:', _cvDetails?['fullname'] ?? 'Not found'),
                              _buildDetailRow('Gender:', _cvDetails?['gender'] ?? 'Not found'),
                              _buildDetailRow('Home Contact:', _cvDetails?['ContactHome'] ?? 'Not found'),
                              _buildDetailRow('Mobile Contact:', _cvDetails?['contactMobile'] ?? 'Not found'),
                              _buildDetailRow('Address:', _cvDetails?['address'] ?? 'Not found'),
                              _buildDetailRow('Age:', _cvDetails?['age'] != null ? _cvDetails!['age'].toString() : 'Not found'),
                            ],
                            Colors.green[100]!,
                          ),
                          const SizedBox(height: 16.0),
                          _buildAppliedJobsSection(),
                          const SizedBox(height: 16.0),
                          _buildCVViewSection(),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('Select a job seeker to view details'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildSectionContainer(String title, List<Widget> content, Color backgroundColor) {
  return Container(
    margin: EdgeInsets.only(bottom: 16.0),
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        SizedBox(height: 16.0),
        ...content,
      ],
    ),
  );
}

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

Widget _buildCVViewSection() {
  return _cvDetails != null
      ? _buildSectionContainer(
          'CV View',
          [
            ElevatedButton(
              onPressed: () async {
                if (_selectedJobSeeker != null) {
                  String userId = _selectedJobSeeker!['id'];
                  String? cvUrl = await _getCVUrl(userId);
                  if (cvUrl != null) {
                    await _openPDF(context, cvUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('CV not found or unable to load.')),
                    );
                  }
                }
              },
              child: const Text('View CV'),
            ),
          ],
          Colors.purple[100]!,
        )
      : const SizedBox.shrink(); // Hide CV View section if no CV details are loaded
}

Future<void> _openPDF(BuildContext context, String url) async {
  try {
    var response = await http.get(Uri.parse(url));
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(response.bodyBytes);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewPage(filePath: file.path),
      ),
    );
  } catch (e) {
    print('Error opening PDF: $e');
  }
}



Future<String?> _getCVUrl(String userId) async {
  try {
    FirebaseStorage storage = FirebaseStorage.instance;
    String filePath = 'CVs/$userId.pdf';
    String downloadURL = await storage.ref(filePath).getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Error fetching CV URL: $e');
    return null;
  }
}




 Widget _buildAppliedJobsSection() {
  if (_selectedJobSeeker == null) {
    return SizedBox.shrink();
  }

  return FutureBuilder<List<Map<String, dynamic>>>(
    future: getAppliedJobs(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return _buildSectionContainer(
          'Applied Jobs',
          [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('No applied job found.'),
            ),
          ],
          Colors.blue[100]!,
        );
      }




      // Display applied jobs as cards
      return _buildSectionContainer(
        'Applied Jobs',
        snapshot.data!.map((job) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              ///leading: Icon(Icons.work),
              title: Row(
                children: [
                  Icon(Icons.work, size: 18.0),
                  SizedBox(width: 8.0),
                  Text('${job['industry']}, ${job['job_position']}'),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.category, size: 18.0),
                      SizedBox(width: 8.0),
                      Text('${job['job_type']}'),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18.0),
                      SizedBox(width: 8.0),
                      Text('${job['location']}'),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 18.0),
                      SizedBox(width: 8.0),
                      Text('${job['minimum_salary']}'),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Implement action on card tap
                },
              ),
            ),
          );
        }).toList(),
        Colors.blue[100]!,
      );
    },
  );
}

  Future<List<Map<String, dynamic>>> getAppliedJobs() async {
    try {
      // Initialize Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query to fetch vacancies where applied_by contains the current job seeker's ID
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('vacancy')
          .where('applied_by', arrayContains: _selectedJobSeeker!['id'])
          .get();

      List<Map<String, dynamic>> appliedJobs = [];

      // Iterate through each document in the query snapshot
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        appliedJobs.add(doc.data());
      }

      return appliedJobs;
    } catch (e) {
      print("Error getting applied jobs: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>?> getJobSeekerData() async {
    try {
      // Initialize Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query to fetch users where type is 'seeker'
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('users')
          .where('type', isEqualTo: 'seeker')
          .get();

      List<Map<String, dynamic>> jobSeekers = [];

      // Iterate through each document in the query snapshot
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> seekerData = doc.data();
        seekerData['id'] = doc.id; // Add document ID to the data

        // Check if additional data exists in profileJobSeeker collection
        DocumentSnapshot additionalDataSnapshot = await firestore
            .collection('profileJobSeeker')
            .doc(doc.id)
            .get();

        if (additionalDataSnapshot.exists) {
          // Merge additional data with basic data
          seekerData.addAll(additionalDataSnapshot.data() as Map<String, dynamic>);
        }

        jobSeekers.add(seekerData);
      }

      if (jobSeekers.isNotEmpty) {
        return jobSeekers;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting job seeker data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCVDetails(String userId) async {
    try {
      // Initialize Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query to fetch CVDetails document by userId
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await firestore.collection('CVDetails').doc(userId).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Return CV details
        return docSnapshot.data();
      } else {
        print('CVDetails document not found for user ID: $userId');
        return null;
      }
    } catch (e) {
      print('Error getting CVDetails: $e');
      return null;
    }
  }

  void _deleteJobSeeker(String id) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Delete from both 'users' and 'profileJobSeeker' collections
      await firestore.collection('users').doc(id).delete();
      await firestore.collection('profileJobSeeker').doc(id).delete();

      setState(() {
        _futureJobSeekers = getJobSeekerData();
        _selectedJobSeeker = null;
      });
    } catch (e) {
      print("Error deleting job seeker: $e");
    }
  }
}

class JobSeekerDetail extends StatelessWidget {
  final Map<String, dynamic> jobSeeker;

  const JobSeekerDetail({Key? key, required this.jobSeeker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Seeker Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${jobSeeker['username'] ?? 'Name not found'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text('Email: ${jobSeeker['email'] ?? 'Email not found'}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
