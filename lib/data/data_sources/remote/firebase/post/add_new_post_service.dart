import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:hive/hive.dart';

class AddPostService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> attemptToPost(
    String postText,
    String userName,
  ) async {
    final userId = _firebaseAuth.currentUser?.uid;
    late final locale = locator<Locale>();
    var box = Hive.box(AppKeys.locationBox);
    final countryCode = box.get(AppKeys.countryCode);
    final latitude = box.get(AppKeys.latitude);
    final longitude = box.get(AppKeys.longitude);

    if (userName.isNotEmpty && userId != null && postText.isNotEmpty) {
      final postDoc = {
        FirebaseKeys.postText: postText,
        FirebaseKeys.username: userName,
        FirebaseKeys.posterUserId: userId,
        FirebaseKeys.clapCount: 0,
        FirebaseKeys.popularity: 0,
        FirebaseKeys.postTime: FieldValue.serverTimestamp(),
        FirebaseKeys.popularityResetTime: FieldValue.serverTimestamp(),
        FirebaseKeys.countryCode: countryCode ?? locale.countryCode,
        FirebaseKeys.latitude: latitude,
        FirebaseKeys.longitude: longitude,
      };

      try {
        await _firestore.collection(FirebaseKeys.posts).add(postDoc);
        return true; // Success
      } catch (e) {
        print(e); // Log the error
        return false; // Failure
      }
    }
    return false; // Invalid input
  }
}
