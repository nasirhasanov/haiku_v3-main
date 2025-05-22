import 'package:flutter/material.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/presentation/widgets/global/global_divider.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_assets.dart';
import 'package:haiku/utilities/constants/app_colors.dart';
import 'package:haiku/utilities/constants/app_paddings.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/app_text_styles.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';
import 'package:haiku/presentation/widgets/global/profile_photo_widget.dart';

class FollowedUsersListView extends StatelessWidget {
  const FollowedUsersListView({
    super.key,
    required this.users,
    this.onRefresh,
    this.scrollController,
  });

  final List<UserInfoModel>? users;
  final Future<void> Function()? onRefresh;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    if (users == null || users!.isEmpty) {
      return Center(
        child: Padding(
          padding: AppPaddings.h24,
          child: Text(
            'You are not following anyone yet.',
            style: AppTextStyles.normalGrey14,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: onRefresh ?? () async {},
      child: ListView.separated(
        controller: scrollController,
        itemCount: users!.length + 1, // +1 for the loading indicator
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const GlobalDivider.horizontal(left: 70),
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom
          if (index == users!.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: users!.isEmpty 
                  ? const SizedBox() // Empty list, don't show loader
                  : const SizedBox(
                      height: 30, 
                      width: 30, 
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    ),
              ),
            );
          }
          
          final user = users![index];
          return _UserListItem(userInfo: user);
        },
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  const _UserListItem({
    required this.userInfo,
  });

  final UserInfoModel userInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.h6,
      child: GestureDetector(
        onTap: () async {
          var userId = userInfo.userId;
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
          elevation: 4,
          surfaceTintColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: AppPaddings.h16 + AppPaddings.v12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePhotoWidget(
                  imageRadius: 45,
                  imageUrl: userInfo.profilePicPath,
                ),
                AppSizedBoxes.w16,
                Expanded(
                  child: Padding(
                    padding: AppPaddings.t8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userInfo.userName ?? 'User',
                          style: AppTextStyles.normalBlack20,
                        ),
                        if (userInfo.bio != null && userInfo.bio!.isNotEmpty) ...[
                          AppSizedBoxes.h4,
                          Text(
                            userInfo.bio!,
                            style: AppTextStyles.normalGrey14,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        AppSizedBoxes.h4,
                        Row(
                          children: [
                            Text(
                              '${userInfo.score ?? 0}',
                              style: AppTextStyles.normalBlack20.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppSizedBoxes.w4,
                            Image.asset(
                              AppAssets.clapFilled,
                              width: 16,
                              height: 16,
                              color: AppColors.gold,
                            ),
                            const Spacer(),
                            Text(
                              '${userInfo.followers?.length ?? 0} followers',
                              style: AppTextStyles.normalGrey14,
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