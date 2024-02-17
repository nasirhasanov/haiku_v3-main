import 'package:flutter/material.dart';
import 'package:haiku/data/services/user/profile_pic_service.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/post_story_text_widget.dart';
import 'package:haiku/presentation/widgets/app/talks/talk_like_and_count_widget.dart';
import 'package:haiku/presentation/widgets/global/profile_photo_widget.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';

class TalkPhotoTextLikeWidget extends StatelessWidget {
  const TalkPhotoTextLikeWidget({
    super.key,
    required this.story,
    this.posterId,
    required this.likeCount,
    required this.onTapLike,
    required this.onTapUnLike,
    required this.onTapProfileImage,
    required this.postId,
  });

  final String story;
  final String? posterId;
  final int likeCount;
  final Function() onTapLike;
  final Function() onTapUnLike;
  final Function() onTapProfileImage;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
            stream: ProfilePicService.getProfilePicURLStream(posterId),
            builder: (context, snapshot) {
              String? image;
              if (snapshot.data?.data() != null) {
                image = (snapshot.data?.data()
                    as Map<String, dynamic>)[FirebaseKeys.profilePicPath];
              }

              return GestureDetector(
                onTap: onTapProfileImage,
                child: ProfilePhotoWidget(imageUrl: image),
              );
            }),
        AppSizedBoxes.w16,
        PostStoryTextWidget(text: story),
        AppSizedBoxes.w16,
        TalkLikeAndCountWidget(
          likeCount: likeCount,
          onTapLike: onTapLike,
          onTapUnlike: onTapUnLike,
          postId: postId,
        ),
      ],
    );
  }
}
