import 'package:flutter/material.dart';

import '../../../../utilities/constants/app_paddings.dart';
import '../../../../utilities/constants/app_sized_boxes.dart';
import 'widgets/photo_story_like_widget.dart';
import 'widgets/post_time_text_widget.dart';
import 'widgets/talks_share_more_widget.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    this.profileImage,
    required this.storyText,
    required this.time,
    required this.talksCount,
    required this.onTapTalks,
    required this.onTapShare,
    required this.onTapMore,
    required this.likeCount,
    required this.onTapLike,
    required this.onTapUnLike,
    required this.onTapProfileImage, 
    required this.postId,
    required this.posterId
  });

  final String? profileImage;
  final String storyText;
  final String time;
  final int talksCount;
  final int likeCount;
  final Function() onTapTalks;
  final Function() onTapShare;
  final Function() onTapMore;
  final Function() onTapLike;
  final Function() onTapUnLike;
  final Function() onTapProfileImage;
  final String postId;
  final String posterId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.h16 + AppPaddings.v32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhotoStoryLikeWidget(
            image: profileImage,
            story: storyText,
            likeCount: likeCount,
            onTapLike: onTapLike,
            onTapUnLike: onTapUnLike,
            onTapProfileImage: onTapProfileImage,
            postId: postId,
            posterId: posterId,
          ),
          AppSizedBoxes.h20,
          Padding(
            padding: AppPaddings.l72,
            child: PostTimeTextWidget(time: time),
          ),
          AppSizedBoxes.h20,
          Padding(
            padding: AppPaddings.l72,
            child: TalksShareMoreWidget(
              talksCount: talksCount,
              onTapTalks: onTapTalks,
              onTapShare: onTapShare,
              onTapMore: onTapMore,
            ),
          ),
        ],
      ),
    );
  }
}
