import 'package:flutter/material.dart';

import '../../../../../utilities/constants/app_colors.dart';
import '../../../../../utilities/constants/app_paddings.dart';
import '../../../../../utilities/constants/app_text_styles.dart';
import '../../../../../utilities/constants/app_texts.dart';
import '../../../../../utilities/helpers/go.dart';
import '../../../../../utilities/helpers/pager.dart';
import '../tab_bar_widget.dart';

class FeedAppBarWidget extends StatelessWidget {
  final TabController _tabController;
  const FeedAppBarWidget({super.key, required TabController tabController})
      : _tabController = tabController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      shadowColor: AppColors.grey300,
      forceElevated: true,
      title: const Text(
        AppTexts.stories,
        style: TextStyle(
          color: AppColors.black,
        ),
      ),
      centerTitle: false,
      surfaceTintColor: AppColors.white,
      titleTextStyle: AppTextStyles.normalGrey22,
      bottom: TabBarWidget(tabController: _tabController),
      actions: [
        GestureDetector(
          onTap: () => Go.to(context, Pager.searchUsers),
          child: const Padding(
            padding: AppPaddings.r16,
            child: Icon(
              Icons.search,
              color: AppColors.black,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Go.to(context, Pager.showBestAuthors),
          child: const Padding(
            padding: AppPaddings.r16,
            child: Icon(
              Icons.thumbs_up_down,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
