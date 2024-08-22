import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/models/notification_model.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class NotificationsService {
  late final _notificationsCollection =
      FirebaseSingletons.notificationsCollection;

  Future<(List<NotificationModel>?, DocumentSnapshot?)> getNotifications({
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final List<NotificationModel> notificationList = [];

      Query query = _notificationsCollection
          .where(FirebaseKeys.toId, isEqualTo: AuthUtils().currentUserId)
          .orderBy(FirebaseKeys.timestamp, descending: true)
          .limit(10);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;

        await Future.forEach(querySnapshot.docs, (doc) async {
          notificationList.add(NotificationModel.fromDocumentSnapshot(doc));
          print(notificationList.first.fromUserName);

        });

        return (notificationList, lastDocument);
      }

      return (<NotificationModel>[], lastDocument);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<bool> addNotification({
    String? fromId,
    String? toId,
    String? notificationText,
    String? fromUsername,
    String type = '',
    String? clappedPostId,
    String? clapperId,
  }) async {
    if (fromId != null && toId != null && notificationText != null) {
      final notificationDoc = {
        FirebaseKeys.fromId: fromId,
        FirebaseKeys.toId: toId,
        FirebaseKeys.notificationText: notificationText,
        FirebaseKeys.notificationType: type,
        FirebaseKeys.fromUsername: fromUsername,
        FirebaseKeys.clappedPostId: clappedPostId,
        FirebaseKeys.clapperId: clapperId,
        FirebaseKeys.timestamp: FieldValue.serverTimestamp(),
      };

      try {
        FirebaseFirestore.instance
            .collection(FirebaseKeys.notifications)
            .add(notificationDoc);
        return true; // Success
      } catch (e) {
        print(e); // Log the error
        return false; // Failure
      }
    }
    return false; // Invalid input
  }
}
