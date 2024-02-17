import 'package:flutter/material.dart';

import '../../../../../utilities/constants/app_text_styles.dart';

class PostTimeTextWidget extends StatelessWidget {
  final String time;
  const PostTimeTextWidget({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: AppTextStyles.normalGrey14,
    );
  }
}
