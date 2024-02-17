import 'package:flutter/material.dart';

import '../../../../../utilities/constants/app_text_styles.dart';

class PostStoryTextWidget extends StatelessWidget {
  final String text;
  const PostStoryTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: AppTextStyles.normalBlack24.copyWith(fontSize: 18),
      ),
    );
  }
}
