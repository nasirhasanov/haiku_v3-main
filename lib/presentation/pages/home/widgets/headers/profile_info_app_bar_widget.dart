import 'package:flutter/material.dart';

import '../../../../../utilities/constants/app_colors.dart';
import '../../../../../utilities/constants/app_paddings.dart';
import '../my_stories_with_divider_widget.dart';
import '../profile_info_widget.dart';

class ProfileInfoAppBarWidget extends StatelessWidget {
  const ProfileInfoAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: AppPaddings.zero,
        title: MyStoriesWithDividerWidget(),
        expandedTitleScale: 1.1,
        background: ProfileInfoWidget(),
      ),
    );
  }
}
