import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';

import '../../../cubits/home/home_cubit.dart';
import '../../../utilities/constants/app_colors.dart';
import '../../../utilities/enums/nav_bar_icon_enum.dart';
import '../../widgets/app/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'widgets/buttons/add_button_widget.dart';
import 'widgets/fade_indexed_stack.dart';
import 'widgets/states/base_home_state_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseHomeStateWidget<HomePage> {

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = context.read<HomeCubit>();
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: ColoredBox(
        color: AppColors.white,
        child: SafeArea(
          child: StreamBuilder<NavBarIconEnum>(
            stream: cubit.activeIconStream,
            builder: (context, AsyncSnapshot<NavBarIconEnum> snapshot) {
              final activeIcon = snapshot.data ?? NavBarIconEnum.home;
              return ValueListenableBuilder<Map<NavBarIconEnum, Widget>>(
                  valueListenable:
                      pages, 
                  builder: (context, pagesValue, child) {
                    return FadeIndexedStack(
                      index: activeIcon.index,
                      children: pagesValue.values.toList(),
                    );
                  });
            },
          ),
        ),
      ),
      floatingActionButton: AddButtonWidget(
        onTapAdd: () {
          AuthUtils().handleAuthenticatedAction(context, () {
            Go.to(context, Pager.addPost);
          });
        },
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
