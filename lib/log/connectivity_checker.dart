import 'dart:io';

class ConnectivityChecker {
  Future<bool> asConnection() async {
    bool hasConnection = false;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      }
    } on SocketException catch (_) {}
    return hasConnection;
  }
}
