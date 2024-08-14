import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/notifications/notifications_mixin.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState>
    with NotificationsMixin {
  NotificationCubit() : super(NotificationInitial());

  Future<void> getAllNotifications() async {
    try {
      emit(NotificationLoading());
      await Future.wait([
        getNewNotifications(),
      ]);
      emit(NotificationSuccess());
    } catch (_) {
      emit(NotificationError());
    }
  }
}
