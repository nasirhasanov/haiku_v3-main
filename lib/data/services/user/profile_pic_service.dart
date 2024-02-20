import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';

import '../../../utilities/helpers/firebase_singletons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePicService {
  late final _usersCollection = FirebaseSingletons.usersCollection;
  final storageRef =
      FirebaseStorage.instance.ref().child(FirebaseKeys.profilePicFolder);

  Future<String?> getProfilePicURL(String userId) async {
    try {
      final documentSnaphot = await _usersCollection.doc(userId).get();

      if (documentSnaphot.exists) {
        Map<String, dynamic> data =
            documentSnaphot.data() as Map<String, dynamic>;
        final String? profilePictureUrl = data['profile_pic_path'];
        return profilePictureUrl;
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Stream<DocumentSnapshot<Object?>> getProfilePicURLStream(
      String? userId) async* {
    yield* FirebaseSingletons.usersCollection.doc(userId).snapshots();
  }

  Future<bool?> uploadProfilePic(Uint8List userPic) async {
    final userId = AuthUtils().currentUserId;
    if (userId != null) {
      try {
        await storageRef.child(userId).putData(userPic);
        var downloadUrl = await storageRef.child(userId).getDownloadURL();
        await _usersCollection.doc(userId).update({
          FirebaseKeys.profilePicPath: downloadUrl,
        });
        return true;
      } on FirebaseException {
        return false;
      }
    }
    return false;
  }

    Future<bool?> removeProfilePic() async {
    final userId = AuthUtils().currentUserId;
    if (userId != null) {
      try {
        await storageRef.child(userId).delete();
        await _usersCollection.doc(userId).update({
          FirebaseKeys.profilePicPath: null,
        });
        return true;
      } on FirebaseException {
        return false;
      }
    }
    return false;
  }
}
