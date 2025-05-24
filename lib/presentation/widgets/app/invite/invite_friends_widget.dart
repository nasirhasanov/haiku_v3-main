import 'package:flutter/material.dart';

import '../../../../utilities/constants/app_colors.dart';
import '../../../../utilities/constants/app_paddings.dart';
import '../../../../utilities/constants/app_sized_boxes.dart';
import '../../../../utilities/constants/app_text_styles.dart';
import '../../../../utilities/constants/app_texts.dart';
import '../../../../utilities/helpers/app_share_manager.dart';

class InviteFriendsWidget extends StatelessWidget {
  const InviteFriendsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.a16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.inviteFriends,
            style: AppTextStyles.normalGrey20.copyWith(
              color: AppColors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSizedBoxes.h8,
          const Text(
            AppTexts.inviteDescription,
            style: AppTextStyles.normalGrey14,
          ),
          AppSizedBoxes.h16,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                AppShareManager().onInviteFriends(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                padding: AppPaddings.v12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppTexts.shareWithFriends,
                style: AppTextStyles.normalGrey14.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 