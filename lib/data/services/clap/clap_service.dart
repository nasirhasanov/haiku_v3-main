import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

import '../../../utilities/helpers/auth_utils.dart';

class ClapService {
  static Stream<DocumentSnapshot<Object?>> checkIfClapped(
    String postId,
  ) async* {
    yield* FirebaseFirestore.instance.collection('claps')
        .doc('$postId:${AuthUtils().currentUserId}')
        .snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getClapCount(
    String postId,
  ) async* {
    yield* FirebaseSingletons.postsCollection.doc(postId).snapshots();
  }

  static Future<void> addClap(
    String postId,
    String clapperName,
    String posterId,
  ) async {
    String? currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) throw 'User is not logged in';

    // Reference to the clapped post
    DocumentReference postRef = FirebaseSingletons.postsCollection.doc(postId);
    // Reference to the author's clap count
    DocumentReference authorRef =
        FirebaseSingletons.usersCollection.doc(posterId);
    // Reference to the claps collection
    DocumentReference clapDocRef =
        FirebaseSingletons.clapsCollection.doc('$postId:$currentUserId');

    // Run all operations in a batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Update the post's clap count and popularity
    batch.update(postRef, {
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
          FirebaseKeys.clappedPostId: postId,
          FirebaseKeys.clapperId: currentUserId,
          FirebaseKeys.clapperName: clapperName,
          FirebaseKeys.posterId: posterId,
        },
        SetOptions(merge: true));

    // Commit the batch
    return batch.commit();
  }

  static Future<void> removeClap(
    String postId,
    String posterId,
  ) async {
    String? currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) throw 'User is not logged in';

    // Reference to the clapped post
    DocumentReference postRef = FirebaseSingletons.postsCollection.doc(postId);
    // Reference to the author's clap count
    DocumentReference authorRef =
        FirebaseSingletons.usersCollection.doc(posterId);
    // Reference to the claps collection
    DocumentReference clapDocRef =
        FirebaseSingletons.clapsCollection.doc('$postId:$currentUserId');

    // Run all operations in a batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Decrement the post's clap count and popularity
    batch.update(postRef, {
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
