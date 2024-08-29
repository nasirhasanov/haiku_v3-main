import 'package:flutter/widgets.dart';
import 'package:haiku/data/models/notification_model.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/profile_pic_service.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/post_story_text_widget.dart';
import 'package:haiku/presentation/widgets/global/profile_photo_widget.dart';
import 'package:haiku/utilities/constants/app_paddings.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';
import 'package:haiku/utilities/enums/notification_type_enum.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.notification,
    required this.onTapNotification,
  });

  final NotificationModel? notification;

  final Function() onTapNotification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.h16 + AppPaddings.v20,
      child: GestureDetector(
        onTap: onTapNotification,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: ProfilePicService.getProfilePicURLStream(
                    notification?.fromId),
                builder: (context, snapshot) {
                  String? image;
                  if (snapshot.data?.data() != null) {
                    image = (snapshot.data?.data()
                        as Map<String, dynamic>)[FirebaseKeys.profilePicPath];
                  }
                  return ProfilePhotoWidget(
                    imageRadius: 20,
                    imageUrl: image,
                  );
                }),
            AppSizedBoxes.w16,
            PostStoryTextWidget(
              text: getNotificationText(fromName(notification?.type)),
            ),
            AppSizedBoxes.w16,
          ],
        ),
      ),
    );
  }

  String getNotificationText(NotificationType? type) {
    switch (type) {
      case NotificationType.postClapped:
        final clappedPostText = notification?.clappedPostText ?? '';
        final truncatedText = clappedPostText.length > 20
            ? '${clappedPostText.substring(0, 20)}...👏'
            : clappedPostText;
        return '${notification?.fromUserName}${notification?.notificationText}: "$truncatedText"';

      case NotificationType.talkClapped:
        final clappedTalkText = notification?.clappedPostText ?? '';
        final truncatedText = clappedTalkText.length > 20
            ? '${clappedTalkText.substring(0, 20)}...👏'
            : clappedTalkText;
        return '${notification?.fromUserName}${notification?.notificationText}: "$truncatedText"';

      case NotificationType.newTalk:
        final commentText = notification?.commentText ?? '';
        final truncatedText = commentText.length > 20
            ? '${commentText.substring(0, 20)}...💬'
            : commentText;
        return '${notification?.fromUserName}${notification?.notificationText} "$truncatedText"';
      default:
        return '';
    }
  }
}
