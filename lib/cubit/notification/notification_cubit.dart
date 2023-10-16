import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

enum NotificationType {
  error,
  success,
  warning,
}

extension NotificationTypeExtension on NotificationType {
  MaterialColor get color {
    switch (this) {
      case NotificationType.error:
        return Colors.red;
      case NotificationType.warning:
        return Colors.yellow;
      case NotificationType.success:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.dangerous;
      case NotificationType.success:
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void push(NotificationType notificationType, String message) {
    emit(NotificationLoaded(
      message: message,
      notificationType: notificationType,
    ));
  }

  void reset() => emit(NotificationReset());
}
