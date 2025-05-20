import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class FollowService {
  late final _usersCollection = FirebaseSingletons.usersCollection;

  Future<void> followUser(String userId) async {
    try {
      final currentUserId = AuthUtils().currentUserId;
      if (currentUserId == null) return;

      // Add to current user's following list
      await _usersCollection.doc(currentUserId).update({
        FirebaseKeys.following: FieldValue.arrayUnion([userId])
      });

      // Add to target user's followers list
      await _usersCollection.doc(userId).update({
        FirebaseKeys.followers: FieldValue.arrayUnion([currentUserId])
      });
    } catch (e) {
      print('Error following user: $e');
      throw Exception(e);
    }
  }

  Future<void> unfollowUser(String userId) async {
    try {
      final currentUserId = AuthUtils().currentUserId;
      if (currentUserId == null) return;

      // Remove from current user's following list
      await _usersCollection.doc(currentUserId).update({
        FirebaseKeys.following: FieldValue.arrayRemove([userId])
      });

      // Remove from target user's followers list
      await _usersCollection.doc(userId).update({
        FirebaseKeys.followers: FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      print('Error unfollowing user: $e');
      throw Exception(e);
    }
  }

  Stream<bool> isFollowing(String userId) {
    final currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) return Stream.value(false);

    return _usersCollection.doc(currentUserId).snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return false;
      final following = List<String>.from(data[FirebaseKeys.following] ?? []);
      return following.contains(userId);
    });
  }

  Stream<List<String>> getFollowingStream() {
    final currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) return Stream.value([]);

    return _usersCollection.doc(currentUserId).snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return [];
      return List<String>.from(data[FirebaseKeys.following] ?? []);
    });
  }

  Stream<List<String>> getFollowersStream() {
    final currentUserId = AuthUtils().currentUserId;
    if (currentUserId == null) return Stream.value([]);

    return _usersCollection.doc(currentUserId).snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return [];
      return List<String>.from(data[FirebaseKeys.followers] ?? []);
    });
  }
} 