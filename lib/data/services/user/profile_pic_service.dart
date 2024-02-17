import '../../../utilities/helpers/firebase_singletons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfilePicService {
  late final _usersCollection = FirebaseSingletons.usersCollection;

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
    String? userId
    ) async* {
    yield*  FirebaseSingletons.usersCollection.doc(userId).snapshots();
    } 

}


