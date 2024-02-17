import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_texts.dart';

import '../../../../utilities/constants/app_colors.dart';
import '../../../../utilities/constants/app_sized_boxes.dart';
import '../../../../utilities/constants/app_text_styles.dart';
import '../../../widgets/global/global_divider.dart';

class MyStoriesWithDividerWidget extends StatelessWidget {
  const MyStoriesWithDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppTexts.myStories,
          style: AppTextStyles.normalGrey14.copyWith(color: AppColors.black),
        ),
        AppSizedBoxes.h10,
        const GlobalDivider.horizontal(
          height: 1.6,
          width: 96,
          top: 0,
          bottom: 0,
          color: AppColors.black,
        ),
      ],
    );
  }
}
