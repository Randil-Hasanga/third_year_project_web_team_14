import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = 'users';
const String POSTS_COLLECTION = 'posts';

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

  Future<int> getOfficerCount() async {
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
        .collection(USER_COLLECTION)
        .where('type', isEqualTo: 'officer')
        .where('pending', isEqualTo: false)
        .where('disabled', isEqualTo: false)
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
}
  
