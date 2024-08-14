import 'package:flutter/material.dart';
import 'package:haiku/data/models/notification_model.dart';
import 'package:haiku/presentation/widgets/app/notifications/notification_widget.dart';
import 'package:haiku/presentation/widgets/global/global_divider.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/extensions/list_extensions.dart';
import 'package:haiku/utilities/helpers/toast.dart';
import 'package:nil/nil.dart';

class NotificationsListView extends StatefulWidget {
  const NotificationsListView({
    super.key,
    required this.notifications,
    this.scrollController,
    this.onRefresh,
  });

  final List<NotificationModel> notifications;
  final ScrollController? scrollController;
  final Future<void> Function()? onRefresh;

  @override
  State<NotificationsListView> createState() => _NotificationsListViewState();
}

class _NotificationsListViewState extends State<NotificationsListView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh ?? () async {},
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.notifications.paginatedLength,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) =>
              const GlobalDivider.horizontal(left: 70),
          itemBuilder: (context, index) {
            final isSuccess = index < widget.notifications.length;
            final isLoading = index == widget.notifications.length;
            if (isSuccess) {
              final notification = widget.notifications[index];
              return NotificationWidget(
                notificationId: notification.notificationId,
                timestamp: notification.timeStamp,
                notificationText: notification.notificationText,
                notificationPicPath: notification.fromProfilePicPath,
                fromId: notification.fromId,
                notificationType: notification.type,
                onTapNotification: () =>
                    Toast.show('Notification Clicked', context),
              );
            } else if (isLoading) {
              return const GlobalLoading();
            }
            return nil;
          },
        ),
      ),
    );
  }
}
