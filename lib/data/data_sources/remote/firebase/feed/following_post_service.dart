import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class FollowingPostService {
  late final _usersCollection = FirebaseSingletons.usersCollection;
  
  // Cache following list to avoid frequent fetches
  List<String>? _followingCache;
  
  // Pagination variables
  int _currentPage = 0;
  static const int _usersPerPage = 10;
  
  Future<List<UserInfoModel>?> getFollowedUsers({bool isRefresh = false}) async {
    try {
      final currentUserId = AuthUtils().currentUserId;
      if (currentUserId == null) {
        return [];
      }
      
      // Reset pagination if refreshing
      if (isRefresh) {
        _currentPage = 0;
        _followingCache = null;
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

      // Calculate pagination indexes
      final startIndex = _currentPage * _usersPerPage;
      if (startIndex >= following.length) {
        // No more users to load
        return [];
      }
      
      final endIndex = (startIndex + _usersPerPage < following.length) 
          ? startIndex + _usersPerPage 
          : following.length;
      
      // Get subset of users to load for this page
      final usersToLoad = following.sublist(startIndex, endIndex);
      final List<UserInfoModel> pageUsers = [];
      
      // Firestore's whereIn only supports up to 10 values at a time
      // In this case it works well with our pagination size
      final querySnapshot = await _usersCollection
          .where(FirebaseKeys.uid, whereIn: usersToLoad)
          .get();
      
      for (final doc in querySnapshot.docs) {
        pageUsers.add(UserInfoModel.fromDocumentSnapshot(doc));
      }
      
      // Sort users by name for consistent display
      pageUsers.sort((a, b) => (a.userName ?? '').compareTo(b.userName ?? ''));
      
      // Increment page for next load
      _currentPage++;
      
      return pageUsers;
    } catch (e) {
      print("Error fetching followed users: $e");
      return [];
    }
  }
  
  void resetCache() {
    _followingCache = null;
    _currentPage = 0;
  }
} 