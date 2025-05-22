import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class FollowingPostService {
  late final _usersCollection = FirebaseSingletons.usersCollection;
  
  // Cache following list to avoid frequent fetches
  List<String>? _followingCache;
  
  Future<List<UserInfoModel>?> getFollowedUsers() async {
    try {
      final currentUserId = AuthUtils().currentUserId;
      if (currentUserId == null) {
        return [];
      }
      
      // Get or use cached following list
      List<String> following;
      if (_followingCache != null) {
        following = _followingCache!;
      } else {
        final userDoc = await _usersCollection.doc(currentUserId).get();
        if (!userDoc.exists) {
          return [];
        }
        
        final data = userDoc.data() as Map<String, dynamic>;
        following = List<String>.from(data[FirebaseKeys.following] ?? []);
        _followingCache = following;
        
        if (following.isEmpty) {
          return [];
        }
      }

      // Firestore's whereIn only supports up to 10 values at a time
      final List<UserInfoModel> allUsers = [];
      
      // Process in batches of 10
      for (int i = 0; i < following.length; i += 10) {
        final endIdx = (i + 10 < following.length) ? i + 10 : following.length;
        final batch = following.sublist(i, endIdx);
        
        final querySnapshot = await _usersCollection
            .where(FirebaseKeys.uid, whereIn: batch)
            .get();
        
        for (final doc in querySnapshot.docs) {
          allUsers.add(UserInfoModel.fromDocumentSnapshot(doc));
        }
      }
      
      // Sort users by name for consistent display
      allUsers.sort((a, b) => (a.userName ?? '').compareTo(b.userName ?? ''));
      
      return allUsers;
    } catch (e) {
      print("Error fetching followed users: $e");
      return [];
    }
  }
  
  void resetCache() {
    _followingCache = null;
  }
} 