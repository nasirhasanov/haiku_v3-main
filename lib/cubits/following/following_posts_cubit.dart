import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/data/data_sources/remote/firebase/post/following_posts_service.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/locator.dart';

part 'following_posts_state.dart';

class FollowingPostsCubit extends Cubit<FollowingPostsState> {
  FollowingPostsCubit() : super(FollowingPostsInitial());

  late final _followingPostsService = locator<FollowingPostsService>();
  final List<PostModel> _posts = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;

  Future<void> loadFollowingPosts() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      emit(FollowingPostsLoading());

      final posts = await _followingPostsService.getFollowingPosts(
        lastDocument: _lastDocument,
      );

      if (posts.isNotEmpty) {
        _lastDocument = await _followingPostsService._postsCollection
            .doc(posts.last.postId)
            .get();
        _posts.addAll(posts);
      }

      emit(FollowingPostsSuccess(_posts));
    } catch (e) {
      emit(FollowingPostsError());
    } finally {
      _isLoading = false;
    }
  }

  void refreshPosts() {
    _posts.clear();
    _lastDocument = null;
    loadFollowingPosts();
  }

  @override
  Future<void> close() {
    _posts.clear();
    return super.close();
  }
} 