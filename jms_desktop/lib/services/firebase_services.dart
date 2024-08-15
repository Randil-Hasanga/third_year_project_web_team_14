import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USER_COLLECTION = 'users';
const String POSTS_COLLECTION = 'posts';
const String PROVIDER_COLLECTION = 'provider_details';
const String VACANCY_COLLECTION = 'vacancy';
const String SEEKER_COLLECTION = 'profileJobSeeker';
const String CV_COLLECTION = 'CVDetails';
const String NOTIFICATION = 'notifications';
const String APPROVAL_COLLECTION = 'provider_approval_data';

class FirebaseService {
  FirebaseService();
  String? uid;

  Map? currentUser;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String getUid() {
    return uid!;
  }

  User? getCurrentUserChat() {
    return auth.currentUser;
  }

// login the new user in the system
  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredentials = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      // check user creadential details
      if (_userCredentials != null) {
        currentUser = await getUserData(uid: _userCredentials.user!.uid);
        uid = auth.currentUser?.uid;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('password', password);
        print("login successfull");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map?> getUserData({required String uid}) async {
    try {
      DocumentSnapshot _doc =
          await _db.collection(USER_COLLECTION).doc(uid).get();

      if (_doc.exists) {
        return _doc.data() as Map;
      } else {
        return null;
      }
    } catch (e) {
      print("error in get user data : $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentOfficerData() async {
    DocumentSnapshot<Map<String, dynamic>?> _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();

    if (_doc.exists) {
      return _doc.data();
    } else {
      return null;
    }
  }

  // get provider data from db

  Future<List<Map<String, dynamic>>?> getJobProviderData() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('pending', isEqualTo: false)
          .where('disabled', isEqualTo: false)
          .get();

      List<Map<String, dynamic>> jobProviders = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> providerData = doc.data();

        // Check if additional data exists
        DocumentSnapshot additionalDataSnapshot =
            await _db.collection(PROVIDER_COLLECTION).doc(doc.id).get();

        if (additionalDataSnapshot.exists) {
          // Cast the data to Map<String, dynamic>
          Map<String, dynamic> additionalData =
              additionalDataSnapshot.data() as Map<String, dynamic>;
          // Merge additional data with basic data
          providerData.addAll(additionalData);
        }

        jobProviders.add(providerData);
      }

      if (jobProviders.isNotEmpty) {
        return jobProviders;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting provider data : $e");
      return null;
    }
  }

  // get user data from db
  Future<List<Map<String, dynamic>>?> getAllUserData() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('pending', isEqualTo: false)
          .where('disabled', isEqualTo: false)
          .get();

      List<Map<String, dynamic>> users = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> userData = doc.data();

        users.add(userData);
      }

      if (users.isNotEmpty) {
        return users;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user data : $e");
      return null;
    }
  }

  // get current provider count
  Future<int> getProviderCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('pending', isEqualTo: false)
          .where('disabled', isEqualTo: false)
          .get();

      return _querySnapshot.docs.length;
    } catch (e) {
      print("Error getting provider count : $e");
      return 0;
    }
  }

  // get pending approvals data
  Future<List<Map<String, dynamic>>?> getApprovalsData() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('pending', isEqualTo: true)
          .where('disabled', isEqualTo: false)
          .where('isBeingUpdated', isEqualTo: false)
          .get();

      List<Map<String, dynamic>> approvals = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> approvalsData = doc.data();

        // Check if additional data exists
        DocumentSnapshot additionalDataSnapshot =
            await _db.collection(PROVIDER_COLLECTION).doc(doc.id).get();

        if (additionalDataSnapshot.exists) {
          // Cast the data to Map<String, dynamic>
          Map<String, dynamic> additionalData =
              additionalDataSnapshot.data() as Map<String, dynamic>;
          // Merge additional data with basic data
          approvalsData.addAll(additionalData);
        }

        approvals.add(approvalsData);
      }

      if (approvals.isNotEmpty) {
        return approvals;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting provider data : $e");
      return null;
    }
  }

  // get pending approvals data
  Future<int> getApprovalsCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('pending', isEqualTo: true)
          .get();

      return _querySnapshot.docs.length;
    } catch (e) {
      print('Error fetching approvals count: $e');
      return 0;
    }
  }

  // get seeker count
  Future<int> getJobSeekerCount() async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'seeker')
        .get();

    return _querySnapshot.docs.length;
  }

  // getting uid when have email

  // delete user function

  Future<void> disableUser(String uid) async {
    String date = DateTime.now().toString();

    try {
      await _db.collection(USER_COLLECTION).doc(uid).update({
        'disabled': true,
        'disabled_by': this.uid,
        'disabled_date': date,
      });

      print("User Deleted");

      QuerySnapshot querySnapshot = await _db
          .collection(VACANCY_COLLECTION)
          .where('uid', isEqualTo: uid)
          .get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        // Update each document
        await _db
            .collection(VACANCY_COLLECTION)
            .doc(doc.id)
            .update({'disabled': true});
      }
      print("Vacancies Deleted");
    } catch (e) {
      print("Error deleting user : $e");
    }
  }

  Future<List<Map<String, dynamic>>?> getOfficerData() async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'officer')
        .where('disabled', isEqualTo: false)
        .get();

    List<Map<String, dynamic>> officer = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in _querySnapshot.docs) {
      officer.add(doc.data());
    }

    if (officer.isNotEmpty) {
      return officer;
    } else {
      return null;
    }
  }

