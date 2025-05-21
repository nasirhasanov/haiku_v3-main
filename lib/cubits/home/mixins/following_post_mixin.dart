import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/contracts/post_contract.dart';
import '../../../data/models/post_model.dart';
import '../../../locator.dart';
import '../../../utilities/extensions/scroll_controller_extensions.dart';

mixin FollowingPostMixin {
  late final PostContract _contract = locator<PostContract>();

  late final ScrollController followingPostScrollController = ScrollController();

  final List<PostModel?> _followingPosts = [];
  DocumentSnapshot? _lastDocument;
  bool _isRefresh = false;

  late final _followingPostSubject = BehaviorSubject<List<PostModel?>>();

  ValueStream<List<PostModel?>> get followingPostStream => _followingPostSubject.stream;

  void listenToFollowingPostScroll() =>
      followingPostScrollController.addListener(_loadMorePosts);

  void _loadMorePosts() {
    if (followingPostScrollController.isLastItem && !_isRefresh) getFollowingPosts();
  }

  Future<void> getFollowingPosts({bool isRefresh = false}) async {
    try {
      _isRefresh = isRefresh;
      if (isRefresh) await _refreshLastDocument();
      final result = await _contract.getFollowingPosts(lastDocument: _lastDocument);
      if (isRefresh) await _refreshPostList();
      _followingPosts.addAll(result.$1!);
      _followingPosts.add(null);
      _lastDocument = result.$2;
      _followingPostSubject.add(_followingPosts);
    } catch (_) {
      _followingPostSubject.addError('Error getting following posts');
    } finally {
      _isRefresh = false;
    }
  }

  Future<void> _refreshLastDocument() async => _lastDocument = null;

  Future<void> _refreshPostList() async => _followingPosts.clear();

  void followingPostListenerClose() {
    followingPostScrollController.removeListener(_loadMorePosts);
    followingPostScrollController.dispose();
    _followingPostSubject.close();
  }
} 