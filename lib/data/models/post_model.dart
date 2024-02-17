import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String userName;
  String userId;
  String postId;
  String postText;
  int clapCount;
  Timestamp timeStamp;
  int? talkCount;
  String? countryCode;
  String? profilePicPath;

  PostModel({
    required this.userName,
    required this.userId,
    required this.postId,
    required this.postText,
    required this.clapCount,
    required this.timeStamp,
    this.talkCount,
    this.countryCode,
    this.profilePicPath,
  });

  factory PostModel.fromDocumentSnapshot(
    DocumentSnapshot snapshot,
  ) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return PostModel(
      userName: data['username'],
      userId: data['user_id'],
      postId: snapshot.id,
      postText: data['post_text'],
      clapCount: data['clapCount'],
      timeStamp: data['time'],
      talkCount: data['talkCount'] ?? 0,
      countryCode: data['countryCode'],
    );
  }
}
