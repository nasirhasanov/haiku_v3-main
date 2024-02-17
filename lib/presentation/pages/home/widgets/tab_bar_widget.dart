import 'package:flutter/material.dart';

import '../../../../utilities/constants/app_colors.dart';
import '../../../../utilities/constants/app_paddings.dart';
import '../../../../utilities/constants/app_sizes.dart';
import '../../../../utilities/constants/app_text_styles.dart';
import '../../../../utilities/constants/app_texts.dart';

class TabBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final TabController _tabController;

  const TabBarWidget({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: SizedBox.fromSize(
        size: AppSizes.tabWidthAndHeight,
        child: TabBar(
          controller: _tabController,
          labelColor: AppColors.purple,
          indicatorColor: AppColors.purple,
          labelStyle: AppTextStyles.normalGrey20,
          indicatorWeight: 3.6,
          padding: AppPaddings.zero,
          labelPadding: AppPaddings.zero,
          indicatorPadding: AppPaddings.h2,
          unselectedLabelColor: AppColors.grey,
          tabs: const [
            Tab(text: AppTexts.neww),
            Tab(text: AppTexts.mix),
            Tab(text: AppTexts.top),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppSizes.tabWidthAndHeight;
}
