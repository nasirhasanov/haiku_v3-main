import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/contracts/post_contract.dart';
import '../../../data/models/post_model.dart';
import '../../../locator.dart';
import '../../../utilities/extensions/scroll_controller_extensions.dart';

mixin MixPostMixin {
  late final PostContract _contract = locator<PostContract>();

  late final ScrollController mixPostScrollController = ScrollController();

  final List<PostModel> _mixPosts = [];
  DocumentSnapshot? _lastDocument;
  bool _isRefresh = false;

  late final _mixPostSubject = BehaviorSubject<List<PostModel>>();

  ValueStream<List<PostModel>> get mixPostStream => _mixPostSubject.stream;

  void listenToMixPostScroll() =>
      mixPostScrollController.addListener(_loadMorePosts);

  void _loadMorePosts() {
    if (mixPostScrollController.isLastItem && !_isRefresh) getMixPosts();
  }

  Future<void> getMixPosts({bool isRefresh = false}) async {
    try {
      _isRefresh = isRefresh;
      if (isRefresh) await _refreshLastDocument();
      final result = await _contract.getMixPosts(lastDocument: _lastDocument);
      if (isRefresh) await _refreshPostList();
      _mixPosts.addAll(result.$1!);
      _lastDocument = result.$2;
      _mixPostSubject.add(_mixPosts);
    } catch (_) {
      _mixPostSubject.addError('Error getting mix posts');
    } finally {
      _isRefresh = false;
    }
  }

  Future<void> _refreshLastDocument() async => _lastDocument = null;

  Future<void> _refreshPostList() async => _mixPosts.clear();

  void mixPostListenerClose() {
    mixPostScrollController.removeListener(_loadMorePosts);
    mixPostScrollController.dispose();
    _mixPostSubject.close();
  }
}