// Get the officer table count
  Future<int> getOfficerCount() async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'officer')
        .get();

    return _querySnapshot.docs.length;
  }

  // get details about deleted users

  Future<List<Map<String, dynamic>>?> getDeletedUsersData(
      String? dropDownValue) async {
    List<Map<String, dynamic>> userData = [];
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot;
    if (dropDownValue == 'Job Providers') {
      _querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('disabled', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in _querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> providerData = doc.data();

        // Check if additional data exists
        DocumentSnapshot additionalDataSnapshot =
            await _db.collection(PROVIDER_COLLECTION).doc(doc.id).get();

        if (additionalDataSnapshot.exists) {
          // Cast the data to Map<String, dynamic>
          Map<String, dynamic> additionalData =
              additionalDataSnapshot.data() as Map<String, dynamic>;
          // Merge additional data with basic data
          providerData.addAll(additionalData);
        }
        userData.add(providerData);
      }
    } else if (dropDownValue == 'Job Seekers') {
      _querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'seeker')
          .where('disabled', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in _querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> seekerData = doc.data();

        // Check if additional data exists
        DocumentSnapshot additionalDataSnapshot =
            await _db.collection(CV_COLLECTION).doc(doc.id).get();

        if (additionalDataSnapshot.exists) {
          //   // Cast the data to Map<String, dynamic>
          Map<String, dynamic> additionalData =
              additionalDataSnapshot.data() as Map<String, dynamic>;
          //   // Merge additional data with basic data
          seekerData.addAll(additionalData);
        }

        userData.add(seekerData);
      }
    } else if (dropDownValue == 'Officers') {
      _querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'officer')
          .where('disabled', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in _querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> providerData = doc.data();
        userData.add(providerData);
      }
    }

    if (userData.isNotEmpty) {
      return userData;
    } else {
      return null;
    }
  }

  // fetch user data for bulk mail

  Future<List<String>> fetchDataforEmails(
    String reciType,
    String location,
    String industry,
  ) async {
    List<String> providerEmails = [];
    bool foundProvider = false;
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection(USER_COLLECTION).get();

      // Process the user data
      Map<String, Map<String, dynamic>> userDataMap = {};

      for (var user in userSnapshot.docs) {
        userDataMap[user.id] = user.data() as Map<String, dynamic>;
      }

      if (reciType == "Job Providers") {
        QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
            .collection(PROVIDER_COLLECTION)
            .get();

        // Process the provider data
        Map<String, Map<String, dynamic>> providerDataMap = {};

        for (var provider in providerSnapshot.docs) {
          providerDataMap[provider.id] =
              provider.data() as Map<String, dynamic>;
        }

        for (var entry in providerDataMap.entries) {
          String userId = entry.key;
          var providerData = entry.value;
          var userData = userDataMap[userId];

          if (providerData != null &&
              (location == "Any" || providerData['district'] == location) &&
              (industry == "Any" || providerData['industry'] == industry) &&
              userData != null &&
              !(userData['disabled'] ?? false)) {
            var repEmail = providerData['repEmail'];
            if (repEmail != null && repEmail is String && repEmail.isNotEmpty) {
              providerEmails.add(repEmail);
            }
            foundProvider = true;
          }
        }

        if (!foundProvider) {
          print('No providers found with the chosen parameters.');
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return providerEmails;
  }

  //filter get emails for bulk mail service

  Future<List<String>> getEmails(
    String reciType,
    String location,
    String industry,
    String? education,
  ) async {
    List<String> providerEmails = [];
    bool foundProvider = false;
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection(USER_COLLECTION).get();

      // Process the user data
      Map<String, Map<String, dynamic>> userDataMap = {};

      for (var user in userSnapshot.docs) {
        userDataMap[user.id] = user.data() as Map<String, dynamic>;
      }

      if (reciType == "Job Providers") {
        QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
            .collection(PROVIDER_COLLECTION)
            .get();

        // Process the provider data
        Map<String, Map<String, dynamic>> providerDataMap = {};

        for (var provider in providerSnapshot.docs) {
          providerDataMap[provider.id] =
              provider.data() as Map<String, dynamic>;
        }

        for (var entry in providerDataMap.entries) {
          String userId = entry.key;
          var providerData = entry.value;
          var userData = userDataMap[userId];

          if (providerData != null &&
              (location == "Any" || providerData['district'] == location) &&
              (industry == "Any" || providerData['industry'] == industry) &&
              userData != null &&
              !(userData['disabled'] ?? false)) {
            var repEmail = providerData['repEmail'];
            if (repEmail != null && repEmail is String && repEmail.isNotEmpty) {
              providerEmails.add(repEmail);
            }
            foundProvider = true;
          }
        }

        if (!foundProvider) {
          print('No providers found with the chosen parameters.');
        }
      } else if (reciType == "Job Seekers") {
        QuerySnapshot seekerSnapshot =
            await FirebaseFirestore.instance.collection(CV_COLLECTION).get();

        // Process the seeker data
        Map<String, Map<String, dynamic>> seekerDataMap = {};

        for (var seeker in seekerSnapshot.docs) {
          seekerDataMap[seeker.id] = seeker.data() as Map<String, dynamic>;
        }

        for (var entry in seekerDataMap.entries) {
          String userId = entry.key;
          var seekerData = entry.value;
          var userData = userDataMap[userId];

          if (seekerData != null &&
              (location == "Any" || seekerData['district'] == location) &&
              (education == "Any" ||
                  seekerData['EduQalification'] == education) &&
              (industry == "Any" ||
                  seekerData['prefered_industries'].contains(industry)) &&
              userData != null &&
              !(userData['disabled'] ?? false)) {
            var seeker_email = seekerData['cv_email'];
            if (seeker_email != null &&
                seeker_email is String &&
                seeker_email.isNotEmpty) {
              providerEmails.add(seeker_email);
            }
            foundProvider = true;
          }
        }

        if (!foundProvider) {
          print('No providers found with the chosen parameters.');
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return providerEmails;
  }

  // logout functiom
  Future<void> logout() async {
    try {
      await auth.signOut();
      print("Logged out successfully");
    } catch (e) {
      print("Logging out failed : $e");
    }
  }

  // reject and delete pending provider
  Future<void> rejectProvider(String providerId, String? reason) async {
    try {
      DocumentReference docRef = await _db.collection(APPROVAL_COLLECTION).add({
        "uid": providerId,
        "reason": reason,
        "date": DateTime.now(),
        "rejected_by": uid,
      });

      String docId = docRef.id;

      await _db.collection(USER_COLLECTION).doc(providerId).set(
        {
          'isBeingUpdated': true,
          'approval_id': docId,
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      print('Error deleting provider document: $error');
      rethrow;
    }
  }

  // approve provider function
  Future<void> approveProvider(String userId) async {
    try {
      await _db.collection('users').doc(userId).set({
        'pending': false,
        "date": DateTime.now(),
        "approved_by": uid,
      }, SetOptions(merge: true));
      await _db.collection(APPROVAL_COLLECTION).doc().set({
        "uid": userId,
        "date": DateTime.now(),
        "approved_by": uid,
      });
      print('User approved successfully.');
    } catch (error) {
      print('Error approving user: $error');
      rethrow; // Rethrow the error to propagate it up the call stack
    }
  }

//get vacancy data
  Future<List<Map<String, dynamic>>?> getVacancyData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(VACANCY_COLLECTION)
          .where('issue_date', isGreaterThanOrEqualTo: startDate)
          .where('issue_date', isLessThanOrEqualTo: endDate)
          .get();

      List<Map<String, dynamic>> vacancyList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> providerData = doc.data();

        vacancyList.add(providerData);
      }

      if (vacancyList.isNotEmpty) {
        return vacancyList;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting vacancy data : $e");
      return null;
    }
  }

  //get vacancy data from relavant user

  Future<List<Map<String, dynamic>>?> getProviderVacancies(
      String? userId) async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot;

    _querySnapshot = await _db
        .collection(VACANCY_COLLECTION)
        .where('uid', isEqualTo: userId)
        .where('active', isEqualTo: true)
        .get();

    List<Map<String, dynamic>> vacancies = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in _querySnapshot!.docs) {
      vacancies.add(doc.data());
    }

    if (vacancies.isNotEmpty) {
      return vacancies;
    } else {
      return null;
    }
  }

// **********REPORT GENERATION PART*******************************
  // Create month list
  List<DateTime> _generateMonthList() {
    DateTime currentDate = DateTime.now();
    List<DateTime> monthList = [];
    for (int i = 0; i < 12; i++) {
      // Get a DateTime object for the past 12 months
      DateTime pastDate = DateTime(
        currentDate.year,
        currentDate.month - i,
      );
      // Adjust year and month if it goes out of bounds
      while (pastDate.month < 1) {
        pastDate = DateTime(pastDate.year - 1, 12 + pastDate.month);
      }
      DateTime element = DateTime(pastDate.year, pastDate.month);
      monthList.add(element);
    }
    return monthList;
  }

// create month end date
  DateTime _getMonthEndDate(DateTime currentDate) {
    // Determine the first day of the next month
    var firstDayOfNextMonth = (currentDate.month < 12)
        ? DateTime(currentDate.year, currentDate.month + 1, 1)
        : DateTime(currentDate.year + 1, 1, 1);

    // The last day of the current month is one day before the first day of the next month
    var lastDayOfCurrentMonth = firstDayOfNextMonth.subtract(Duration(days: 1));

    return lastDayOfCurrentMonth;
  }

  // provider report
  //get provider detailes in company , use this details in provider report
  Future<List<Map<String, dynamic>>?> getJobProviderReport(int index) async {
    // Map String date type to Date time type
    List<DateTime> monthList = _generateMonthList();
    DateTime startDate = monthList[index];
    DateTime endDate = _getMonthEndDate(startDate);

    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(PROVIDER_COLLECTION)
          .where('created_date', isGreaterThanOrEqualTo: startDate)
          .where('created_date', isLessThanOrEqualTo: endDate)
          .get();

      List<Map<String, dynamic>> providerList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> providerData = doc.data();

        providerList.add(providerData);
      }

      if (providerList.isNotEmpty) {
        // print(providerList);
        return providerList;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting provider data : $e");
      return null;
    }
  }

  // Get avalable provider count in this month
  Future<int> getMonthlyProviderCount(int index) async {
    List<DateTime> monthList = _generateMonthList();
    DateTime startDate = monthList[index];
    DateTime endDate = _getMonthEndDate(startDate);
    try {
      QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
          .collection(PROVIDER_COLLECTION)
          .where('created_date', isGreaterThanOrEqualTo: startDate)
          .where('created_date', isLessThanOrEqualTo: endDate)
          .get();

      return _querySnapshot.docs.length;
    } catch (e) {
      print("Error getting provider count : $e");
      return 0;
    }
  }

  // Seeker report
  //get Seeker detailes in DB , use this details in seeker report
  Future<List<Map<String, dynamic>>?> getSeekerReport(int index) async {
    List<DateTime> monthList = _generateMonthList();
    // Check if index is within the range of monthList
    if (index < 0 || index >= monthList.length) {
      print("Index out of range");
      return null;
    }
    DateTime startDate = monthList[index];
    DateTime endDate = _getMonthEndDate(startDate);
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(SEEKER_COLLECTION)
          .where('registered_date', isGreaterThanOrEqualTo: startDate)
          .where('registered_date', isLessThanOrEqualTo: endDate)
          .get();

      List<Map<String, dynamic>> seekerList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> seekerData = doc.data();

        seekerList.add(seekerData);
      }

      if (seekerList.isNotEmpty) {
        return seekerList;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting seeker data : $e");
      return null;
    }
  }

  //count the seeker in this month
  Future<int> getMonthlySeekerCount(int index) async {
    List<DateTime> monthList = _generateMonthList();
    DateTime startDate = monthList[index];
    DateTime endDate = _getMonthEndDate(startDate);
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(SEEKER_COLLECTION)
          .where('registered_date', isGreaterThanOrEqualTo: startDate)
          .where('registered_date', isLessThanOrEqualTo: endDate)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print("Error getting seeker count : $e");
      return 0;
    }
  }

  // Vacancy report
  //get vacancy detailes in DB , use this details in Vacancy report
  Future<List<Map<String, dynamic>>?> getVacancyReport(int index) async {
    List<DateTime> monthList = _generateMonthList();
    // Check if index is within the range of monthList
    if (index < 0 || index >= monthList.length) {
      print("Index out of range");
      return null;
    }
    DateTime startDate = monthList[index];
    DateTime endDate = _getMonthEndDate(startDate);
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(VACANCY_COLLECTION)
          .where('created_at', isGreaterThanOrEqualTo: startDate)
          .where('created_at', isLessThanOrEqualTo: endDate)
          .get();

      List<Map<String, dynamic>> vacancyList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> vacancyData = doc.data();

        vacancyList.add(vacancyData);
      }

      if (vacancyList.isNotEmpty) {
        print(vacancyList);
        return vacancyList;
      } else {
        print("Empty");
        return null;
      }
    } catch (e) {
      print("Error getting vacancy data : $e");
      return null;
    }
  }

  //count the vacancy in this month
  Future<int> getMonthlyVacancyCount(int index) async {
    List<DateTime> monthList = _generateMonthList();
    DateTime startDate = monthList[index];
    DateTime endDate = _getMonthEndDate(startDate);
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(VACANCY_COLLECTION)
          .where('created_at', isGreaterThanOrEqualTo: startDate)
          .where('created_at', isLessThanOrEqualTo: endDate)
          .get();

      // print(querySnapshot.docs.length);
      return querySnapshot.docs.length;
    } catch (e) {
      print("Error getting vacancy count : $e");
      return 0;
    }
  }

