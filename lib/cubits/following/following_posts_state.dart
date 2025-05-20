part of 'following_posts_cubit.dart';

abstract class FollowingPostsState extends Equatable {
  const FollowingPostsState();

  @override
  List<Object?> get props => [];
}

class FollowingPostsInitial extends FollowingPostsState {}

class FollowingPostsLoading extends FollowingPostsState {}

class FollowingPostsSuccess extends FollowingPostsState {
  final List<PostModel> posts;

  const FollowingPostsSuccess(this.posts);

  @override
  List<Object?> get props => [posts];
}

class FollowingPostsError extends FollowingPostsState {} 