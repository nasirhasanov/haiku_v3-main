import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class TalkClapService {
  static Stream<DocumentSnapshot<Object?>> checkIfClapped(
    String talkId,
  ) async* {
    yield* FirebaseFirestore.instance.collection('claps')
        .doc('$talkId:${AuthUtils().currentUserId}')
        .snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getClapCount(
    String talkId,
  ) async* {
    yield* FirebaseSingletons.talksCollection.doc(talkId).snapshots();
  }

  static Future<void> addClap(
    String talkId,
    String clapperName,
    String talkerId,
  ) async {
    String? currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) throw 'User is not logged in';

    // Reference to the clapped post
    DocumentReference talkRef = FirebaseSingletons.talksCollection.doc(talkId);
    // Reference to the author's clap count
    DocumentReference authorRef =
        FirebaseSingletons.usersCollection.doc(talkerId);
    // Reference to the claps collection
    DocumentReference clapDocRef =
        FirebaseSingletons.clapsCollection.doc('$talkId:$currentUserId');

    // Run all operations in a batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Update the post's clap count and popularity
    batch.update(talkRef, {
      FirebaseKeys.clapCount: FieldValue.increment(1),
      FirebaseKeys.popularity: FieldValue.increment(1),
    });

    // Update the author's clap count
    batch.update(authorRef, {
      FirebaseKeys.score: FieldValue.increment(1),
    });

    // Add clap record to claps collection
    batch.set(
        clapDocRef,
        {
          FirebaseKeys.clappedPostId: talkId,
          FirebaseKeys.clapperId: currentUserId,
          FirebaseKeys.clapperName: clapperName,
          FirebaseKeys.posterId: talkerId,
        },
        SetOptions(merge: true));

    // Commit the batch
    return batch.commit();
  }

  static Future<void> removeClap(
    String talkId,
    String talkerId,
  ) async {
    String? currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) throw 'User is not logged in';

    // Reference to the clapped post
    DocumentReference talkRef = FirebaseSingletons.talksCollection.doc(talkId);
    // Reference to the author's clap count
    DocumentReference authorRef =
        FirebaseSingletons.usersCollection.doc(talkerId);
    // Reference to the claps collection
    DocumentReference clapDocRef =
        FirebaseSingletons.clapsCollection.doc('$talkId:$currentUserId');

    // Run all operations in a batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Decrement the post's clap count and popularity
    batch.update(talkRef, {
      FirebaseKeys.clapCount: FieldValue.increment(-1),
      FirebaseKeys.popularity: FieldValue.increment(-1),
    });

    // Decrement the author's clap count
    batch.update(authorRef, {
      FirebaseKeys.score: FieldValue.increment(-1),
    });

    // Remove clap record from claps collection
    batch.delete(clapDocRef);

    // Commit the batch
    return batch.commit();
  }
}