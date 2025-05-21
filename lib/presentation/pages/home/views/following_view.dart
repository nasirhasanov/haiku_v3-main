import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/following/following_posts_cubit.dart';
import 'package:haiku/presentation/pages/home/widgets/feed_list_view.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_texts.dart';

class FollowingView extends StatelessWidget {
  const FollowingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowingPostsCubit, FollowingPostsState>(
      builder: (context, state) {
        if (state is FollowingPostsInitial) {
          return const Center(child: Text(AppTexts.followed));
        }
        
        if (state is FollowingPostsLoading) {
          return const GlobalLoading();
        }
        
        if (state is FollowingPostsError) {
          return const Center(child: Text(AppTexts.anErrorOccurred));
        }
        
        if (state is FollowingPostsSuccess) {
          if (state.posts.isEmpty) {
            return const Center(child: Text(AppTexts.followed));
          }
          
          return FeedListView(
            posts: state.posts,
            scrollController: context.read<FollowingPostsCubit>().scrollController,
            onRefresh: () => context.read<FollowingPostsCubit>().getFollowingPosts(),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
} 