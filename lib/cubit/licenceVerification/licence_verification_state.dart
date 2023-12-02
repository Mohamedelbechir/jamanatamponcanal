part of 'licence_verification_cubit.dart';

sealed class LicenceVerificationState extends Equatable {
  const LicenceVerificationState();

  @override
  List<Object> get props => [];
}

final class LicenceVerificationInitial extends LicenceVerificationState {}

final class NoLicence extends LicenceVerificationState {}

final class VerifiedLicence extends LicenceVerificationState {}
