import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../utilities/constants/app_paddings.dart';
import '../../../../utilities/constants/app_sized_boxes.dart';
import 'widgets/photo_story_like_widget.dart';
import 'widgets/post_time_text_widget.dart';
import 'widgets/talks_share_more_widget.dart';

class PostWidget extends StatelessWidget {
  PostWidget(
      {super.key,
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
      required this.posterId});

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
    return Screenshot(
        controller: screenshotController,
        child: Padding(
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
                  onTapShare: _takeScreenshotAndShare,
                  onTapMore: onTapMore,
                ),
              ),
            ],
          ),
        ));
  }

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _takeScreenshotAndShare() async {
    // Capture screenshot
    final image = await screenshotController.capture();
    if (image != null) {
      // Save the image to a temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/screenshot.png';
      final file = File(imagePath);
      await file.writeAsBytes(image);

      // Share screenshot
      await Share.shareFiles(
        [imagePath],
        text: AppTexts.shareAppDescription,
      );
    }
  }
}
