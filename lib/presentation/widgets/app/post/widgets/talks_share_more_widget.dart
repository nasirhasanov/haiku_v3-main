import 'package:flutter/material.dart';

import '../../../../../utilities/constants/app_assets.dart';
import '../../../../../utilities/constants/app_colors.dart';
import '../../../../../utilities/constants/app_sized_boxes.dart';
import '../../../../../utilities/constants/app_texts.dart';
import 'post_icon_widget.dart';
import 'post_talks_or_share_widget.dart';

class TalksShareMoreWidget extends StatelessWidget {
  final Function() onTapTalks;
  final Function() onTapShare;
  final Function() onTapMore;
  final int talksCount;

  const TalksShareMoreWidget({
    super.key,
    required this.onTapTalks,
    required this.onTapShare,
    required this.onTapMore,
    required this.talksCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PostTalksOrShareWidget(
          icon: AppAssets.talks,
          text: '${AppTexts.talks}($talksCount)',
          color: AppColors.lightBlue,
          onTap: onTapTalks,
        ),
        AppSizedBoxes.w32,
        PostTalksOrShareWidget(
          icon: AppAssets.share,
          text: AppTexts.share,
          color: AppColors.gold,
          onTap: onTapShare,
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTapMore,
          child: const PostIconWidget(
            icon: AppAssets.more,
            color: AppColors.grey300,
          ),
        ),
      ],
    );
  }
}
