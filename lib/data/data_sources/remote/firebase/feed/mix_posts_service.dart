import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

import '../../../../models/post_model.dart';

class MixPostsService {
  late final _postsCollection = FirebaseSingletons.postsCollection;


  bool firstPartEnded = false;

  Future<(List<PostModel>?, DocumentSnapshot?)> getMixPosts({
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final List<PostModel> postList = [];
      final String randomId = _postsCollection.doc().id;

      Query firstQuery = _postsCollection
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: randomId)
          .limit(10);

      Query secondQuery = _postsCollection
          .where(FieldPath.documentId, isLessThan: randomId)
          .limit(10);

      if (lastDocument != null) {
        firstQuery = firstQuery.startAfterDocument(lastDocument);
        secondQuery = secondQuery.startAfterDocument(lastDocument);
      }

      final query = firstPartEnded ? secondQuery : firstQuery;

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;

        if (querySnapshot.size < 10) {
          if (!firstPartEnded) {
            firstPartEnded = true;
            await getMixPosts(lastDocument: lastDocument);
          }
        }

        await Future.forEach(querySnapshot.docs, (doc) async {
          postList.add(PostModel.fromDocumentSnapshot(doc));
        });

        return (postList, lastDocument);
      }

      return (<PostModel>[], lastDocument);
    } catch (e) {
      throw Exception(e);
    }
  }
}
