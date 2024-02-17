import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/user/profile_cubit.dart';
import 'package:haiku/presentation/pages/home/widgets/feed_builder.dart';

import '../widgets/headers/profile_gift_app_bar_widget.dart';
import '../widgets/headers/profile_info_app_bar_widget.dart';

class ProfileView extends StatelessWidget {
  final TabController tabController;
  const ProfileView({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          const ProfileAppBarWidget(),
          const ProfileInfoAppBarWidget(),
        ];
      },
      body: FeedBuilder(
        scrollController: cubit.myPostScrollController,
        stream: cubit.myPostStream,
        onRefresh: () async => await cubit.getMyPosts(isRefresh: true),
      ),
    );
  }
}
