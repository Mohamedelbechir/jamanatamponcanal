import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:jamanacanal/log/connectivity_checker.dart';
import 'package:jamanacanal/models/licence_manager.dart';
import 'package:jamanacanal/sync/data_backup_repository.dart';
import 'package:jamanacanal/sync/sync_entity.dart';
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
  static const _schemaVersion = 4;
  static const _syncFormat = 'subcollections';
  static const _batchWriteLimit = 450;
  static const _pullPageSize = 500;

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

  Future<void> onLocalDataChanged({
    List<SyncMutation>? mutations,
    bool forceFullSync = false,
  }) async {
    await _syncStateStore.markPending(
      mutations: mutations,
      forceFullSync: forceFullSync,
    );
    await syncIfNeeded();
  }

  Future<void> syncIfNeeded() async {
    if (_syncInProgress) return;
    if (!await _licenceManager.isLicenced()) return;

    final licenceKey = await _licenceManager.getLicenceKey();
    if (licenceKey == null || licenceKey.isEmpty) return;

    final backupDocumentId = LicenceManager.backupDocumentIdFor(licenceKey);
    final licenceChanged =
        await _syncStateStore.activateLicenceScope(licenceKey);

    if (!await _hasConnection()) return;

    _syncInProgress = true;
    try {
      final pulled = await _performSync(
        backupDocumentId,
        licenceKey,
        licenceChanged: licenceChanged,
      );
      if (pulled) {
        _syncCompletedController.add(null);
      }
    } catch (error, stackTrace) {
      debugPrint('Data sync failed: $error');
      debugPrint('$stackTrace');
    } finally {
      _syncInProgress = false;
      if (await _hasPendingLocalChanges()) {
        unawaited(syncIfNeeded());
      }
    }
  }

  Future<bool> _performSync(
    String backupDocumentId,
    String licenceKey, {
    required bool licenceChanged,
  }) async {
    final backupRef =
        _firestore.collection(_backupCollection).doc(backupDocumentId);
    final remoteSnapshot = await backupRef.get();
    final remoteData = remoteSnapshot.data();

    if (licenceChanged) {
      return _initializeBackupForLicence(
        backupRef,
        licenceKey,
        remoteSnapshot.exists,
        remoteData,
      );
    }

    if (!_belongsToLicence(remoteData, licenceKey)) {
      debugPrint(
        'Remote backup does not belong to licence $licenceKey, skipping import.',
      );
      return false;
    }

    if (_isLegacySnapshot(remoteData)) {
      await _backupRepository.importSnapshot(remoteData!);
      final remoteUpdatedAt = _readRemoteUpdatedAt(remoteData);
      if (remoteUpdatedAt != null) {
        await _syncStateStore.markSynced(remoteUpdatedAt);
      }
      await _uploadChanges(backupRef, licenceKey, forceFull: true);
      return true;
    }

    final lastSyncedAt = await _syncStateStore.getLastSyncedAt();
    final remoteUpdatedAt = _readRemoteUpdatedAt(remoteData);
    final hasLocalChanges = await _hasPendingLocalChanges();

    if (hasLocalChanges || !remoteSnapshot.exists) {
      await _uploadChanges(backupRef, licenceKey);
      return false;
    }

    if (remoteSnapshot.exists &&
        remoteUpdatedAt != null &&
        (lastSyncedAt == null || remoteUpdatedAt.isAfter(lastSyncedAt))) {
      final pulled = await _pullRemoteChanges(
        backupRef,
        lastSyncedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      );
      if (pulled) {
        await _syncStateStore.markSynced(remoteUpdatedAt);
        return true;
      }
    }

    return false;
  }

  Future<bool> _initializeBackupForLicence(
    DocumentReference<Map<String, dynamic>> backupRef,
    String licenceKey,
    bool remoteExists,
    Map<String, dynamic>? remoteData,
  ) async {
    if (remoteExists &&
        remoteData != null &&
        _belongsToLicence(remoteData, licenceKey)) {
      if (_isLegacySnapshot(remoteData)) {
        await _backupRepository.importSnapshot(remoteData);
        final remoteUpdatedAt = _readRemoteUpdatedAt(remoteData);
        if (remoteUpdatedAt != null) {
          await _syncStateStore.markSynced(remoteUpdatedAt);
        }
        await _uploadChanges(backupRef, licenceKey, forceFull: true);
        return true;
      }

      await _backupRepository.clearAllData();
      final pulled = await _pullRemoteChanges(
        backupRef,
        DateTime.fromMillisecondsSinceEpoch(0),
      );
      final remoteUpdatedAt =
          _readRemoteUpdatedAt(remoteData) ?? DateTime.now();
      await _syncStateStore.markSynced(remoteUpdatedAt);
      return pulled;
    }

    await _backupRepository.clearAllData();
    await _syncStateStore.markSynced(DateTime.now());
    return true;
  }

  bool _belongsToLicence(Map<String, dynamic>? data, String licenceKey) {
    if (data == null) return true;
    final remoteLicenceKey = data['licenceKey'] as String?;
    if (remoteLicenceKey == null || remoteLicenceKey.isEmpty) return true;
    return LicenceManager.backupDocumentIdFor(remoteLicenceKey) ==
        LicenceManager.backupDocumentIdFor(licenceKey);
  }

  Future<void> _uploadChanges(
    DocumentReference<Map<String, dynamic>> backupRef,
    String licenceKey, {
    bool forceFull = false,
  }) async {
    final now = DateTime.now();
    final fullSync = forceFull || await _syncStateStore.isFullSyncRequired();
    final mutations = await _syncStateStore.getDirtyMutations();

    if (fullSync || mutations.isEmpty) {
      await _uploadFullBackup(backupRef, now);
    } else {
      await _uploadMutations(backupRef, mutations, now);
    }

    await backupRef.set({
      'licenceKey': licenceKey,
      'schemaVersion': _schemaVersion,
      'syncFormat': _syncFormat,
      'updatedAt': Timestamp.fromDate(now),
    });
    await _syncStateStore.markSynced(now);
  }

  Future<void> _uploadFullBackup(
    DocumentReference<Map<String, dynamic>> backupRef,
    DateTime now,
  ) async {
    final entities = await _backupRepository.exportAllEntities();
    for (final collection in SyncCollection.values) {
      await _writeEntitiesBatched(
        backupRef,
        collection,
        entities[collection] ?? const [],
        now,
      );
    }
  }

  Future<void> _uploadMutations(
    DocumentReference<Map<String, dynamic>> backupRef,
    List<SyncMutation> mutations,
    DateTime now,
  ) async {
    var batch = _firestore.batch();
    var operationCount = 0;

    Future<void> commitBatch({required bool force}) async {
      if (operationCount == 0) return;
      if (!force && operationCount < _batchWriteLimit) return;
      await batch.commit();
      batch = _firestore.batch();
      operationCount = 0;
    }

    for (final mutation in mutations) {
      final collectionName = syncCollectionName(mutation.collection);
      final docRef =
          backupRef.collection(collectionName).doc(mutation.entityId.toString());

      if (mutation.deleted) {
        batch.set(
          docRef,
          {
            'id': mutation.entityId,
            'deleted': true,
            'updatedAt': Timestamp.fromDate(now),
          },
        );
      } else {
        final entity = await _backupRepository.exportEntity(
          mutation.collection,
          mutation.entityId,
        );
        if (entity == null) continue;

        batch.set(
          docRef,
          {
            ...entity,
            'deleted': false,
            'updatedAt': Timestamp.fromDate(now),
          },
        );
      }

      operationCount++;
      if (operationCount >= _batchWriteLimit) {
        await commitBatch(force: true);
      }
    }

    await commitBatch(force: true);
  }

  Future<void> _writeEntitiesBatched(
    DocumentReference<Map<String, dynamic>> backupRef,
    SyncCollection collection,
    List<Map<String, dynamic>> entities,
    DateTime now,
  ) async {
    if (entities.isEmpty) return;

    var batch = _firestore.batch();
    var operationCount = 0;
    final collectionName = syncCollectionName(collection);

    Future<void> commitBatch({required bool force}) async {
      if (operationCount == 0) return;
      if (!force && operationCount < _batchWriteLimit) return;
      await batch.commit();
      batch = _firestore.batch();
      operationCount = 0;
    }

    for (final entity in entities) {
      final entityId = entity['id'];
      if (entityId == null) continue;

      batch.set(
        backupRef.collection(collectionName).doc(entityId.toString()),
        {
          ...entity,
          'deleted': false,
          'updatedAt': Timestamp.fromDate(now),
        },
      );
      operationCount++;
      if (operationCount >= _batchWriteLimit) {
        await commitBatch(force: true);
      }
    }

    await commitBatch(force: true);
  }

  Future<bool> _pullRemoteChanges(
    DocumentReference<Map<String, dynamic>> backupRef,
    DateTime since,
  ) async {
    var pulled = false;
    final sinceTimestamp = Timestamp.fromDate(since);

    for (final collection in SyncCollection.values) {
      final collectionPulled = await _pullCollectionChanges(
        backupRef,
        collection,
        sinceTimestamp,
      );
      pulled = pulled || collectionPulled;
    }

    return pulled;
  }

  Future<bool> _pullCollectionChanges(
    DocumentReference<Map<String, dynamic>> backupRef,
    SyncCollection collection,
    Timestamp sinceTimestamp,
  ) async {
    var pulled = false;
    final collectionRef =
        backupRef.collection(syncCollectionName(collection));
    Query<Map<String, dynamic>> query = collectionRef
        .where('updatedAt', isGreaterThan: sinceTimestamp)
        .orderBy('updatedAt')
        .limit(_pullPageSize);

    while (true) {
      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) break;

      for (final doc in snapshot.docs) {
        await _backupRepository.applyRemoteEntity(collection, doc.data());
      }
      pulled = true;

      if (snapshot.docs.length < _pullPageSize) break;
      query = collectionRef
          .where('updatedAt', isGreaterThan: sinceTimestamp)
          .orderBy('updatedAt')
          .startAfterDocument(snapshot.docs.last)
          .limit(_pullPageSize);
    }

    return pulled;
  }

  bool _isLegacySnapshot(Map<String, dynamic>? data) {
    if (data == null) return false;
    if (data['syncFormat'] == _syncFormat) return false;
    return data['customers'] is List;
  }

  Future<bool> _hasPendingLocalChanges() async {
    if (await _syncStateStore.isPending()) return true;
    if (await _syncStateStore.isFullSyncRequired()) return true;
    if ((await _syncStateStore.getDirtyMutations()).isNotEmpty) return true;

    final localUpdatedAt = await _syncStateStore.getLocalUpdatedAt();
    final lastSyncedAt = await _syncStateStore.getLastSyncedAt();
    if (localUpdatedAt == null) return false;

    return lastSyncedAt == null || localUpdatedAt.isAfter(lastSyncedAt);
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
