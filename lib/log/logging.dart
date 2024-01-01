import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamanacanal/log/connectivity_checker.dart';

class ApplicationLogger {
  String collectionPath = "applicationLogs";
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static ApplicationLogger? _instance;

  ApplicationLogger._();

  factory ApplicationLogger() => _instance ??= ApplicationLogger._();

  CollectionReference<Map<String, dynamic>> get _getCollection {
    return firebaseFirestore.collection(collectionPath);
  }

  Future<void> log(String message) async {
    final connectivityChecker = ConnectivityChecker();
    final hasConnection = await connectivityChecker.asConnection();
    if (hasConnection) {
      await _getCollection.add(
        {'message': "${DateTime.now().toString()} : $message"},
      );
    }
  }
}
