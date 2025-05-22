import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'mixins/home_mixin.dart';
import 'mixins/local_post_mixin.dart';
import 'mixins/mix_post_mixin.dart';
import 'mixins/new_post_mixin.dart';
import 'mixins/following_post_mixin.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState>
    with HomeMixin, MixPostMixin, NewPostMixin, FollowingPostMixin {
  HomeCubit() : super(HomeInitial()) {
    listenToNewPostScroll();
    listenToMixPostScroll();
  }

  Future<void> getAllPosts() async {
    try {
      emit(HomeLoading());
      await Future.wait([
        getNewPosts(),
        getMixPosts(),
        getFollowedUsers(),
      ]);
      emit(HomeSuccess());
    } catch (_) {
      emit(HomeError());
    }
  }

  @override
  Future<void> close() {
    activeIcon.close();
    newPostListenerClose();
    mixPostListenerClose();
    followingUsersClose();
    return super.close();
  }
}
