import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

import '../../../../../cubits/home/home_cubit.dart';
import '../../../../../utilities/constants/app_assets.dart';
import '../../../../../utilities/constants/app_colors.dart';
import '../../../../../utilities/enums/nav_bar_icon_enum.dart';
import '../../../../widgets/app/post/widgets/post_icon_widget.dart';

class AddButtonWidget extends StatelessWidget {
  final Function() onTapAdd;
  const AddButtonWidget({super.key, required this.onTapAdd});

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = context.read<HomeCubit>();
    return StreamBuilder<NavBarIconEnum>(
        stream: cubit.activeIconStream,
        builder: (context, AsyncSnapshot<NavBarIconEnum> snapshot) {
          NavBarIconEnum activeIcon = snapshot.data ?? NavBarIconEnum.home;
          return activeIcon == NavBarIconEnum.home
              ? FloatingActionButton(
                heroTag: 'Add post',
                  backgroundColor: AppColors.white,
                  onPressed: onTapAdd,
                  child: const PostIconWidget(
                    icon: AppAssets.storyPen,
                    color: AppColors.black,
                  ),
                )
              : nil;
        });
  }
}
