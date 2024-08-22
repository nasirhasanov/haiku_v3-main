import 'package:flutter/material.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/photo_story_like_widget.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/post_time_text_widget.dart';
import 'package:haiku/presentation/widgets/global/global_divider.dart';
import 'package:haiku/utilities/extensions/timestamp_extensions.dart';

import '../../../../utilities/constants/app_paddings.dart';
import '../../../../utilities/constants/app_sized_boxes.dart';

class PostWidgetForTalks extends StatelessWidget {
  const PostWidgetForTalks({
    super.key,
    required this.postModel,
    required this.onTapLike,
    required this.onTapUnLike,
    required this.onTapProfileImage,
  });

  final Function() onTapLike;
  final Function() onTapUnLike;
  final Function() onTapProfileImage;
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.h16 + AppPaddings.v32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhotoStoryLikeWidget(
            image: postModel.profilePicPath,
            story: postModel.postText,
            likeCount: postModel.clapCount,
            onTapLike: onTapLike,
            onTapUnLike: onTapUnLike,
            onTapProfileImage: onTapProfileImage,
            postId: postModel.postId,
            posterId: postModel.userId,
          ),
          AppSizedBoxes.h20,
          Padding(
            padding: AppPaddings.l72,
            child: PostTimeTextWidget(time: postModel.timeStamp.customTimeAgo),
          ),
          AppSizedBoxes.h20,
          const GlobalDivider.horizontal(height: 1)
        ],
      ),
    );
  }
}
