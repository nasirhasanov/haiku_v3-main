import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/following/following_posts_cubit.dart';
import 'package:haiku/presentation/widgets/app/post/post_widget.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/constants/app_colors.dart';
import 'package:haiku/utilities/constants/app_paddings.dart';

class FollowingPostsPage extends StatefulWidget {
  const FollowingPostsPage({Key? key}) : super(key: key);

  @override
  State<FollowingPostsPage> createState() => _FollowingPostsPageState();
}

class _FollowingPostsPageState extends State<FollowingPostsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<FollowingPostsCubit>().loadFollowingPosts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FollowingPostsCubit>().loadFollowingPosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.following),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<FollowingPostsCubit, FollowingPostsState>(
        builder: (context, state) {
          if (state is FollowingPostsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FollowingPostsLoading && state is! FollowingPostsSuccess) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FollowingPostsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading posts'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FollowingPostsCubit>().refreshPosts();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FollowingPostsSuccess) {
            if (state.posts.isEmpty) {
              return const Center(
                child: Text('No posts from followed users yet'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FollowingPostsCubit>().refreshPosts();
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: AppPaddings.all16,
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return PostWidget(post: post);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
} 