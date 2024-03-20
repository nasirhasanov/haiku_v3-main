import 'package:flutter/material.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/post_icon_widget.dart';
import 'package:haiku/presentation/widgets/global/profile_photo_widget.dart';
import 'package:haiku/utilities/constants/app_assets.dart';
import 'package:haiku/utilities/constants/app_colors.dart';
import 'package:haiku/utilities/constants/app_paddings.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/app_text_styles.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';

class BestUserListItem extends StatelessWidget {
  const BestUserListItem({
    super.key,
    required this.userInfo,
  });

  final UserInfoModel? userInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.h6,
      child: GestureDetector(
        onTap: () async {
          var userId = userInfo?.userId;
          if (userId != null) {
            Go.to(
              context,
              Pager.showAuthor(
                authorId: userId,
              ),
            );
          }
        },
        child: Card(
          elevation: 8,
          surfaceTintColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: AppPaddings.h24 + AppPaddings.v8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePhotoWidget(
                  imageRadius: 56,
                  imageUrl: userInfo?.profilePicPath,
                ),
                AppSizedBoxes.w24,
                Expanded(
                  child: Padding(
                    padding: AppPaddings.t8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userInfo?.userName}',
                          style: AppTextStyles.normalBlack24,
                        ),
                        AppSizedBoxes.h4,
                        Text(
                          '${userInfo?.bio}',
                          style: AppTextStyles.normalGrey20,
                          softWrap: true,
                        ),
                        AppSizedBoxes.h4,
                        Row(
                          children: [
                            Text(
                              '${userInfo?.score}',
                              style: AppTextStyles.normalBlack20.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppSizedBoxes.w8,
                            const PostIconWidget(
                              icon: AppAssets.clapFilled,
                              color: AppColors.gold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
