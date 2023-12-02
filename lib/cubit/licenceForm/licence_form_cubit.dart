import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/licenceVerification/licence_verification_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/models/licence_manager.dart';

part 'licence_form_state.dart';

class LicenceFormCubit extends Cubit<LicenceFormState> {
  final LicenceManager licenceManager;
  final LicenceVerificationCubit _licenceVerificationCubit;
  final NotificationCubit _notificationCubit;

  LicenceFormCubit(
    this._licenceVerificationCubit,
    this._notificationCubit, {
    required this.licenceManager,
  }) : super(LicenceFormInitial());

  Future<void> submit(String key) async {
    emit(LicenceSubmitting());
    if (!await licenceManager.isLicenced()) {
      if (await licenceManager.isValidLicenceKey(key)) {
        await licenceManager.useLicence(key);
        _licenceVerificationCubit.load();
      } else {
        _notificationCubit.push(
          NotificationType.error,
          "La clé de licence fournie n'est pas valide",
        );
        emit(LicenceInvalid());
      }
    } else {
      _licenceVerificationCubit.load();
    }
  }
}
