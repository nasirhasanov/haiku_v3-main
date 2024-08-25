import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class DeleteStoryService {

  Future<bool> deleteStory(String postId) async {
    try {
      await FirebaseSingletons.postsCollection.doc(postId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}