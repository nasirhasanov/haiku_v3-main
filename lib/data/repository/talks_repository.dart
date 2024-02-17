import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/models/talk_model.dart';
import 'package:haiku/data/services/talks/talks_service.dart';

abstract class TalksRepositoryImpl {
  Future<(List<TalkModel>?, DocumentSnapshot?)> getTalks({
    required String postId,
    DocumentSnapshot? lastDocument,
  });

  Future<bool> sendTalk({
    required String talkText,
    required String postId,
    required String posterId,
  });
}

class TalksRepository implements TalksRepositoryImpl {
  TalksRepository(this._talksService);

  final TalksService _talksService;

  @override
  Future<(List<TalkModel>?, DocumentSnapshot?)> getTalks({
    required String postId,
    DocumentSnapshot? lastDocument,
  }) =>
      _talksService.getAllTalks(
        postId: postId,
        lastDocument: lastDocument,
      );

  @override
  Future<bool> sendTalk({
    required String talkText,
    required String postId,
    required String posterId,
  }) async =>
      await _talksService.attemptToTalk(
        talkText: talkText,
        postId: postId,
        posterId: posterId,
      );
}
