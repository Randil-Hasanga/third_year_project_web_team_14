// ignore_for_file: avoid_print

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
      UserCredential userCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredentials != null) {
        currentUser = await _getUserData(uid: userCredentials.user!.uid);
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
    try {
      DocumentSnapshot doc =
          await _db.collection(USER_COLLECTION).doc(uid).get();

      if (doc.exists) {
        return doc.data() as Map;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
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
        jobProviders.add(doc.data());
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
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('pending', isEqualTo: false)
          .where('disabled', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Documents exist
        return querySnapshot.docs.length;
      } else {
        // No documents found
        return 0;
      }
    } on Exception catch (e) {
      print('Error fetching provider count: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>?> getApprovalsData() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('pending', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> jobProviders = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        jobProviders.add(doc.data());
      }

      if (jobProviders.isNotEmpty) {
        return jobProviders;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting approvals data : $e");
      return null;
    }
  }

  Future<int> getApprovalsCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'provider')
          .where('pending', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Documents exist
        return querySnapshot.docs.length;
      } else {
        // No documents found
        return 0;
      }
    } catch (e) {
      print('Error fetching approvals count: $e');
      return 0;
    }
  }

  Future<int> getJobSeekerCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'seeker')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Documents exist
        return querySnapshot.docs.length;
      } else {
        // No documents found
        return 0;
      }
    } catch (e) {
      print('Error fetching job seeker count: $e');
      return 0;
    }
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
    try {
      await _db.collection(USER_COLLECTION).doc(uid).update({
        'disabled': true,
      });
    } catch (e) {
      print('Error Deleting user: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getOfficerData() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'officer')
          .get();

      List<Map<String, dynamic>> officer = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        officer.add(doc.data());
      }

      if (officer.isNotEmpty) {
        return officer;
      } else {}
    } catch (e) {
      print('Error Deleting user: $e');
      return null;
    }
  }

  Future<int> getOfficerCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot = await _db
          .collection(USER_COLLECTION)
          .where('type', isEqualTo: 'officer')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.length;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching job seeker count: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>?> getDeletedUsersData(
      String? dropDownValue) async {
    try {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot;
      if (dropDownValue == 'Job Providers') {
        querySnapshot = await _db
            .collection(USER_COLLECTION)
            .where('type', isEqualTo: 'provider')
            .where('disabled', isEqualTo: true)
            .get();
      } else if (dropDownValue == 'Job Seekers') {
        querySnapshot = await _db
            .collection(USER_COLLECTION)
            .where('type', isEqualTo: 'seeker')
            .where('disabled', isEqualTo: true)
            .get();
      } else if (dropDownValue == 'All') {
        querySnapshot = await _db
            .collection(USER_COLLECTION)
            .where('disabled', isEqualTo: true)
            .get();
      }

      List<Map<String, dynamic>> users = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot!.docs) {
        users.add(doc.data());
      }

      if (users.isNotEmpty) {
        return users;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching deleted users $e');
    }
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
}
