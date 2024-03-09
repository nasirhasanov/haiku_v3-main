import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';

class BestUsersService {
  late final _usersCollection = FirebaseSingletons.usersCollection;

  Future<List<UserInfoModel>?> getBestOfWeekUsers() async {
    try {
          print('Service called');


      final List<UserInfoModel> usersList = [];

      Query query = _usersCollection
          .orderBy(FirebaseKeys.score, descending: true)
          .limit(10);

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        await Future.forEach(querySnapshot.docs, (doc) async {
          usersList.add(UserInfoModel.fromDocumentSnapshot(doc));
        });

        return usersList;
      }
      return (<UserInfoModel>[]);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}