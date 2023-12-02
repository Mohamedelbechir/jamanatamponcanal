part of 'licence_form_cubit.dart';

sealed class LicenceFormState extends Equatable {
  const LicenceFormState();

  @override
  List<Object> get props => [];
}

final class LicenceFormInitial extends LicenceFormState {}

final class LicenceSubmitting extends LicenceFormState {}

final class LicenceInvalid extends LicenceFormState {}
