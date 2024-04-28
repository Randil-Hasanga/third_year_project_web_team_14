import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = 'users';
const String POSTS_COLLECTION = 'posts';
const String PROVIDER_COLLECTION = 'provider_details';
const String VACANCY_COLLECTION = 'vacancy';
const String SEEKER_COLLECTION = 'profileJobSeeker';

class FirebaseService {
  FirebaseService();

  Map? currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_userCredentials != null) {
        currentUser = await _getUserData(uid: _userCredentials.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map?> _getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();

    if (_doc.exists) {
      return _doc.data() as Map;
    } else {
      return null;
    }
  }

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

  Future<List<Map<String, dynamic>>?> getApprovalsData() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('pending', isEqualTo: true)
          .where('disabled', isEqualTo: false)
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

  Future<int> getJobSeekerCount() async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'seeker')
        .get();

    return _querySnapshot.docs.length;
  }

  Future<String?> getUidByEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection('users').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        print('User with email $email not found.');
        return null;
      }
    } catch (e) {
      print('Error getting UID by email: $e');
      return null;
    }
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection(USER_COLLECTION).doc(uid).update({
      'disabled': true,
    });
  }

  Future<List<Map<String, dynamic>>?> getOfficerData() async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'officer')
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

  Future<int> getOfficerCount() async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'officer')
        .get();

    return _querySnapshot.docs.length;
  }

  Future<List<Map<String, dynamic>>?> getDeletedUsersData(
      String? dropDownValue) async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot;
    if (dropDownValue == 'Job Providers') {
      _querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('disabled', isEqualTo: true)
          .get();
    } else if (dropDownValue == 'Job Seekers') {
      _querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'seeker')
          .where('disabled', isEqualTo: true)
          .get();
    } else if (dropDownValue == 'All') {
      _querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('disabled', isEqualTo: true)
          .get();
    }

    List<Map<String, dynamic>> users = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in _querySnapshot!.docs) {
      users.add(doc.data());
    }

    if (users.isNotEmpty) {
      return users;
    } else {
      return null;
    }
  }

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
            print('Provider data: $providerData');
            print('User data: $userData');
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
            print('Provider data: $providerData');
            print('User data: $userData');
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

  Future<void> logout() async {
    try {
      await _auth.signOut();
      print("Logged out successfully");
    } catch (e) {
      print("Logging out failed : $e");
    }
  }

  Future<void> deleteProvider(String providerId) async {
    try {
      await _db.collection('provider_details').doc(providerId).delete();
    } catch (error) {
      print('Error deleting provider document: $error');
      throw error;
    }
  }

  Future<void> approveUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).update({'pending': false});
      print('User approved successfully.');
    } catch (error) {
      print('Error approving user: $error');
      throw error; // Rethrow the error to propagate it up the call stack
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

        // Check if additional data exists
        DocumentSnapshot additionalDataSnapshot =
            await _db.collection(VACANCY_COLLECTION).doc(doc.id).get();

        if (additionalDataSnapshot.exists) {
          // Cast the data to Map<String, dynamic>
          Map<String, dynamic> additionalData =
              additionalDataSnapshot.data() as Map<String, dynamic>;
          // Merge additional data with basic data
          providerData.addAll(additionalData);
        }

        vacancyList.add(providerData);
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

  //get vacancy data from relavant user

  Future<List<Map<String, dynamic>>?> getProviderVacancies(
      String? userId) async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot;

    _querySnapshot = await _db
        .collection(VACANCY_COLLECTION)
        .where('uid', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> vacancies = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in _querySnapshot!.docs) {
      vacancies.add(doc.data());
    }

    if (vacancies.isNotEmpty) {
      print(vacancies);
      return vacancies;
    } else {
      print("no vacancies");
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

        providerList.add(providerData);
      }

      if (providerList.isNotEmpty) {
        // print(providerList);
        return providerList;
      } else {
        print("Empty");
        return null;
      }
    } catch (e) {
      print("Error getting provider data : $e");
      return null;
    }
  }

  // Get avalable provider count in this month
  Future<int> getMonthlyProviderCount() async {
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

  // seeker report
  //get Seeker detailes in DB , use this details in seeker report
  Future<List<Map<String, dynamic>>?> getSeekerReport() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(SEEKER_COLLECTION)
          // .where('issue_date', isGreaterThanOrEqualTo: startDate)
          // .where('issue_date', isLessThanOrEqualTo: endDate)
          .get();

      List<Map<String, dynamic>> seekerList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> seekerData = doc.data();

        // Check if additional data exists
        DocumentSnapshot additionalDataSnapshot =
            await _db.collection(SEEKER_COLLECTION).doc(doc.id).get();

        if (additionalDataSnapshot.exists) {
          // Cast the data to Map<String, dynamic>
          Map<String, dynamic> additionalData =
              additionalDataSnapshot.data() as Map<String, dynamic>;
          // Merge additional data with basic data
          seekerData.addAll(additionalData);
        }

        seekerList.add(seekerData);
      }

      if (seekerList.isNotEmpty) {
        // print(providerList);
        return seekerList;
      } else {
        print("Empty");
        return null;
      }
    } catch (e) {
      print("Error getting seeker data : $e");
      return null;
    }
  }

  //count the seeker in this month
  Future<int> getMonthlySeekerCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'seeker')
          .where('pending', isEqualTo: false)
          .where('disabled', isEqualTo: false)
          .get();

      return _querySnapshot.docs.length;
    } catch (e) {
      print("Error getting provider count : $e");
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
          .collection(USER_COLLECTION)
          // .where('registered_date', isGreaterThanOrEqualTo: perviousTime)
          // .where('registered_date', isLessThanOrEqualTo: currentTime)
          .where('type', isEqualTo: 'provider')
          .where('pending', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> providerList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> providerData = doc.data();

        // Check if additional data exists
        DocumentSnapshot additionalDataSnapshot =
            await _db.collection(USER_COLLECTION).doc(doc.id).get();

        if (additionalDataSnapshot.exists) {
          // Cast the data to Map<String, dynamic>
          Map<String, dynamic> additionalData =
              additionalDataSnapshot.data() as Map<String, dynamic>;
          // Merge additional data with basic data
          additionalData['title'] = "New Provider";
          providerData.addAll(additionalData);
        }

        providerList.add(providerData);
      }

      if (providerList.isNotEmpty) {
        print(providerList);
        return providerList;
      } else {
        print("Empty");
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
          .collection(USER_COLLECTION)
          // .where('registered_date', isGreaterThanOrEqualTo: perviousTime)
          // .where('registered_date', isLessThanOrEqualTo: currentTime)
          .where('type', isEqualTo: 'seeker')
          // .where('pending', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> seekerList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Fetch basic data
        Map<String, dynamic> seekerData = doc.data();

        // Check if additional data exists
        DocumentSnapshot additionalDataSnapshot =
            await _db.collection(USER_COLLECTION).doc(doc.id).get();

        if (additionalDataSnapshot.exists) {
          // Cast the data to Map<String, dynamic>
          Map<String, dynamic> additionalData =
              additionalDataSnapshot.data() as Map<String, dynamic>;
          additionalData['title'] = "New Seeker";
          // Merge additional data with basic data
          seekerData.addAll(additionalData);
        }

        seekerList.add(seekerData);
      }

      if (seekerList.isNotEmpty) {
        print(seekerList);
        return seekerList;
      } else {
        print("Empty");
        return null;
      }
    } catch (e) {
      print("Error getting seeker notification : $e");
      return null;
    }
  }
}
