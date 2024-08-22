import 'package:flutter/material.dart';
import 'package:haiku/data/models/notification_model.dart';
import 'package:haiku/presentation/widgets/app/notifications/notification_widget.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/enums/notification_type_enum.dart';
import 'package:haiku/utilities/extensions/list_extensions.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';
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
      child: ListView.builder(
        shrinkWrap: false,
        itemCount: widget.notifications.paginatedLength,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final isSuccess = index < widget.notifications.length;
          final isLoading = index == widget.notifications.length;
          if (isSuccess) {
            final notification = widget.notifications[index];
            return NotificationWidget(
              notification: notification,
              onTapNotification: () => onTapNotification(notification),
            );
          } else if (isLoading) {
            return const GlobalLoading();
          }
          return nil;
        },
      ),
    );
  }

  void onTapNotification(NotificationModel? notification) {
    if (notification != null) {
      switch (fromName(notification.type)) {
        case NotificationType.postClapped:
          Go.to(
              context,
              Pager.talks(
                postId: notification.clappedPostId!,
                posterId: notification.toId!,
              ));
          break;
        default:
          break;
      }
    }
  }
}
