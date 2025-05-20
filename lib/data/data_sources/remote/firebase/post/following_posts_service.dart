import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class FollowingPostsService {
  late final _postsCollection = FirebaseSingletons.postsCollection;
  late final _usersCollection = FirebaseSingletons.usersCollection;

  Future<List<PostModel>> getFollowingPosts({
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    try {
      final currentUserId = AuthUtils().currentUserId;
      if (currentUserId == null) return [];

      // Get current user's following list
      final userDoc = await _usersCollection.doc(currentUserId).get();
      if (!userDoc.exists) return [];

      final data = userDoc.data() as Map<String, dynamic>;
      final following = List<String>.from(data['following'] ?? []);
      
      if (following.isEmpty) return [];

      // Create query for posts from followed users
      Query query = _postsCollection
          .where(FirebaseKeys.userId, whereIn: following)
          .orderBy(FirebaseKeys.time, descending: true)
          .limit(limit);

      // If we have a last document, start after it
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();
      final List<PostModel> posts = [];

      for (var doc in querySnapshot.docs) {
        posts.add(PostModel.fromDocumentSnapshot(doc));
      }

      return posts;
    } catch (e) {
      print('Error fetching following posts: $e');
      return [];
    }
  }

  Stream<QuerySnapshot> getFollowingPostsStream() {
    final currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    return _usersCollection
        .doc(currentUserId)
        .snapshots()
        .asyncMap((userDoc) async {
          if (!userDoc.exists) return null;

          final data = userDoc.data() as Map<String, dynamic>;
          final following = List<String>.from(data['following'] ?? []);
          
          if (following.isEmpty) return null;

          return _postsCollection
              .where(FirebaseKeys.userId, whereIn: following)
              .orderBy(FirebaseKeys.time, descending: true)
              .limit(10)
              .get();
        })
        .where((snapshot) => snapshot != null)
        .cast<QuerySnapshot>();
  }
} 