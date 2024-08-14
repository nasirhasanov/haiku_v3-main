import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:haiku/data/models/notification_model.dart';
import 'package:haiku/data/repository/notifications_repository.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/extensions/scroll_controller_extensions.dart';
import 'package:rxdart/rxdart.dart';

mixin NotificationsMixin {
  late final  _repository = locator<NotificationRepositoryImpl>();

  late final ScrollController newPostScrollController = ScrollController();

  final List<NotificationModel> _newNotifications = [];
  DocumentSnapshot? _lastDocument;
  bool _isRefresh = false;

  late final _newPostSubject = BehaviorSubject<List<NotificationModel>>();

  ValueStream<List<NotificationModel>> get newNotificationStream => _newPostSubject.stream;

  void listenToNewPostScroll() =>
      newPostScrollController.addListener(_loadMoreNotifications);

  void _loadMoreNotifications() {
    if (newPostScrollController.isLastItem && !_isRefresh) getNewNotifications();
  }

  Future<void> getNewNotifications({bool isRefresh = false}) async {
    try {
      _isRefresh = isRefresh;
      if (isRefresh) await _refreshLastDocument();
      final result = await _repository.getNotifications(lastDocument: _lastDocument);
      if (isRefresh) await _refreshPostList();
      _newNotifications.addAll(result.$1!);
      _lastDocument = result.$2;
      _newPostSubject.add(_newNotifications);
    } catch (_) {
      _newPostSubject.addError('Error getting new notifications');
    } finally {
      _isRefresh = false;
    }
  }

  Future<void> _refreshLastDocument() async => _lastDocument = null;

  Future<void> _refreshPostList() async => _newNotifications.clear();

  void newPostListenerClose() {
    newPostScrollController.removeListener(_loadMoreNotifications);
    newPostScrollController.dispose();
    _newPostSubject.close();
  }
}