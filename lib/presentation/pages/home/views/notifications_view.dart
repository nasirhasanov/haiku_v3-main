import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/notifications/notification_cubit.dart';
import 'package:haiku/presentation/pages/home/widgets/notifications_builder.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:nil/nil.dart';

class NotificationsPage extends StatefulWidget {
  final TabController tabController;

  const NotificationsPage({super.key, required this.tabController});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final notificationsCubit = context.read<NotificationCubit>();

    return Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.notificationsTitle),
          centerTitle: true,
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
          if (state is NotificationLoading || state is NotificationInitial) {
            return const GlobalLoading();
          } else if (state is NotificationSuccess) {
            return NotificationsBuilder(
              stream: notificationsCubit.newNotificationStream,
              onRefresh: () async =>
                  await notificationsCubit.getNewNotifications(isRefresh: true),
            );
          }
          return nil;
        }));
  }
}
