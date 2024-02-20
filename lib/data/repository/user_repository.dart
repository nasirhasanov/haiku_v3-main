import 'package:flutter/foundation.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/data/services/user/user_info_service.dart';

import '../services/user/profile_pic_service.dart';

abstract class UserRepositoryImpl {
  Future<String?> getProfilePicURL(String userId);
  Future<UserInfoModel?> getProfileInfo(String userId);
  Future<bool?> uploadProfilePic(Uint8List userPic);
  Future<bool?> removeProfilePic();
}

class UserRepository implements UserRepositoryImpl {
  UserRepository(this._profilePicService, this._userInfoService);

  final ProfilePicService _profilePicService;
  final UserInfoService _userInfoService;

  @override
  Future<String?> getProfilePicURL(String userId) =>
      _profilePicService.getProfilePicURL(userId);

  @override
  Future<UserInfoModel?> getProfileInfo(String userId) =>
      _userInfoService.getProfileInfo(userId);

  @override
  Future<bool?> uploadProfilePic(Uint8List userPic) =>
      _profilePicService.uploadProfilePic(userPic);

  @override
  Future<bool?> removeProfilePic() =>
      _profilePicService.removeProfilePic();
}
