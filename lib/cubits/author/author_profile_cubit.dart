import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/data/contracts/post_contract.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/data/repository/user_repository.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/extensions/scroll_controller_extensions.dart';
import 'package:rxdart/rxdart.dart';

part 'author_profile_state.dart';

class AuthorProfileCubit extends Cubit<AuthorProfileState> {
  AuthorProfileCubit({
    required this.authorId,
  }) : super(AuthorProfileInitial()) {
    listenToMyPostScroll();
  }

  final String authorId;

  Future<void> loadProfile() async {
    try {
      emit(AuthorProfileLoading());
      await Future.wait([
        loadUserInfo(),
        getAuthorPosts(),
      ]);
      emit(AuthorProfileSuccess());
    } catch (_) {
      emit(AuthorProfileError());
    }
  }

  @override
  Future<void> close() {
    myPostListenerClose();
    return super.close();
  }

  late final BehaviorSubject<UserInfoModel?> authorInfoSubject =
      BehaviorSubject<UserInfoModel?>();

  Stream<UserInfoModel?> get authorInfoStream => authorInfoSubject.stream;

  late final _userInfoService = locator<UserRepositoryImpl>();

  late final PostContract _contract = locator<PostContract>();

  late final ScrollController authorPostScrollController = ScrollController();

  final List<PostModel> _authorPosts = [];
  DocumentSnapshot? _lastDocument;
  bool _isRefresh = false;

  late final _authorPostSubject = BehaviorSubject<List<PostModel>>();

  ValueStream<List<PostModel>> get authorPostStream => _authorPostSubject.stream;

  Future<void> loadUserInfo() async {
    final userInfo = await _userInfoService.getProfileInfo(authorId);
    if (userInfo != null) {
      authorInfoSubject.sink.add(userInfo);
    } else {
      authorInfoSubject.sink.add(null);
    }
    }

  void listenToMyPostScroll() =>
      authorPostScrollController.addListener(_loadMorePosts);

  void _loadMorePosts() {
    if (authorPostScrollController.isLastItem && !_isRefresh) getAuthorPosts();
  }

  Future<void> getAuthorPosts({bool isRefresh = false}) async {
    try {
      _isRefresh = isRefresh;
      if (isRefresh) await _refreshLastDocument();
      final result = await _contract.getAuthorPosts(
        authorId: authorId,
        lastDocument: _lastDocument,
      );
      if (isRefresh) await _refreshPostList();
      _authorPosts.addAll(result.$1!);
      _lastDocument = result.$2;
      _authorPostSubject.add(_authorPosts);
    } catch (_) {
      _authorPostSubject.addError('Error getting my posts');
    } finally {
      _isRefresh = false;
    }
  }

  Future<void> _refreshLastDocument() async => _lastDocument = null;

  Future<void> _refreshPostList() async => _authorPosts.clear();

  void myPostListenerClose() {
    authorPostScrollController.removeListener(_loadMorePosts);
    authorPostScrollController.dispose();
    _authorPostSubject.close();
  }
}
