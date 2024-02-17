import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/contracts/post_contract.dart';
import '../../../data/models/post_model.dart';
import '../../../locator.dart';
import '../../../utilities/extensions/scroll_controller_extensions.dart';

mixin NewPostMixin {
  late final PostContract _contract = locator<PostContract>();

  late final ScrollController newPostScrollController = ScrollController();

  final List<PostModel> _newPosts = [];
  DocumentSnapshot? _lastDocument;
  bool _isRefresh = false;

  late final _newPostSubject = BehaviorSubject<List<PostModel>>();

  ValueStream<List<PostModel>> get newPostStream => _newPostSubject.stream;

  void listenToNewPostScroll() =>
      newPostScrollController.addListener(_loadMorePosts);

  void _loadMorePosts() {
    if (newPostScrollController.isLastItem && !_isRefresh) getNewPosts();
  }

  Future<void> getNewPosts({bool isRefresh = false}) async {
    try {
      _isRefresh = isRefresh;
      if (isRefresh) await _refreshLastDocument();
      final result = await _contract.getNewPosts(lastDocument: _lastDocument);
      if (isRefresh) await _refreshPostList();
      _newPosts.addAll(result.$1!);
      _lastDocument = result.$2;
      _newPostSubject.add(_newPosts);
    } catch (_) {
      _newPostSubject.addError('Error getting new posts');
    } finally {
      _isRefresh = false;
    }
  }

  Future<void> _refreshLastDocument() async => _lastDocument = null;

  Future<void> _refreshPostList() async => _newPosts.clear();

  void newPostListenerClose() {
    newPostScrollController.removeListener(_loadMorePosts);
    newPostScrollController.dispose();
    _newPostSubject.close();
  }
}
