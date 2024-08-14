import 'package:flutter/widgets.dart';
import 'package:haiku/data/models/notification_model.dart';
import 'package:haiku/presentation/pages/home/widgets/notification_list_view.dart';

class NotificationsBuilder extends StatefulWidget {
  const NotificationsBuilder({
    super.key,
    this.scrollController,
    this.stream,
    this.onRefresh,
  });

  final ScrollController? scrollController;
  final Stream<List<NotificationModel>>? stream;
  final Future<void> Function()? onRefresh;

  @override
  State<NotificationsBuilder> createState() => _NotificationsBuilderState();
}

class _NotificationsBuilderState extends State<NotificationsBuilder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      child: StreamBuilder<List<NotificationModel>>(
          stream: widget.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No notifications available.'),
              );
            } else {
              return NotificationsListView(
                scrollController: widget.scrollController,
                notifications: snapshot.data ?? [],
                onRefresh: widget.onRefresh,
              );
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}