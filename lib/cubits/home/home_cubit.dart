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

  // Track which tabs have been loaded
  final Map<int, bool> _loadedTabs = {0: false, 1: false, 2: false};

  // Load only new posts initially
  Future<void> loadInitialFeed() async {
    try {
      emit(HomeLoading());
      await getNewPosts();
      _loadedTabs[0] = true;
      emit(HomeSuccess());
    } catch (_) {
      emit(HomeError());
    }
  }

  // Load content for a specific tab if not loaded already
  Future<void> loadTabContent(int tabIndex) async {
    if (_loadedTabs[tabIndex] == true) return;

    try {
      switch (tabIndex) {
        case 0:
          await getNewPosts();
          break;
        case 1:
          await getMixPosts();
          break;
        case 2:
          await getFollowedUsers();
          break;
      }
      _loadedTabs[tabIndex] = true;
    } catch (_) {
      // Error handling if needed
    }
  }

  // Legacy method kept for compatibility
  Future<void> getAllPosts() async {
    try {
      emit(HomeLoading());
      await Future.wait([
        getNewPosts(),
        getMixPosts(),
        getFollowedUsers(),
      ]);
      _loadedTabs[0] = true;
      _loadedTabs[1] = true;
      _loadedTabs[2] = true;
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
