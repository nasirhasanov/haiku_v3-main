import 'package:flutter/material.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/follow_service.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/presentation/widgets/follow_button_widget.dart';
import 'package:haiku/presentation/widgets/global/global_divider.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
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

class FollowedUsersListView extends StatefulWidget {
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
  State<FollowedUsersListView> createState() => _FollowedUsersListViewState();
}

class _FollowedUsersListViewState extends State<FollowedUsersListView> {
  // Remove the refresh behavior when follow state changes
  void _handleFollowStateChanged(UserInfoModel user, bool isFollowing) {
    // No longer triggering refresh when unfollowed
    // This keeps the user in the list even after unfollowing
  }

  @override
  Widget build(BuildContext context) {
    if (widget.users == null || widget.users!.isEmpty) {
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
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView.separated(
        controller: widget.scrollController,
        itemCount: widget.users!.length + 1, // +1 for the loading indicator
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const GlobalDivider.horizontal(left: 70),
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom
          if (index == widget.users!.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: widget.users!.isEmpty 
                  ? const SizedBox() // Empty list, don't show loader
                  : const SizedBox(
                      height: 30, 
                      width: 30, 
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    ),
              ),
            );
          }
          
          final user = widget.users![index];
          return _UserListItem(
            userInfo: user,
            onFollowStateChanged: (isFollowing) => _handleFollowStateChanged(user, isFollowing),
          );
        },
      ),
    );
  }
}

class _UserListItem extends StatefulWidget {
  const _UserListItem({
    required this.userInfo,
    required this.onFollowStateChanged,
  });

  final UserInfoModel userInfo;
  final Function(bool) onFollowStateChanged;

  @override
  State<_UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<_UserListItem> {
  final FollowService _followService = locator<FollowService>();
  bool _isFollowing = true; // Default to true for followed users list
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Refresh follow state just to be sure it's accurate
    if (widget.userInfo.userId != null) {
      _followService.isFollowing(widget.userInfo.userId!).first.then((value) {
        if (mounted) {
          setState(() {
            _isFollowing = value;
          });
        }
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (_isLoading || widget.userInfo.userId == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFollowing) {
        await _followService.unfollowUser(widget.userInfo.userId!);
      } else {
        await _followService.followUser(widget.userInfo.userId!);
      }

      setState(() {
        _isFollowing = !_isFollowing;
      });
      
      // Notify parent about follow state change
      widget.onFollowStateChanged(_isFollowing);
    } catch (e) {
      print('Error toggling follow: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.h6,
      child: GestureDetector(
        onTap: () async {
          var userId = widget.userInfo.userId;
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
                  imageUrl: widget.userInfo.profilePicPath,
                ),
                AppSizedBoxes.w16,
                Expanded(
                  child: Padding(
                    padding: AppPaddings.t8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.userInfo.userName ?? 'User',
                                style: AppTextStyles.normalBlack20,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Don't show button for current user
                            if (widget.userInfo.userId != AuthUtils().currentUserId)
                              _buildFollowButton(),
                          ],
                        ),
                        if (widget.userInfo.bio != null && widget.userInfo.bio!.isNotEmpty) ...[
                          AppSizedBoxes.h4,
                          Text(
                            widget.userInfo.bio!,
                            style: AppTextStyles.normalGrey14,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        AppSizedBoxes.h4,
                        Row(
                          children: [
                            Text(
                              '${widget.userInfo.score ?? 0}',
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
                              '${widget.userInfo.followers?.length ?? 0} followers',
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

  Widget _buildFollowButton() {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _toggleFollow,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFollowing ? AppColors.grey : AppColors.purple,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                _isFollowing ? AppTexts.unfollow : AppTexts.follow,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
} 