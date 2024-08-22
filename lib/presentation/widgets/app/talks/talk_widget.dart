import 'package:flutter/material.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/post_icon_widget.dart';
import 'package:haiku/presentation/widgets/app/talks/talk_photo_text_like_widget.dart';
import 'package:haiku/utilities/constants/app_assets.dart';
import 'package:haiku/utilities/constants/app_colors.dart';

import '../../../../utilities/constants/app_paddings.dart';
import '../../../../utilities/constants/app_sized_boxes.dart';

class TalkWidget extends StatelessWidget {
  const TalkWidget({
    super.key,
    this.posterId,
    required this.talkId,
    required this.talkText,
    required this.time,
    required this.onTapMore,
    required this.likeCount,
    required this.onTapLike,
    required this.onTapUnLike,
    required this.onTapProfileImage,
  });

  final String? posterId;
  final String talkText;
  final String time;
  final int likeCount;
  final String talkId;

  final Function() onTapMore;
  final Function() onTapLike;
  final Function() onTapUnLike;
  final Function() onTapProfileImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.h16 + AppPaddings.v12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TalkPhotoTextLikeWidget(
            posterId: posterId,
            story: talkText,
            likeCount: likeCount,
            onTapLike: onTapLike,
            onTapUnLike: onTapUnLike,
            onTapProfileImage: onTapProfileImage,
            postId: talkId,
          ),
          AppSizedBoxes.h20,
          Padding(
            padding: AppPaddings.l72,
            child: Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: onTapMore,
                  child: const PostIconWidget(
                    icon: AppAssets.more,
                    color: AppColors.grey300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
