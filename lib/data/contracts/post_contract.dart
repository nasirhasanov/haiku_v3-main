import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_model.dart';

abstract class PostContract {
  Future<(List<PostModel>?, DocumentSnapshot?)> getNewPosts({
    DocumentSnapshot? lastDocument,
  });
  Future<(List<PostModel>?, DocumentSnapshot?)> getMixPosts({
    DocumentSnapshot? lastDocument,
  });
  Future<(List<PostModel>?, DocumentSnapshot?)> getLocalPosts({
    DocumentSnapshot? lastDocument,
  });
  Future<(List<PostModel>?, DocumentSnapshot?)> getMyPosts({
    DocumentSnapshot? lastDocument,
  });
  Future<(List<PostModel>?, DocumentSnapshot?)> getAuthorPosts({
    required String authorId,
    DocumentSnapshot? lastDocument,
  });
}
