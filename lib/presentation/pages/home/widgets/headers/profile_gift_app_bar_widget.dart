import 'package:flutter/material.dart';
import 'package:haiku/presentation/pages/settings/settings_page.dart';
import 'package:haiku/utilities/helpers/go.dart';

import '../../../../../utilities/constants/app_colors.dart';
import '../../../../../utilities/constants/app_paddings.dart';

class ProfileAppBarWidget extends StatelessWidget {
  const ProfileAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: const Icon(
        Icons.wallet_giftcard_rounded,
        color: AppColors.black,
      ),
      actions: [
        Padding(
          padding: AppPaddings.r16,
          child: IconButton(
            icon: const Icon(
              Icons.settings,
              color: AppColors.black,
            ),
            onPressed: () { 
              Go.to(context, const SettingsPage());
             },
          ),
        ),
      ],
    );
  }
}
