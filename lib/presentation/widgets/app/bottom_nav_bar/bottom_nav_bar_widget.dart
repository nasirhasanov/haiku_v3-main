import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/user_info_service.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';

import '../../../../cubits/home/home_cubit.dart';
import '../../../../utilities/constants/app_assets.dart';
import '../../../../utilities/constants/app_colors.dart';
import '../../../../utilities/constants/app_paddings.dart';
import '../../../../utilities/constants/app_sizes.dart';
import '../../../../utilities/enums/nav_bar_icon_enum.dart';
import 'widgets/nav_bar_icon.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = context.read<HomeCubit>();
    bool hasNotifications = false;

    return Material(
      color: AppColors.white,
      elevation: AppSizes.navBarElevation,
      child: Container(
        height: AppSizes.navBarHeight,
        margin: AppPaddings.b16,
        color: AppColors.transparent,
        child: StreamBuilder<NavBarIconEnum>(
            stream: cubit.activeIconStream,
            builder: (context, AsyncSnapshot<NavBarIconEnum> snapshot) {
              NavBarIconEnum activeIcon = snapshot.data ?? NavBarIconEnum.home;
              return Row(
                children: [
                  const Spacer(),
                  NavBarIcon(
                    onTap: () => cubit.onTapHome(),
                    icon: AppAssets.home,
                    color: activeIcon == NavBarIconEnum.home
                        ? AppColors.purple
                        : AppColors.grey,
                  ),
                  const Spacer(),
                  if (AuthUtils().currentUser != null) ...[
                    Stack(
                      children: [
                        NavBarIcon(
                          onTap: () {
                            cubit.onTapNotifications();
                            if (hasNotifications) {
                              UserInfoService().setHasNotificationsFalse();
                            }
                          },
                          icon: AppAssets.noNotification,
                          color: activeIcon == NavBarIconEnum.notifications
                              ? AppColors.purple
                              : AppColors.grey,
                        ),
                        // Conditional red dot indicator
                        StreamBuilder<DocumentSnapshot>(
                          stream: UserInfoService.hasNotifications(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              hasNotifications = (snapshot.data!.data() as Map<
                                      String, dynamic>)['has_notifications'] ??
                                  false;
                              return Visibility(
                                visible: hasNotifications,
                                child: Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox
                                .shrink(); // Return empty if no data
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                  NavBarIcon(
                    onTap: () => cubit.onTapProfile(),
                    icon: AppAssets.profile,
                    color: activeIcon == NavBarIconEnum.profile
                        ? AppColors.purple
                        : AppColors.grey,
                  ),
                  const Spacer(),
                ],
              );
            }),
      ),
    );
  }
}
