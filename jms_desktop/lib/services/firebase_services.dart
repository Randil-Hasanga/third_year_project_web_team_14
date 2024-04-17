import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = 'users';
const String POSTS_COLLECTION = 'posts';
const String PROVIDER_COLLECTION = 'provider_details';

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
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'provider')
        .where('pending', isEqualTo: false)
        .where('disabled', isEqualTo: false)
        .get();

    List<Map<String, dynamic>> jobProviders = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in _querySnapshot.docs) {
      jobProviders.add(doc.data());
    }

    if (jobProviders.isNotEmpty) {
      return jobProviders;
    } else {
      return null;
    }
  }

  Future<int> getProviderCount() async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'provider')
        .where('pending', isEqualTo: false)
        .where('disabled', isEqualTo: false)
        .get();

    return _querySnapshot.docs.length;
  }

  Future<List<Map<String, dynamic>>?> getApprovalsData() async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'provider')
        .where('pending', isEqualTo: true)
        .get();

    List<Map<String, dynamic>> jobProviders = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in _querySnapshot.docs) {
      jobProviders.add(doc.data());
    }

    if (jobProviders.isNotEmpty) {
      return jobProviders;
    } else {
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

  Future<void> fetchData(
    String reciType,
    String location,
    String industry,
  ) async {
    try {
      bool foundProvider = false;

      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection(USER_COLLECTION).get();

      // Process the user data
      List<QueryDocumentSnapshot> users = userSnapshot.docs;

      // Create a map to store user data
      Map<String, Map<String, dynamic>> userDataMap = {};

      users.forEach((user) {
        userDataMap[user.id] = user.data() as Map<String, dynamic>;
      });

      if (reciType == "Job Providers") {
        QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
            .collection(PROVIDER_COLLECTION)
            .get();

        // Process the provider data
        List<QueryDocumentSnapshot> providers = providerSnapshot.docs;

        Map<String, Map<String, dynamic>> providerDataMap = {};

        providers.forEach((provider) {
          providerDataMap[provider.id] =
              provider.data() as Map<String, dynamic>;
        });

        for (var provider in providers) {
          String userId = provider.id;

          var userData = userDataMap[userId];
          var providerData = providerDataMap[userId];

          if (location == "Any" && industry == "Any") {
            if (userData != null && !(userData['disabled'] ?? false)) {
              var providerData = provider.data();
              foundProvider = true;

              print('Provider data: $providerData');
              print('User data: $userData');
            }
          } else if (location == "Any" && industry != "Any") {
            if (userData != null &&
                !(userData['disabled'] ?? false) &&
                (providerData != null &&
                    providerData['industry'] == industry)) {
              foundProvider = true;
              var providerData = provider.data();

              print('Provider data: $providerData');
              print('User data: $userData');
            }
          } else if (location != "Any" && industry == "Any") {
            if (userData != null &&
                !(userData['disabled'] ?? false) &&
                (providerData != null &&
                    providerData['district'] == location)) {
              foundProvider = true;
              var providerData = provider.data();

              print('Provider data: $providerData');
              print('User data: $userData');
            }
          } else if (location != "Any" && industry != "Any") {
            if (userData != null &&
                !(userData['disabled'] ?? false) &&
                (providerData != null &&
                    providerData['district'] == location &&
                    providerData['industry'] == industry)) {
              foundProvider = true;
              var providerData = provider.data();

              print('Provider data: $providerData');
              print('User data: $userData');
            }
          }
        }
        if (!foundProvider) {
          print('No providers found with the chosen parameters.');
        }
      } else if (reciType == "Job Seekers") {
        //   QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
        //     .collection(PROVIDER_COLLECTION)
        //     .get();

        // // Process the provider data
        // List<QueryDocumentSnapshot> providers = providerSnapshot.docs;

        // // Fetch user data from the "users" collection

        // // Store user data in the map
        // users.forEach((user) {
        //   userDataMap[user.id] = user.data() as Map<String, dynamic>;
        // });

        // // Process each provider document
        // for (var provider in providers) {
        //   // Get the user ID from the provider data
        //   String userId = provider.id;

        //   // Get the user data from the userDataMap
        //   var userData = userDataMap[userId];

        //   // Check if the user exists and is not disabled
        //   if (userData != null && !(userData['disabled'] ?? false)) {
        //     // If the user exists and is not disabled, process the provider data
        //     var providerData = provider.data();

        //     // Combine the provider and user data or use them as needed
        //     print('Provider data: $providerData');
        //     print('User data: $userData');
        //   }
        // }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
