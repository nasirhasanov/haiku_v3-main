import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/data/data_sources/remote/firebase/feed/author_posts_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/feed/my_post_service.dart';

import '../contracts/post_contract.dart';
import '../models/post_model.dart';
import '../data_sources/remote/firebase/feed/local_post_service.dart';
import '../data_sources/remote/firebase/feed/mix_posts_service.dart';
import '../data_sources/remote/firebase/feed/new_post_service.dart';
import '../data_sources/remote/firebase/feed/following_post_service.dart';

class PostRepository implements PostContract {
  PostRepository(
    this._newPostService,
    this._mixPostsService,
    this._localPostsService,
    this._myPostsService,
    this._authorPostsService,
    this._followingPostService,
  );

  final NewPostService _newPostService;
  final MixPostsService _mixPostsService;
  final LocalPostService _localPostsService;
  final MyPostService _myPostsService;
  final AuthorPostService _authorPostsService;
  final FollowingPostService _followingPostService;

  @override
  Future<(List<PostModel>?, DocumentSnapshot?)> getNewPosts(
          {DocumentSnapshot? lastDocument}) =>
      _newPostService.getNewPosts(lastDocument: lastDocument);

  @override
  Future<(List<PostModel>?, DocumentSnapshot?)> getMixPosts(
          {DocumentSnapshot? lastDocument}) =>
      _mixPostsService.getMixPosts(lastDocument: lastDocument);

  @override
  Future<(List<PostModel>?, DocumentSnapshot?)> getLocalPosts(
          {DocumentSnapshot? lastDocument}) =>
      _localPostsService.getLocalPosts(lastDocument: lastDocument);

  @override
  Future<(List<PostModel>?, DocumentSnapshot?)> getMyPosts(
          {DocumentSnapshot? lastDocument}) =>
      _myPostsService.getMyPosts(lastDocument: lastDocument);

  @override
  Future<(List<PostModel>?, DocumentSnapshot?)> getAuthorPosts({
    required String authorId,
    DocumentSnapshot? lastDocument,
  }) =>
      _authorPostsService.getAuthorPosts(
          authorId: authorId, lastDocument: lastDocument);

  @override
  Future<(List<PostModel>?, DocumentSnapshot?)> getFollowingPosts({
    DocumentSnapshot? lastDocument,
  }) =>
      _followingPostService.getFollowingPosts(lastDocument: lastDocument);

  @override
  Future<PostModel?> getPost(String postId) =>
      _myPostsService.getPost(postId: postId);
}
