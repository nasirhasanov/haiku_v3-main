import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/models/notification_model.dart';
import 'package:haiku/data/data_sources/remote/firebase/notifications/notifications_service.dart';

abstract class NotificationRepositoryImpl {
  Future<(List<NotificationModel>?, DocumentSnapshot?)> getNotifications ({
    DocumentSnapshot? lastDocument,
  });
}

class NotificationRepository implements NotificationRepositoryImpl {
  NotificationRepository(this._notificationsService);

  final NotificationsService _notificationsService;

  @override
  Future<(List<NotificationModel>?, DocumentSnapshot?)> getNotifications({
    DocumentSnapshot? lastDocument,
  }) =>
      _notificationsService.getNotifications(
        lastDocument: lastDocument,
      );
}