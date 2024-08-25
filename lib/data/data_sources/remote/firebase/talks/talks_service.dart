import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/data_sources/remote/firebase/notifications/notifications_service.dart';
import 'package:haiku/data/models/talk_model.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/enums/notification_type_enum.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';
import 'package:hive/hive.dart';

class TalksService {
  late final _talksCollection = FirebaseSingletons.talksCollection;

  Future<(List<TalkModel>?, DocumentSnapshot?)> getAllTalks({
    required String postId,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final List<TalkModel> talksList = [];
      Query query = _talksCollection
          .where(FirebaseKeys.postId, isEqualTo: postId)
          .limit(10);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      final querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
        await Future.forEach(querySnapshot.docs, (doc) async {
          talksList.add(TalkModel.fromDocumentSnapshot(doc));
        });
        print("Talks received");
        return (talksList, lastDocument);
      }

      return (<TalkModel>[], lastDocument);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<bool> attemptToTalk({
    required String talkText,
    required String postId,
    required String posterId,
  }) async {
    final userId = AuthUtils().currentUserId;
    var box = Hive.box(AppKeys.userDataBox);
    var username = box.get(AppKeys.username);

    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference talkRef = FirebaseSingletons.talksCollection.doc();
    DocumentReference postRef = FirebaseSingletons.postsCollection.doc(postId);
    String talkDocId = talkRef.id;

    final talkDoc = {
      FirebaseKeys.commentText: talkText,
      FirebaseKeys.postId: postId,
      FirebaseKeys.posterIdForTalk: posterId,
      FirebaseKeys.username: username,
      FirebaseKeys.userId: userId,
      FirebaseKeys.clapCount: 0,
      FirebaseKeys.popularity: 0,
      FirebaseKeys.timestamp: FieldValue.serverTimestamp(),
    };

    try {
      batch.set(talkRef, talkDoc, SetOptions(merge: true));

      batch.update(postRef, {
        FirebaseKeys.talkCount: FieldValue.increment(1),
      });

      await batch.commit();

      NotificationsService.addNotification(
        fromId: AuthUtils().currentUserId,
        toId: posterId,
        notificationText: AppTexts.talkedAboutYourHaiku,
        fromUsername: Hive.box(AppKeys.userDataBox).get(AppKeys.username),
        type: NotificationType.newTalk.name,
        commenterId: AuthUtils().currentUserId,
        commentedPostId: postId,
        commentText: talkText,
        commentId: talkDocId,
      );

      return true; // Success
    } catch (e) {
      print(e); // Log the error
      return false; // Failure
    }
  }

  Future<bool> removeTalk({
    required String talkId,
    required String postId,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference talkDocRef =
        FirebaseSingletons.talksCollection.doc(talkId);
    DocumentReference postDocRef =
        FirebaseSingletons.postsCollection.doc(postId);

    try {
      batch.delete(talkDocRef);
      batch.update(postDocRef, {
        FirebaseKeys.talkCount: FieldValue.increment(-1),
      });
      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }
}
