import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:haiku/data/services/user/profile_pic_service.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/post_story_text_widget.dart';
import 'package:haiku/presentation/widgets/global/profile_photo_widget.dart';
import 'package:haiku/utilities/constants/app_paddings.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.notificationId,
    required this.timestamp,
    this.notificationText,
    this.notificationPicPath,
    this.fromId,
    this.notificationType,
    required this.onTapNotification,
  });

  final String? notificationId;
  final Timestamp timestamp;
  final String? fromId;
  final String? notificationText;
  final String? notificationPicPath;
  final String? notificationType;

  final Function() onTapNotification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.h16 + AppPaddings.v32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: ProfilePicService.getProfilePicURLStream(fromId),
              builder: (context, snapshot) {
                String? image;
                if (snapshot.data?.data() != null) {
                  image = (snapshot.data?.data()
                      as Map<String, dynamic>)[FirebaseKeys.profilePicPath];
                }
                return ProfilePhotoWidget(imageUrl: image);
              }),
          AppSizedBoxes.w16,
          PostStoryTextWidget(text: notificationText ?? " "),
          AppSizedBoxes.w16,
        ],
      ),
    );
  }
}
