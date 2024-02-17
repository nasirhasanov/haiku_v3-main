import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../utilities/helpers/firebase_singletons.dart';

class UsernameService {
  late final _usersCollection = FirebaseSingletons.usersCollection;

  Future<String?> checkUsernameExist(String username) async {
    try {
      final Query query =
          _usersCollection.where('username', isEqualTo: username);
      print('query: $query');

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return data['username'];
      }

      return null;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }
}
