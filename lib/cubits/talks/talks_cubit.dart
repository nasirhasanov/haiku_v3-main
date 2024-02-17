import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/data/models/talk_model.dart';
import 'package:haiku/data/repository/talks_repository.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/extensions/scroll_controller_extensions.dart';
import 'package:rxdart/rxdart.dart';

part 'talks_state.dart';

class TalksCubit extends Cubit<TalksState> {
  TalksCubit({
    required this.postId,
    required this.posterId,
  }) : super(TalksInitial()) {
    listenToMyPostScroll();
  }
  final String postId;
  final String posterId;

  Future<void> getPostTalks() async {
    try {
      emit(TalksLoading());
      await Future.wait([
        getTalks(),
      ]);
      emit(TalksSuccess());
    } catch (_) {
      emit(TalksError());
    }
  }

  Future<bool> sendTalk({
    required String talkText,
    required String postId,
    required String posterId,
  }) async {
    try {
      return await _contract.sendTalk(
        talkText: talkText,
        postId: postId,
        posterId: posterId,
      );
    } catch (_) {
      return false;
    }
  }

  late final _contract = locator<TalksRepositoryImpl>();

  late final ScrollController talksScrollController = ScrollController();

  final List<TalkModel> _talks = [];
  DocumentSnapshot? _lastDocument;
  bool _isRefresh = false;

  late final _talksSubject = BehaviorSubject<List<TalkModel>>();

  ValueStream<List<TalkModel>> get talksStream => _talksSubject.stream;

  void listenToMyPostScroll() =>
      talksScrollController.addListener(_loadMoreTalks);

  void _loadMoreTalks() {
    if (talksScrollController.isLastItem && !_isRefresh) getTalks();
  }

  Future<void> getTalks({
    bool isRefresh = false,
  }) async {
    try {
      _isRefresh = isRefresh;
      if (isRefresh) await _refreshLastDocument();
      final result = await _contract.getTalks(
        postId: postId,
        lastDocument: _lastDocument,
      );
      if (isRefresh) await _refreshPostList();
      _talks.addAll(result.$1!);
      _lastDocument = result.$2;
      _talksSubject.add(_talks);
    } catch (_) {
      _talksSubject.addError('Error getting talks');
    } finally {
      _isRefresh = false;
    }
  }

  Future<void> _refreshLastDocument() async => _lastDocument = null;

  Future<void> _refreshPostList() async => _talks.clear();

  void myPostListenerClose() {
    talksScrollController.removeListener(_loadMoreTalks);
    talksScrollController.dispose();
    _talksSubject.close();
  }

  @override
  Future<void> close() {
    myPostListenerClose();
    return super.close();
  }
}
