import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class FollowingPostsService {
  late final _postsCollection = FirebaseSingletons.postsCollection;
  late final _usersCollection = FirebaseSingletons.usersCollection;

  Future<List<PostModel>> getFollowingPosts(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();
      final data = userDoc.data() as Map<String, dynamic>?;
      if (data == null) return [];

      final following = List<String>.from(data[FirebaseKeys.following] ?? []);
      if (following.isEmpty) return [];

      final querySnapshot = await _postsCollection
          .where(FirebaseKeys.userId, whereIn: following)
          .orderBy(FirebaseKeys.time, descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) => PostModel.fromDocumentSnapshot(doc)).toList();
    } catch (e) {
      print('Error getting following posts: $e');
      return [];
    }
  }
} 