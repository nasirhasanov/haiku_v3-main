import 'package:flutter/material.dart';
import 'package:haiku/data/services/clap/talk_clap_service.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/post_icon_widget.dart';
import 'package:haiku/utilities/constants/app_assets.dart';
import 'package:haiku/utilities/constants/app_colors.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_paddings.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/app_text_styles.dart';

class TalkLikeAndCountWidget extends StatelessWidget {
  const TalkLikeAndCountWidget({
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
              stream: TalkClapService.checkIfClapped(postId),
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
              stream: TalkClapService.getClapCount(postId),
              builder: (context, snapshot) {
                int clapCount = likeCount;
                if (snapshot.data?.data() != null) {
                  clapCount = (snapshot.data?.data()
                      as Map<String, dynamic>)[AppKeys.clapCount];
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
