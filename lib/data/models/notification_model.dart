import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String notificationId;
  String? fromId;
  String? toId;
  String? fromUserName;
  String? notificationText;
  Timestamp timeStamp;
  String? type;
  String? clappedPostId;
  String? fromProfilePicPath;

  NotificationModel({
    required this.notificationId,
    required this.timeStamp,
    this.clappedPostId,
    this.fromId,
    this.toId,
    this.fromUserName,
    this.notificationText,
    this.type,
    this.fromProfilePicPath,
  });

  factory NotificationModel.fromDocumentSnapshot(
    DocumentSnapshot snapshot,
  ) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return NotificationModel(
      notificationId: snapshot.id,
      fromId: data['from_id'],
      toId: data['to_id'],
      fromUserName: data['from_username'],
      notificationText: data['notification_text'],
      timeStamp: data['timestamp'],
      type: data['notification_type'],
      clappedPostId: data['clappedPostId'],
      fromProfilePicPath: data['from_profile_pic_path'],
    );
  }
}
