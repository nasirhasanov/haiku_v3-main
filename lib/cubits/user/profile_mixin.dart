import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haiku/data/contracts/post_contract.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/data/repository/location_repository.dart';
import 'package:haiku/data/repository/user_repository.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/extensions/scroll_controller_extensions.dart';
import 'package:rxdart/rxdart.dart';

mixin ProfileMixin {
  late final BehaviorSubject<UserInfoModel?> userInfoSubject =
      BehaviorSubject<UserInfoModel?>();

  Stream<UserInfoModel?> get userInfoStream => userInfoSubject.stream;

  late final _userInfoService = locator<UserRepositoryImpl>();

  late final _locationService = locator<LocationRepositoryImpl>();

  late final PostContract _contract = locator<PostContract>();

  late final ScrollController myPostScrollController = ScrollController();

  final List<PostModel> _myPosts = [];
  DocumentSnapshot? _lastDocument;
  bool _isRefresh = false;

  late final _myPostSubject = BehaviorSubject<List<PostModel>>();

  ValueStream<List<PostModel>> get myPostStream => _myPostSubject.stream;

  Future<void> loadUserInfo() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {

      final userInfo = await _userInfoService.getProfileInfo(userId);
      if (userInfo != null) {
        userInfoSubject.sink.add(userInfo);
      } else {
        userInfoSubject.sink.add(null);
      }
    } 
    updateLocationInfo();
  }

  void listenToMyPostScroll() =>
      myPostScrollController.addListener(_loadMorePosts);

  void _loadMorePosts() {
    if (myPostScrollController.isLastItem && !_isRefresh) getMyPosts();
  }

  Future<void> getMyPosts({bool isRefresh = false}) async {
    try {
      _isRefresh = isRefresh;
      if (isRefresh) await _refreshLastDocument();
      final result = await _contract.getMyPosts(lastDocument: _lastDocument);
      if (isRefresh) await _refreshPostList();
      _myPosts.addAll(result.$1!);
      _lastDocument = result.$2;
      _myPostSubject.add(_myPosts);
    } catch (_) {
      _myPostSubject.addError('Error getting my posts');
    } finally {
      _isRefresh = false;
    }
  }

  Future<void> _refreshLastDocument() async => _lastDocument = null;

  Future<void> _refreshPostList() async => _myPosts.clear();


  void updateLocationInfo() async {
     _locationService.updateCurrentLocationInfo();
  }

  void myPostListenerClose() {
    myPostScrollController.removeListener(_loadMorePosts);
    myPostScrollController.dispose();
    _myPostSubject.close();
  }
}
