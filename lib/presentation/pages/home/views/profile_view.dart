import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/user/profile_cubit.dart';
import '../widgets/feed_builder.dart';
import '../widgets/headers/profile_gift_app_bar_widget.dart';
import '../widgets/headers/profile_info_app_bar_widget.dart';

class ProfileView extends StatelessWidget {
  final TabController tabController;
  const ProfileView({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return RefreshIndicator(
      onRefresh: () async => await cubit.getMyPosts(isRefresh: true),
      child: CustomScrollView(
        controller: cubit.myPostScrollController,
        slivers: [
          const ProfileAppBarWidget(),
          const ProfileInfoAppBarWidget(),
          FeedBuilder(
            // scrollController: cubit.myPostScrollController,
            stream: cubit.myPostStream,
            // onRefresh: () async => await cubit.getMyPosts(isRefresh: true),
          ),
        ],
      ),
    );

    return RefreshIndicator(
     onRefresh: () async => await cubit.getMyPosts(isRefresh: true),
      child: NestedScrollView(
        controller: cubit.myPostScrollController,
        headerSliverBuilder: (_, __) => <Widget>[
          const ProfileAppBarWidget(),
          const ProfileInfoAppBarWidget(),
        ],
        body: FeedBuilder(
          // scrollController: cubit.myPostScrollController,
          stream: cubit.myPostStream,
          // onRefresh: () async => await cubit.getMyPosts(isRefresh: true),
        ),
      ),
    );
  }
}
