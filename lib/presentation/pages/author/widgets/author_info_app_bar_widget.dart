import 'package:flutter/material.dart';
import 'package:haiku/presentation/pages/author/widgets/author_info_widget.dart';
import 'package:haiku/presentation/pages/home/widgets/my_stories_with_divider_widget.dart';
import 'package:haiku/utilities/constants/app_colors.dart';
import 'package:haiku/utilities/constants/app_paddings.dart';

class AuthorInfoAppBarWidget extends StatelessWidget {
  const AuthorInfoAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 250.0,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: AppPaddings.zero,
        title: MyStoriesWithDividerWidget(),
        expandedTitleScale: 1.1,
        background: AuthorInfoWidget(),
      ),
    );
  }
}