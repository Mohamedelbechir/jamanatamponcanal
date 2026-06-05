import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:jamanacanal/log/connectivity_checker.dart';
import 'package:jamanacanal/models/licence_manager.dart';
import 'package:jamanacanal/sync/data_backup_repository.dart';
import 'package:jamanacanal/sync/sync_state_store.dart';

class DataSyncService {
  DataSyncService({
    required DataBackupRepository backupRepository,
    required LicenceManager licenceManager,
    required SyncStateStore syncStateStore,
    ConnectivityChecker? connectivityChecker,
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  })  : _backupRepository = backupRepository,
        _licenceManager = licenceManager,
        _syncStateStore = syncStateStore,
        _connectivityChecker = connectivityChecker ?? ConnectivityChecker(),
        _firestore = firestore ?? FirebaseFirestore.instance,
        _connectivity = connectivity ?? Connectivity();

  final DataBackupRepository _backupRepository;
  final LicenceManager _licenceManager;
  final SyncStateStore _syncStateStore;
  final ConnectivityChecker _connectivityChecker;
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  static const _backupCollection = 'backups';
  static const _schemaVersion = 3;

  bool _syncInProgress = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final _syncCompletedController = StreamController<void>.broadcast();

  Stream<void> get onSyncCompleted => _syncCompletedController.stream;

  void startListening() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_) {
      unawaited(syncIfNeeded());
    });
    unawaited(syncIfNeeded());
  }

  Future<void> stopListening() async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  Future<void> onLocalDataChanged() async {
    await _syncStateStore.markPending();
    await syncIfNeeded();
  }

  Future<void> syncIfNeeded() async {
    if (_syncInProgress) return;
    if (!await _licenceManager.isLicenced()) return;

    final licenceKey = await _licenceManager.getLicenceKey();
    if (licenceKey == null || licenceKey.isEmpty) return;

    final backupDocumentId = LicenceManager.backupDocumentIdFor(licenceKey);

    if (!await _hasConnection()) return;

    _syncInProgress = true;
    try {
      final pulled = await _performSync(backupDocumentId, licenceKey);
      if (pulled) {
        _syncCompletedController.add(null);
      }
    } catch (error, stackTrace) {
      debugPrint('Data sync failed: $error');
      debugPrint('$stackTrace');
    } finally {
      _syncInProgress = false;
    }
  }

  Future<bool> _performSync(String backupDocumentId, String licenceKey) async {
    final backupRef =
        _firestore.collection(_backupCollection).doc(backupDocumentId);
    final remoteSnapshot = await backupRef.get();

    final isPending = await _syncStateStore.isPending();
    final lastSyncedAt = await _syncStateStore.getLastSyncedAt();
    final remoteUpdatedAt = _readRemoteUpdatedAt(remoteSnapshot.data());

    if (isPending) {
      final now = DateTime.now();
      final snapshot = await _backupRepository.exportSnapshot();
      await backupRef.set({
        ...snapshot,
        'licenceKey': licenceKey,
        'schemaVersion': _schemaVersion,
        'updatedAt': Timestamp.fromDate(now),
      });
      await _syncStateStore.markSynced(now);
      return false;
    }

    if (remoteSnapshot.exists &&
        remoteUpdatedAt != null &&
        (lastSyncedAt == null || remoteUpdatedAt.isAfter(lastSyncedAt))) {
      await _backupRepository.importSnapshot(remoteSnapshot.data()!);
      await _syncStateStore.markSynced(remoteUpdatedAt);
      return true;
    }

    return false;
  }

  DateTime? _readRemoteUpdatedAt(Map<String, dynamic>? data) {
    final updatedAt = data?['updatedAt'];
    if (updatedAt is Timestamp) {
      return updatedAt.toDate();
    }
    return null;
  }

  Future<bool> _hasConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return _connectivityChecker.asConnection();
  }

  Future<void> dispose() async {
    await stopListening();
    await _syncCompletedController.close();
  }
}
