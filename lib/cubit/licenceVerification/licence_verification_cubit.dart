import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/licence_manager.dart';

part 'licence_verification_state.dart';

class LicenceVerificationCubit extends Cubit<LicenceVerificationState> {
  final LicenceManager _licenceManager;
  LicenceVerificationCubit(this._licenceManager)
      : super(LicenceVerificationInitial());

  Future<void> load() async {
    if (await _licenceManager.isLicenced()) {
      emit(VerifiedLicence());
    } else {
      emit(NoLicence());
    }
  }
}
