import 'dart:io';

class ConnectivityChecker {
  static const _probeHosts = [
    'firestore.googleapis.com',
    'www.google.com',
  ];

  Future<bool> asConnection() async {
    for (final host in _probeHosts) {
      try {
        final result = await InternetAddress.lookup(host);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {}
    }
    return false;
  }
}
