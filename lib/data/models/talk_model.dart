import 'package:cloud_firestore/cloud_firestore.dart';

class TalkModel {
  int clapCount;
  String commentText;
  int? popularity;
  String postId;
  String? posterId;
  Timestamp timeStamp;
  String userName;
  String userId;
  String talkId;

  TalkModel({
    required this.talkId,
    required this.userName,
    required this.userId,
    required this.postId,
    required this.commentText,
    required this.clapCount,
    required this.timeStamp,
    required this.posterId,
    this.popularity,
  });

  factory TalkModel.fromDocumentSnapshot(
    DocumentSnapshot snapshot,
  ) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return TalkModel(
      talkId: snapshot.id,
      userName: data['username'],
      userId: data['user_id'],
      postId: data['post_id'],
      commentText: data['comment_text'],
      clapCount: data['clapCount'],
      timeStamp: data['timestamp'],
      posterId: data['poster_id'],
      popularity: data['popularity'] ?? 0,
    );
  }
}
