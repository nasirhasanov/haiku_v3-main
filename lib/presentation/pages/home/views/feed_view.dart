import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

import '../../../../cubits/home/home_cubit.dart';
import '../../../../data/models/user_info_model.dart';
import '../../../widgets/global/global_loading.dart';
import '../widgets/feed_builder.dart';
import '../widgets/followed_users_list_view.dart';
import '../widgets/headers/feed_app_bar_widget.dart';

class FeedView extends StatefulWidget {
  final TabController tabController;
  const FeedView({super.key, required this.tabController});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> with SingleTickerProviderStateMixin {
  late HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeCubit>();
    
    // Listen for tab changes to load content on demand
    widget.tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    // Only load content when the tab is fully selected (not during animation)
    if (!widget.tabController.indexIsChanging) {
      _cubit.loadTabContent(widget.tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) =>
          [FeedAppBarWidget(tabController: widget.tabController)],
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const GlobalLoading();
          } else if (state is HomeSuccess) {
            return TabBarView(
              controller: widget.tabController,
              children: [
                FeedBuilder(
                  scrollController: _cubit.newPostScrollController,
                  stream: _cubit.newPostStream,
                  onRefresh: () async =>
                      await _cubit.getNewPosts(isRefresh: true),
                  isSliver: false,
                ),
                FeedBuilder(
                  scrollController: _cubit.mixPostScrollController,
                  stream: _cubit.mixPostStream,
                  onRefresh: () => _cubit.getMixPosts(isRefresh: true),
                  isSliver: false,
                ),
                // For the following tab, show users instead of posts
                StreamBuilder<List<UserInfoModel>?>(
                  stream: _cubit.followedUsersStream,
                  builder: (context, snapshot) {
                    return FollowedUsersListView(
                      users: snapshot.data ?? [],
                      onRefresh: () => _cubit.getFollowedUsers(isRefresh: true),
                    );
                  },
                )
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
