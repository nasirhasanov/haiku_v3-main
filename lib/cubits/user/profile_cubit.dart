import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/user/profile_mixin.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> with ProfileMixin {
  ProfileCubit() : super(ProfileInitial()) {
    listenToMyPostScroll();
  }
  final storageRef =
      FirebaseStorage.instance.ref().child(FirebaseKeys.profilePicFolder);

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

  Future<bool> uploadUserPic() async {}
}
