import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class MyPostService {
  late final _postsCollection = FirebaseSingletons.postsCollection;

  Future<(List<PostModel>?, DocumentSnapshot?)> getMyPosts({
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final List<PostModel> postList = [];

      Query query = _postsCollection
          .where(FirebaseKeys.userId, isEqualTo: AuthUtils().currentUserId)
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

  Future<PostModel?> getPost({required String postId}) async {
    try {
      final documentSnaphot = await _postsCollection.doc(postId).get();
      if (documentSnaphot.exists) {
        final PostModel post = PostModel.fromDocumentSnapshot(documentSnaphot);

        return post;
      }
      print('Post is null');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
