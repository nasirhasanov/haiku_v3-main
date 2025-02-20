import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/contracts/post_contract.dart';
import '../../../data/models/post_model.dart';
import '../../../locator.dart';
import '../../../utilities/extensions/scroll_controller_extensions.dart';

mixin LocalPostMixin {
  late final PostContract _contract = locator<PostContract>();

  late final ScrollController localPostScrollController = ScrollController();

  final List<PostModel?> _localPosts = [];
  DocumentSnapshot? _lastDocument;
  bool _isRefresh = false;

  late final _localPostSubject = BehaviorSubject<List<PostModel?>>();

  ValueStream<List<PostModel?>> get localPostStream => _localPostSubject.stream;

  void listenToLocalPostScroll() =>
      localPostScrollController.addListener(_loadMorePosts);

  void _loadMorePosts() {
    if (localPostScrollController.isLastItem && !_isRefresh) getLocalPosts();
  }

  Future<void> getLocalPosts({bool isRefresh = false}) async {
    try {
      _isRefresh = isRefresh;
      if (isRefresh) await _refreshLastDocument();
      final result = await _contract.getLocalPosts(lastDocument: _lastDocument);
      if (isRefresh) await _refreshPostList();
      _localPosts.addAll(result.$1!);
      _localPosts.add(null);
      _lastDocument = result.$2;
      _localPostSubject.add(_localPosts);
    } catch (_) {
      _localPostSubject.addError('Error getting new posts');
    } finally {
      _isRefresh = false;
    }
  }

  Future<void> _refreshLastDocument() async => _lastDocument = null;

  Future<void> _refreshPostList() async => _localPosts.clear();

  void localPostListenerClose() {
    localPostScrollController.removeListener(_loadMorePosts);
    localPostScrollController.dispose();
    _localPostSubject.close();
  }
}
