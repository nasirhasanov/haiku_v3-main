import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_texts.dart';

import '../../../../utilities/constants/app_colors.dart';
import '../../../../utilities/constants/app_sized_boxes.dart';
import '../../../../utilities/constants/app_text_styles.dart';
import '../../../widgets/global/global_divider.dart';

class MyStoriesWithDividerWidget extends StatelessWidget {
  final String title; // Pass the text as a parameter

  const MyStoriesWithDividerWidget({
    super.key,
    required this.title, // Make the title required
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            title, // Use the passed title here
            style: AppTextStyles.normalGrey14.copyWith(color: AppColors.black),
            textAlign: TextAlign.center, // Ensure text is centered
          ),
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