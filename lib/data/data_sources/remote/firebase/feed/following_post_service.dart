import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class FollowingPostService {
  late final _postsCollection = FirebaseSingletons.postsCollection;
  late final _usersCollection = FirebaseSingletons.usersCollection;

  Future<(List<PostModel>?, DocumentSnapshot?)> getFollowingPosts({
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final List<PostModel> postList = [];
      final currentUserId = AuthUtils().currentUserId;

      if (currentUserId == null) {
        return (<PostModel>[], lastDocument);
      }

      final userDoc = await _usersCollection.doc(currentUserId).get();
      if (!userDoc.exists) {
        return (<PostModel>[], lastDocument);
      }

      final data = userDoc.data() as Map<String, dynamic>;
      final following = List<String>.from(data[FirebaseKeys.following] ?? []);
      
      if (following.isEmpty) {
        return (<PostModel>[], lastDocument);
      }

      Query query = _postsCollection
          .where(FirebaseKeys.userId, whereIn: following)
          .orderBy(FirebaseKeys.time, descending: true)
          .limit(10);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;

        await Future.forEach(querySnapshot.docs, (doc) async {
          postList.add(PostModel.fromDocumentSnapshot(doc));
        });

        return (postList, lastDocument);
      }

      return (<PostModel>[], lastDocument);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
} 