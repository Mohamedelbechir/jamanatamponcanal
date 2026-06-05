import 'package:shared_preferences/shared_preferences.dart';

class SyncStateStore {
  static const pendingKey = 'syncPending';
  static const localUpdatedAtKey = 'syncLocalUpdatedAt';
  static const lastSyncedAtKey = 'syncLastSyncedAt';

  Future<void> markPending() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(pendingKey, true);
    await prefs.setInt(
      localUpdatedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<bool> isPending() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(pendingKey) ?? false;
  }

  Future<DateTime?> getLocalUpdatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(localUpdatedAtKey);
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<DateTime?> getLastSyncedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(lastSyncedAtKey);
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> markSynced(DateTime syncedAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(pendingKey, false);
    await prefs.setInt(lastSyncedAtKey, syncedAt.millisecondsSinceEpoch);
  }
}
