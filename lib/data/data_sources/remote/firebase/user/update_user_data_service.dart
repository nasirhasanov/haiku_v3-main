import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class UpdateUserDataService {

  Future<bool> update(
    String? username,
    String? uid,
    String? email,
    String? bio,
    int? score,
    int? popularity,
  ) async {
    final userDoc = {
      FirebaseKeys.username: username,
      FirebaseKeys.uid: uid,
      FirebaseKeys.email: email,
      FirebaseKeys.bio: bio,
      FirebaseKeys.score: score,
      FirebaseKeys.popularity: popularity,
    };

    try {
      await FirebaseSingletons.usersCollection.doc(uid).set(userDoc);
      return true; // Success
    } catch (e) {
      print(e); // Log the error
      return false; // Failure
    }
  }
}
