import 'package:flutter/material.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/user_info_service.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_radiuses.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';

import '../../presentation/widgets/app/post/widgets/post_icon_widget.dart';
import '../../presentation/widgets/global/profile_photo_widget.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_decorations.dart';
import '../constants/app_paddings.dart';
import '../constants/app_sized_boxes.dart';
import '../constants/app_text_styles.dart';

class Alerts {
  Alerts._();

  static void showProfilePhoto(BuildContext context, String userId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return FutureBuilder<UserInfoModel?>(
          future: UserInfoService().getProfileInfo(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Optionally handle the loading state
              return const GlobalLoading();
            }

            if (snapshot.hasError || snapshot.data == null) {
              // Optionally handle the error or null data state
              return const Text('Failed to load user info');
            }

            UserInfoModel userInfo = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: AppPaddings.a16,
                  margin: AppPaddings.h16,
                  decoration: AppDecorations.whiteA24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfilePhotoWidget(
                        imageRadius: 100,
                        imageUrl: userInfo.profilePicPath,
                      ),
                      AppSizedBoxes.h16,
                      Text(
                        userInfo.userName ?? '',
                        style: AppTextStyles.normalBlack24,
                      ),
                      AppSizedBoxes.h10,
                      Text(
                        userInfo.bio ?? '',
                        style: AppTextStyles.normalGrey20,
                      ),
                      AppSizedBoxes.h10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userInfo.score.toString(),
                            style: AppTextStyles.normalBlack24,
                          ),
                          AppSizedBoxes.w8,
                          const PostIconWidget(
                              icon: AppAssets.clapFilled,
                              color: AppColors.gold),
                        ],
                      ),
                      AppSizedBoxes.h16,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.purple,
                            padding: AppPaddings.a16 + AppPaddings.h16,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadiuses.a24,
                            )),
                        onPressed: () {
                          Go.replace(
                              context, Pager.showAuthor(authorId: userId));
                        },
                        child: const Text(AppTexts.showAuthor),
                      ),
                    ],
                  ),
                ),
                AppSizedBoxes.h48,
                Material(
                  color: AppColors.transparent,
                  child: IconButton(
                    onPressed: () => Go.back(context),
                    iconSize: 60,
                    splashRadius: 0.1,
                    color: AppColors.white,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
