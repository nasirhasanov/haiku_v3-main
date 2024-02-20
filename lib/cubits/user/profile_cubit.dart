import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/user/profile_mixin.dart';
import 'package:haiku/data/repository/user_repository.dart';
import 'package:haiku/locator.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> with ProfileMixin {
  ProfileCubit() : super(ProfileInitial()) {
    listenToMyPostScroll();
  }

  late final _userInfoService = locator<UserRepositoryImpl>();

  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());
      await Future.wait([
        loadUserInfo(),
        getMyPosts(),
      ]);
      emit(ProfileSuccess());
    } catch (_) {
      emit(ProfileError());
    }
  }

  @override
  Future<void> close() {
    myPostListenerClose();
    return super.close();
  }

  Future<bool?> uploadUserPic(Uint8List uploadPic) async {
    return await _userInfoService.uploadProfilePic(uploadPic);
  }

    Future<bool?> removeUserPic() async {
    return await _userInfoService.removeProfilePic();
  }
}
