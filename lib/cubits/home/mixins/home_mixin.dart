import 'package:rxdart/rxdart.dart';

import '../../../utilities/enums/nav_bar_icon_enum.dart';

mixin HomeMixin {
  final BehaviorSubject<NavBarIconEnum> activeIcon =
      BehaviorSubject<NavBarIconEnum>.seeded(NavBarIconEnum.home);

  ValueStream<NavBarIconEnum> get activeIconStream => activeIcon.stream;

  void onTapHome() {
    if (activeIcon.value != NavBarIconEnum.home) {
      activeIcon.add(NavBarIconEnum.home);
    }
  }

  void onTapNotifications() {
    if (activeIcon.value != NavBarIconEnum.notifications) {
      activeIcon.add(NavBarIconEnum.notifications);
    }
  }

  void onTapProfile() {
    if (activeIcon.value != NavBarIconEnum.profile) {
      activeIcon.add(NavBarIconEnum.profile);
    }
  }
}
