import 'package:flutter/widgets.dart';
import 'package:haiku/data/models/notification_model.dart';
import 'package:haiku/data/services/user/profile_pic_service.dart';
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
      padding: AppPaddings.h16 + AppPaddings.v32,
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
          Expanded(
            child: PostStoryTextWidget(
              text: getNotificationText(fromName(notification?.type)),
            ),
          ),
          AppSizedBoxes.w16,
        ],
      ),
    );
  }

  String getNotificationText(NotificationType? type) {
    switch (type) {
      case NotificationType.postClapped:
        return '${notification?.fromUserName}${notification?.notificationText}';
      default:
        return '';
    }
  }
}
