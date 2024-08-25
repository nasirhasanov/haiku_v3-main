import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

import '../../../../../locator.dart';
import '../../../../../utilities/constants/firebase_keys.dart';
import '../../../../models/post_model.dart';

class LocalPostService {
  late final _postsCollection = FirebaseSingletons.postsCollection;

  late final locale = locator<Locale>();

  Future<(List<PostModel>?, DocumentSnapshot?)> getLocalPosts({
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final List<PostModel> postList = [];

      Query query = _postsCollection
          .where(FirebaseKeys.countryCode, isEqualTo: locale.countryCode)
          .orderBy(FirebaseKeys.time, descending: true)
          .limit(10);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;

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
