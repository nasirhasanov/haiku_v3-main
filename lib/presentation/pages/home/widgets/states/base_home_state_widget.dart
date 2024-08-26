import 'package:flutter/material.dart';
import 'package:haiku/presentation/pages/home/views/create_account_prompt_view.dart';
import 'package:haiku/presentation/pages/home/views/notifications_view.dart';
import 'package:haiku/presentation/pages/home/views/profile_view.dart';
import 'package:haiku/utilities/enums/nav_bar_icon_enum.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';

import '../../views/feed_view.dart';

abstract class BaseHomeStateWidget<HomePage extends StatefulWidget>
    extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController tabController;
  final int tabLength = 3;
  final ValueNotifier<Map<NavBarIconEnum, Widget>> pages = ValueNotifier({});

  @override
  void initState() {
    tabController = TabController(length: tabLength, vsync: this);

    pages.value = {
      NavBarIconEnum.home: FeedView(tabController: tabController),
    };

    // Listen to auth state changes and update the pages map
    AuthUtils().userStream.listen((user) {
      pages.value = {
        NavBarIconEnum.home: FeedView(tabController: tabController),
        NavBarIconEnum.notifications: user != null
            ? NotificationsPage(tabController: tabController)
            : CreateAccountPromptView(tabController: tabController),
        NavBarIconEnum.profile: user != null
            ? ProfileView(tabController: tabController)
            : CreateAccountPromptView(tabController: tabController),
      };
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
