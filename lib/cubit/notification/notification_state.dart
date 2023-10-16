part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class NotificationReset extends NotificationState {}

final class NotificationLoaded extends NotificationState {
  final String message;
  final NotificationType notificationType;

  const NotificationLoaded({
    required this.message,
    required this.notificationType,
  });
  @override
  List<Object> get props => [
        message,
        notificationType,
      ];
}
