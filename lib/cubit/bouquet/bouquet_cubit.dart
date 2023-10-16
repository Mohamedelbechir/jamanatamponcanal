import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/daos/bouquet_dao.dart';
import 'package:jamanacanal/models/bouquet_detail.dart';
import 'package:jamanacanal/models/database.dart';

part './bouquet_state.dart';

class BouquetCubit extends Cubit<BouquetState> {
  final BouquetsDao _bouquetsDao;
  BouquetCubit(this._bouquetsDao) : super(BouquetInitial());

  Future<void> load() async {
    final bouquets = await _bouquetsDao.allBouquetDetails;

    emit(BouquetLoaded(bouquets: bouquets));
  }

  Future<void> addBouquet(String bouquetName) async {
    emit(AddingNewBouquet());

    await _bouquetsDao.addBouquet(BouquetsCompanion(name: Value(bouquetName)));

    await Future.delayed(const Duration(milliseconds: 500));
    emit(BouquetAdded());
    load();
  }
}
