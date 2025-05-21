import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

import '../../../../cubits/home/home_cubit.dart';
import '../../../widgets/global/global_loading.dart';
import '../widgets/feed_builder.dart';
import '../widgets/headers/feed_app_bar_widget.dart';

class FeedView extends StatelessWidget {
  final TabController tabController;
  const FeedView({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) =>
          [FeedAppBarWidget(tabController: tabController)],
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const GlobalLoading();
          } else if (state is HomeSuccess) {
            return TabBarView(
              controller: tabController,
              children: [
                FeedBuilder(
                  scrollController: cubit.newPostScrollController,
                  stream: cubit.newPostStream,
                  onRefresh: () async =>
                      await cubit.getNewPosts(isRefresh: true),
                  isSliver: false,
                ),
                FeedBuilder(
                  scrollController: cubit.mixPostScrollController,
                  stream: cubit.mixPostStream,
                  onRefresh: () => cubit.getMixPosts(isRefresh: true),
                  isSliver: false,
                ),
                FeedBuilder(
                  scrollController: cubit.localPostScrollController,
                  stream: cubit.localPostStream,
                  onRefresh: () => cubit.getLocalPosts(isRefresh: true),
                  isSliver: false,
                ),
                FeedBuilder(
                  scrollController: cubit.followingPostScrollController,
                  stream: cubit.followingPostStream,
                  onRefresh: () => cubit.getFollowingPosts(isRefresh: true),
                  isSliver: false,
                ),
              ],
            );
          }
          return nil;
        },
      ),
    );
  }
}


// return CustomScrollView(
//       controller: cubit.newPostScrollController,
//       slivers: [
//         FeedAppBarWidget(tabController: tabController),
//         BlocBuilder<HomeCubit, HomeState>(
//           builder: (context, state) {
//             if (state is HomeLoading || state is HomeInitial) {
//               return SliverToBoxAdapter(child: const GlobalLoading());
//             } else if (state is HomeSuccess) {
//               return tabList(cubit).elementAt(tabController.index);
//             }
//             return SliverToBoxAdapter(child: nil);
//           },
//         ),
//       ],
//     );
