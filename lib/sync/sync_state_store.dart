import 'dart:convert';

import 'package:jamanacanal/models/licence_manager.dart';
import 'package:jamanacanal/sync/sync_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncStateStore {
  static const _activeLicenceScopeKey = 'syncActiveLicenceScope';
  static const _pendingSuffix = 'pending';
  static const _localUpdatedAtSuffix = 'localUpdatedAt';
  static const _lastSyncedAtSuffix = 'lastSyncedAt';
  static const _dirtyMutationsSuffix = 'dirtyMutations';
  static const _fullSyncRequiredSuffix = 'fullRequired';

  String? _cachedScope;

  Future<bool> activateLicenceScope(String licenceKey) async {
    final scope = LicenceManager.backupDocumentIdFor(licenceKey);
    final prefs = await SharedPreferences.getInstance();
    final previousScope = prefs.getString(_activeLicenceScopeKey);
    await prefs.setString(_activeLicenceScopeKey, scope);
    _cachedScope = scope;
    return previousScope != null && previousScope != scope;
  }

  Future<void> markPending({
    List<SyncMutation>? mutations,
    bool forceFullSync = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(await _scopedKey(_pendingSuffix), true);
    await prefs.setInt(
      await _scopedKey(_localUpdatedAtSuffix),
      DateTime.now().millisecondsSinceEpoch,
    );

    if (forceFullSync) {
      await prefs.setBool(await _scopedKey(_fullSyncRequiredSuffix), true);
      return;
    }

    if (mutations == null || mutations.isEmpty) {
      await prefs.setBool(await _scopedKey(_fullSyncRequiredSuffix), true);
      return;
    }

    final merged = await _mergeMutations(mutations);
    await prefs.setString(
      await _scopedKey(_dirtyMutationsSuffix),
      jsonEncode(merged.map((mutation) => mutation.toJson()).toList()),
    );
  }

  Future<bool> isPending() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(await _scopedKey(_pendingSuffix)) ?? false;
  }

  Future<bool> isFullSyncRequired() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(await _scopedKey(_fullSyncRequiredSuffix)) ?? false;
  }

  Future<List<SyncMutation>> getDirtyMutations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(await _scopedKey(_dirtyMutationsSuffix));
    if (raw == null || raw.isEmpty) return const [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => SyncMutation.fromJson(Map<String, dynamic>.from(entry)))
        .toList();
  }

  Future<DateTime?> getLocalUpdatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(await _scopedKey(_localUpdatedAtSuffix));
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<DateTime?> getLastSyncedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(await _scopedKey(_lastSyncedAtSuffix));
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> markSynced(DateTime syncedAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(await _scopedKey(_pendingSuffix), false);
    await prefs.setBool(await _scopedKey(_fullSyncRequiredSuffix), false);
    await prefs.remove(await _scopedKey(_dirtyMutationsSuffix));
    await prefs.setInt(
      await _scopedKey(_lastSyncedAtSuffix),
      syncedAt.millisecondsSinceEpoch,
    );
  }

  Future<List<SyncMutation>> _mergeMutations(
    List<SyncMutation> incoming,
  ) async {
    final existing = await getDirtyMutations();
    final byKey = <String, SyncMutation>{
      for (final mutation in existing) mutation.key: mutation,
    };

    for (final mutation in incoming) {
      byKey[mutation.key] = mutation;
    }

    return byKey.values.toList();
  }

  Future<String> _scopedKey(String suffix) async {
    final scope = await _currentScope();
    return 'sync_${scope}_$suffix';
  }

  Future<String> _currentScope() async {
    if (_cachedScope != null) return _cachedScope!;

    final prefs = await SharedPreferences.getInstance();
    _cachedScope = prefs.getString(_activeLicenceScopeKey);
    return _cachedScope ?? 'default';
  }
}
