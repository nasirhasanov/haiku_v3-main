import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class FollowService {
  late final _usersCollection = FirebaseSingletons.usersCollection;

  Future<bool> followUser(String targetUserId) async {
    final currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) return false;

    try {
      // Add to current user's following list
      await _usersCollection.doc(currentUserId).update({
        'following': FieldValue.arrayUnion([targetUserId])
      });

      // Add to target user's followers list
      await _usersCollection.doc(targetUserId).update({
        'followers': FieldValue.arrayUnion([currentUserId])
      });

      return true;
    } catch (e) {
      print('Error following user: $e');
      return false;
    }
  }

  Future<bool> unfollowUser(String targetUserId) async {
    final currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) return false;

    try {
      // Remove from current user's following list
      await _usersCollection.doc(currentUserId).update({
        'following': FieldValue.arrayRemove([targetUserId])
      });

      // Remove from target user's followers list
      await _usersCollection.doc(targetUserId).update({
        'followers': FieldValue.arrayRemove([currentUserId])
      });

      return true;
    } catch (e) {
      print('Error unfollowing user: $e');
      return false;
    }
  }

  Future<bool> isFollowing(String targetUserId) async {
    final currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) return false;

    try {
      final userDoc = await _usersCollection.doc(currentUserId).get();
      if (!userDoc.exists) return false;

      final data = userDoc.data() as Map<String, dynamic>;
      final following = List<String>.from(data['following'] ?? []);
      return following.contains(targetUserId);
    } catch (e) {
      print('Error checking follow status: $e');
      return false;
    }
  }

  Stream<DocumentSnapshot> getFollowStatus(String targetUserId) {
    final currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return _usersCollection.doc(currentUserId).snapshots();
  }
} 