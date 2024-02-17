import 'package:flutter/material.dart';
import 'package:haiku/data/services/user/profile_pic_service.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';

import '../../../../../utilities/constants/app_sized_boxes.dart';
import '../../../global/profile_photo_widget.dart';
import 'post_like_and_text_widget.dart';
import 'post_story_text_widget.dart';

class PhotoStoryLikeWidget extends StatelessWidget {
  const PhotoStoryLikeWidget({
    super.key,
    required this.story,
    this.image,
    required this.likeCount,
    required this.onTapLike,
    required this.onTapUnLike,
    required this.onTapProfileImage,
    required this.postId,
    required this.posterId,
  });

  final String story;
  final String? image;
  final int likeCount;
  final Function() onTapLike;
  final Function() onTapUnLike;
  final Function() onTapProfileImage;
  final String postId;
  final String posterId;

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
        PostLikeAndTextWidget(
          likeCount: likeCount,
          onTapLike: onTapLike,
          onTapUnlike: onTapUnLike,
          postId: postId,
        ),
      ],
    );
  }
}
