import 'package:flutter/foundation.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/user_info_service.dart';

import '../data_sources/remote/firebase/user/profile_pic_service.dart';

abstract class UserRepositoryImpl {
  Future<String?> getProfilePicURL(String userId);
  Future<UserInfoModel?> getProfileInfo(String userId);
  Future<bool?> uploadProfilePic(Uint8List userPic);
  Future<bool?> removeProfilePic();
  Future<bool?> changeBio(String bio);
  Future<bool?> deleteUser();
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
  Future<bool?> removeProfilePic() => _profilePicService.removeProfilePic();

  @override
  Future<bool?> changeBio(String bio) => _userInfoService.changeUserBio(bio);

  @override
  Future<bool?> deleteUser() => _userInfoService.deleteThisUserInfo();
}
