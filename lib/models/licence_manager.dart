import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appLicenceKey = "appLicenceKey";

class LicenceManager {
  String collectionPath = "licences";
  final FirebaseFirestore firebaseFirestore;

  LicenceManager({required this.firebaseFirestore});

  CollectionReference<Map<String, dynamic>> get _getCollection {
    return firebaseFirestore.collection(collectionPath);
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _findLicence(
    String key,
  ) async {
    final docs = (await _getCollection.where("key", isEqualTo: key).get()).docs;
    if (docs.isEmpty) {
      return null;
    }
    return docs.first;
  }

  Future<bool> isValidLicenceKey(String key) async {
    final result = await _findLicence(key);
    if (result == null) return false;
    final isUsed = result.data()["used"];
    final isSpecial = result.data()["special"];
    return !isUsed || isSpecial == true;
  }

  Future<void> useLicence(String key) async {
    if (await isValidLicenceKey(key)) {
      final result = await _findLicence(key);
      result!.reference.update({"used": true});

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(appLicenceKey, true);
    }
  }

  Future<bool> isLicenced() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(appLicenceKey) == true;
  }
}
