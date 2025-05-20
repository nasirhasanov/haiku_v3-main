import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/author/author_profile_cubit.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/follow_service.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/presentation/widgets/app/post/widgets/post_icon_widget.dart';
import 'package:haiku/presentation/widgets/global/profile_photo_widget.dart';
import 'package:haiku/utilities/constants/app_assets.dart';
import 'package:haiku/utilities/constants/app_colors.dart';
import 'package:haiku/utilities/constants/app_paddings.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/app_text_styles.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';

class AuthorInfoWidget extends StatelessWidget {
  const AuthorInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthorProfileCubit>();
    final currentUserId = AuthUtils().currentUserId;

    return StreamBuilder<UserInfoModel?>(
      initialData: null,
      stream: cubit.authorInfoStream,
      builder: (context, snapshot) {
        final profilePicUrl = snapshot.data?.profilePicPath;
        final username = snapshot.data?.userName;
        final bio = snapshot.data?.bio;
        final score = snapshot.data?.score;

        return Container(
          color: Colors.transparent,
          child: Padding(
            padding: AppPaddings.t24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (profilePicUrl != null) {
                      Go.to(context, Pager.showProfilePic(profilePicUrl: profilePicUrl));
                    }
                  },
                  child: ProfilePhotoWidget(
                    imageRadius: 36,
                    imageUrl: profilePicUrl,
                  ),
                ),
                Text('@$username', style: AppTextStyles.normalBlack24),
                AppSizedBoxes.h4,
                Text('$bio', style: AppTextStyles.normalGrey20),
                AppSizedBoxes.h4,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('$score', style: AppTextStyles.normalGrey20),
                    AppSizedBoxes.w8,
                    const PostIconWidget(
                      icon: AppAssets.clapFilled,
                      color: AppColors.gold,
                    ),
                  ],
                ),
                if (currentUserId != null && currentUserId != cubit.authorId)
                  StreamBuilder<bool>(
                    stream: locator<FollowService>().isFollowing(cubit.authorId),
                    builder: (context, snapshot) {
                      final isFollowing = snapshot.data ?? false;
                      return ElevatedButton(
                        onPressed: () {
                          if (isFollowing) {
                            locator<FollowService>().unfollowUser(cubit.authorId);
                          } else {
                            locator<FollowService>().followUser(cubit.authorId);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFollowing ? AppColors.grey : AppColors.purple,
                          foregroundColor: AppColors.white,
                          padding: AppPaddings.h24 + AppPaddings.v8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          isFollowing ? AppTexts.unfollow : AppTexts.follow,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
