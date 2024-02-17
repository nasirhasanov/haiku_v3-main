import 'package:flutter/material.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/post_icon_widget.dart';

import '../../../../../utilities/constants/app_sized_boxes.dart';
import '../../../../../utilities/constants/app_text_styles.dart';

class PostTalksOrShareWidget extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;
  final Function() onTap;

  const PostTalksOrShareWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          PostIconWidget(icon: icon, color: color),
          AppSizedBoxes.w4,
          Text(
            text,
            style: AppTextStyles.normalLightBlue16.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