// **************NOTIFICATION SYSTEM****************************************
  //generate notification - job provider side
  Future<List<Map<String, dynamic>>?> getLastHoursJobProvider() async {
    DateTime currentTime = DateTime.now();
    DateTime perviousTime = currentTime.add(Duration(hours: -1));
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(NOTIFICATION)
          .where('type', isEqualTo: 'provider')
          .get();

      List<Map<String, dynamic>> providerList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> providerData = doc.data();

        providerData['name'] = 'username: ${providerData['username']}';

        providerList.add(providerData);
      }
      // Sort providerList by 'registered_date' in descending order
      providerList.sort((a, b) {
        DateTime dateA = a['registered_date'] is Timestamp
            ? (a['registered_date'] as Timestamp).toDate()
            : DateTime.parse(a['registered_date']);
        DateTime dateB = b['registered_date'] is Timestamp
            ? (b['registered_date'] as Timestamp).toDate()
            : DateTime.parse(b['registered_date']);
        return dateB.compareTo(dateA);
      });

      if (providerList.isNotEmpty) {
        return providerList;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting provider notification : $e");
      return null;
    }
  }

  //generate notification - job seeker side
  Future<List<Map<String, dynamic>>?> getLastHoursJobSeeker() async {
    DateTime currentTime = DateTime.now();
    DateTime perviousTime = currentTime.add(Duration(hours: -1));
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(NOTIFICATION)
          .where('type', isEqualTo: 'seeker')
          .get();

      List<Map<String, dynamic>> seekerList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> seekerData = doc.data();

        seekerData['name'] = 'username: ${seekerData['username']}';
        seekerList.add(seekerData);
      }
      // Sort providerList by 'registered_date' in descending order
      seekerList.sort((a, b) {
        DateTime dateA = a['registered_date'] is Timestamp
            ? (a['registered_date'] as Timestamp).toDate()
            : DateTime.parse(a['registered_date']);
        DateTime dateB = b['registered_date'] is Timestamp
            ? (b['registered_date'] as Timestamp).toDate()
            : DateTime.parse(b['registered_date']);
        return dateB.compareTo(dateA);
      });

      if (seekerList.isNotEmpty) {
        return seekerList;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting seeker notification : $e");
      return null;
    }
  }

  //generate notification - job vacancy side
  Future<List<Map<String, dynamic>>?> getLastHoursVacancy() async {
    DateTime currentTime = DateTime.now();
    DateTime perviousTime = currentTime.add(Duration(hours: -1));
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(NOTIFICATION)
          .where('description', isEqualTo: 'Publish New Vacancy')
          .get();

      List<Map<String, dynamic>> vacancyList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> vacancyData = doc.data();

        vacancyData['name'] = 'Company Name: ${vacancyData['company_name']}'
            '\nJob Type: ${vacancyData['job_type']}';
        vacancyList.add(vacancyData);
      }
      // Sort providerList by 'registered_date' in descending order
      vacancyList.sort((a, b) {
        DateTime dateA = a['registered_date'] is Timestamp
            ? (a['registered_date'] as Timestamp).toDate()
            : DateTime.parse(a['registered_date']);
        DateTime dateB = b['registered_date'] is Timestamp
            ? (b['registered_date'] as Timestamp).toDate()
            : DateTime.parse(b['registered_date']);
        return dateB.compareTo(dateA);
      });

      if (vacancyList.isNotEmpty) {
        return vacancyList;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting vacancy notification : $e");
      return null;
    }
  }

  //generate notification - new company side
  Future<List<Map<String, dynamic>>?> getLastHoursNewCompany() async {
    DateTime currentTime = DateTime.now();
    DateTime perviousTime = currentTime.add(Duration(hours: -1));
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(NOTIFICATION)
          .where('description', isEqualTo: 'Add new company')
          .get();

      List<Map<String, dynamic>> companyList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> campanyData = doc.data();
        campanyData['name'] = 'Company Name: ${campanyData['company_name']}'
            '\nOrganization Type: ${campanyData['org_type']}';
        companyList.add(campanyData);
      }
      // Sort providerList by 'registered_date' in descending order
      companyList.sort((a, b) {
        DateTime dateA = a['registered_date'] is Timestamp
            ? (a['registered_date'] as Timestamp).toDate()
            : DateTime.parse(a['registered_date']);
        DateTime dateB = b['registered_date'] is Timestamp
            ? (b['registered_date'] as Timestamp).toDate()
            : DateTime.parse(b['registered_date']);
        return dateB.compareTo(dateA);
      });

      if (companyList.isNotEmpty) {
        return companyList;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting company notification : $e");
      return null;
    }
  }

  // function for restore deleted provider
  Future<bool> restoreProvider(String uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).update({
        'disabled': false,
      });

      QuerySnapshot querySnapshot = await _db
          .collection(VACANCY_COLLECTION)
          .where('uid', isEqualTo: uid)
          .get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        // Update each document
        await _db
            .collection(VACANCY_COLLECTION)
            .doc(doc.id)
            .update({'disabled': false});
      }

      return true;
    } catch (e) {
      print("Error restoring user $e");
      return false;
    }
  }

  // function for restore deleted seeker
  Future<bool> restoreSeeker(String uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).update({
        'disabled': false,
      });

      return true;
    } catch (e) {
      print("Error restoring user $e");
      return false;
    }
  }

  Future<void> updateOfficerProfile(
      String? fname,
      String? lname,
      String? contact,
      String? position,
      String? regNo,
      Uint8List? imageFile,
      String? imageName,
      String? imageLink) async {
    try {
      if (imageFile != null) {
        UploadTask _task =
            _storage.ref('officerProfile/$uid/$imageName').putData(imageFile);

        await _task.then((_snapshot) async {
          String _downloadURL = await _snapshot.ref.getDownloadURL();

          await _db.collection(USER_COLLECTION).doc(uid).set({
            'fname': fname,
            'lname': lname,
            'contact': contact,
            'position': position,
            'reg_no': regNo,
            'profile_image': _downloadURL
          }, SetOptions(merge: true));
        });
      } else {
        if (imageLink != null) {
          await _db.collection(USER_COLLECTION).doc(uid).set({
            'fname': fname,
            'lname': lname,
            'contact': contact,
            'position': position,
            'reg_no': regNo,
            'profile_image': imageLink
          }, SetOptions(merge: true));
        } else {
          await _db.collection(USER_COLLECTION).doc(uid).set({
            'fname': fname,
            'lname': lname,
            'contact': contact,
            'position': position,
            'reg_no': regNo,
          }, SetOptions(merge: true));
        }
      }
      currentUser = await getUserData(uid: uid!);
    } catch (e) {
      print("Error updating officer : $e");
    }
  }
}

//Fetch the CV URL from Firebase Storage:
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
