import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/daos/bouquet_dao.dart';
import 'package:jamanacanal/models/bouquet_detail.dart';
import 'package:jamanacanal/models/bouquet_input_data.dart';
import 'package:jamanacanal/models/database.dart';
import 'package:jamanacanal/sync/data_sync_service.dart';

part './bouquet_state.dart';

class BouquetCubit extends Cubit<BouquetState> {
  final BouquetsDao _bouquetsDao;
  final NotificationCubit _notificationCubit;
  final DataSyncService _dataSyncService;
  BouquetCubit(
    this._bouquetsDao,
    this._notificationCubit,
    this._dataSyncService,
  ) : super(BouquetInitial());

  Future<void> load() async {
    final bouquets = await _bouquetsDao.allBouquetDetails;

    emit(BouquetLoaded(bouquets: bouquets));
  }

  void loadAddForm() {
    emit(BouquetFormLoaded(bouquetInputData: BouquetInputData()));
  }

  Future<void> loadForEditing(int bouquetId) async {
    final bouquet = await _bouquetsDao.findById(bouquetId);
    emit(BouquetFormLoaded(
      bouquetInputData: BouquetInputData.init(
        id: bouquet.id,
        name: bouquet.name,
        obsolete: bouquet.obsolete,
      ),
    ));
  }

  Future<void> addBouquet(String bouquetName) async {
    try {
      emit(BouquetFormUnderTraitement());

      await _bouquetsDao
          .addBouquet(BouquetsCompanion(name: Value(bouquetName)));
      _notificationCubit.push(
        NotificationType.success,
        "Bouquet ajouté avec succès !",
      );
      await Future.delayed(const Duration(milliseconds: 500));
      emit(BouquetFormTraitementEnded());

      await load();
      loadAddForm();
      await _dataSyncService.onLocalDataChanged();
    } catch (e) {
      _notificationCubit.push(
        NotificationType.error,
        "Erreur lors de l'ajouté du bouquet",
      );
    }
  }

  Future<void> updateBouquet(BouquetInputData bouquetInputData) async {
    try {
      emit(BouquetFormUnderTraitement());

      _bouquetsDao.updateBouquetCompanion(BouquetsCompanion(
        id: Value(bouquetInputData.id!),
        name: Value(bouquetInputData.name),
        obsolete: Value(bouquetInputData.obsolete),
      ));

      _notificationCubit.push(
        NotificationType.success,
        "Info. modifiées avec succès !",
      );
      await Future.delayed(const Duration(milliseconds: 500));
      emit(BouquetFormTraitementEnded());
      await load();
      loadForEditing(bouquetInputData.id!);
      await _dataSyncService.onLocalDataChanged();
    } catch (e) {
      _notificationCubit.push(
        NotificationType.error,
        "Erreur lors de la mise à jour",
      );
    }
  }

  void setCurrentFormatData(BouquetInputData bouquetInputData) {
    final currentState = state as BouquetFormLoaded;

    emit(currentState.copyWith(bouquetInputData: bouquetInputData));
  }

  Future<void> setDeprecate(int bouquetId, bool isDeprecated) async {
    final bouquet = await _bouquetsDao.findById(bouquetId);
    await _bouquetsDao.updateBouquet(bouquet.copyWith(obsolete: isDeprecated));
    load();
    await _dataSyncService.onLocalDataChanged();
  }
}
