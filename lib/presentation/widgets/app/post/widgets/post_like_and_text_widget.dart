import 'package:flutter/material.dart';
import 'package:haiku/data/data_sources/remote/firebase/clap/clap_service.dart';

import '../../../../../utilities/constants/app_assets.dart';
import '../../../../../utilities/constants/app_colors.dart';
import '../../../../../utilities/constants/app_paddings.dart';
import '../../../../../utilities/constants/app_sized_boxes.dart';
import '../../../../../utilities/constants/app_text_styles.dart';
import 'post_icon_widget.dart';

class PostLikeAndTextWidget extends StatelessWidget {
  const PostLikeAndTextWidget({
    super.key,
    required this.likeCount,
    required this.onTapLike,
    required this.onTapUnlike,
    required this.postId,
  });

  final int likeCount;
  final Function() onTapLike;
  final Function() onTapUnlike;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.t8,
      child: Column(
        children: [
          StreamBuilder(
              stream: ClapService.checkIfClapped(postId),
              builder: (context, snapshot) {
                final isLiked = snapshot.data?.exists ?? false;
                return GestureDetector(
                  onTap: isLiked ? onTapUnlike : onTapLike,
                  child: PostIconWidget(
                    icon: isLiked ? AppAssets.clapFilled : AppAssets.clap,
                    color: AppColors.grey,
                  ),
                );
              }),
          AppSizedBoxes.h10,
          StreamBuilder(
              stream: ClapService.getClapCount(postId),
              builder: (context, snapshot) {
                int clapCount = likeCount;
                if (snapshot.data?.data() != null) {
                  clapCount = (snapshot.data?.data()
                      as Map<String, dynamic>)['clapCount'];
                }

                return Text(
                  '$clapCount',
                  style: AppTextStyles.normalGrey14.copyWith(fontSize: 16),
                );
              }),
        ],
      ),
    );
  }
}
