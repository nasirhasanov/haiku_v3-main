import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/firebase_singletons.dart';
import 'package:hive/hive.dart';

class UserInfoService {
  late final _usersCollection = FirebaseSingletons.usersCollection;

  Future<UserInfoModel?> getProfileInfo(String userId) async {
    try {
      final documentSnaphot = await _usersCollection.doc(userId).get();
      if (documentSnaphot.exists) {
        final UserInfoModel profileInfo =
            UserInfoModel.fromDocumentSnapshot(documentSnaphot);
        if (userId == AuthUtils().currentUserId) {
          _saveLocalProfileInfo(profileInfo);
        }
        return profileInfo;
      }
      print('User info is null');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _saveLocalProfileInfo(UserInfoModel userInfo) async {
    var box = Hive.box(AppKeys.userDataBox);
    await box.put(AppKeys.bio, userInfo.bio ?? '');
    await box.put(AppKeys.deviceToken, userInfo.deviceToken ?? '');
    await box.put(AppKeys.email, userInfo.email ?? '');
    await box.put(AppKeys.profilePicPath, userInfo.profilePicPath ?? '');
    await box.put(AppKeys.score, userInfo.score);
    await box.put(AppKeys.userId, userInfo.userId);
    await box.put(AppKeys.username, userInfo.userName);
  }

  static String? getInfo(String key) {
    var box = Hive.box(AppKeys.userDataBox);
    return box.get(key);
  }
}
