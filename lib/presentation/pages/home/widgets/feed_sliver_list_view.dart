import 'package:flutter/material.dart';
import 'package:haiku/data/data_sources/remote/firebase/clap/clap_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/notifications/notifications_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/post/delete_post_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/user_info_service.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/presentation/widgets/app/post/post_widget.dart';
import 'package:haiku/presentation/widgets/global/global_divider.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/enums/notification_type_enum.dart';
import 'package:haiku/utilities/extensions/list_extensions.dart';
import 'package:haiku/utilities/extensions/timestamp_extensions.dart';
import 'package:haiku/utilities/helpers/alerts.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/bottom_options_provider.dart';
import 'package:haiku/utilities/helpers/bottom_sheet_dialogs.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';
import 'package:haiku/utilities/helpers/toast.dart';
import 'package:hive/hive.dart';
import 'package:nil/nil.dart';

class FeedSliverListView extends StatefulWidget {
  const FeedSliverListView({
    super.key,
    required this.posts,
    this.scrollController,
    this.onRefresh,
  });

  final List<PostModel> posts;
  final ScrollController? scrollController;
  final Future<void> Function()? onRefresh;

  @override
  State<FeedSliverListView> createState() => _FeedSliverListViewState();
}

class _FeedSliverListViewState extends State<FeedSliverListView> {
  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: widget.posts.paginatedLength,
      separatorBuilder: (context, index) =>
          const GlobalDivider.horizontal(left: 70),
      itemBuilder: (context, index) {
        final isSuccess = index < widget.posts.length;
        final isLoading = index == widget.posts.length;
        if (isSuccess) {
          final post = widget.posts[index];
          return PostWidget(
            profileImage: post.profilePicPath,
            storyText: post.postText,
            time: post.timeStamp.customTimeAgo,
            talksCount: post.talkCount ?? 0,
            likeCount: post.clapCount,
            postId: post.postId,
            posterId: post.userId,
            onTapTalks: () {
              AuthUtils().handleAuthenticatedAction(context, () {
                Go.to(
                    context,
                    Pager.talks(
                      postId: post.postId,
                      posterId: post.userId,
                    ));
              });
            },
            onTapShare: () {
              AuthUtils().handleAuthenticatedAction(context, () {
                print('Authenticated');
              });
            },
            onTapMore: () {
              AuthUtils().handleAuthenticatedAction(context, () {
                final optionsProvider = BottomOptionsProvider.instance;
                final options = (post.userId == AuthUtils().currentUserId)
                    ? optionsProvider.getOptionsForMyPosts()
                    : optionsProvider.getOptionsForOtherPosts();
    
                BottomDialog.showOptionsDialog(
                  context: context,
                  options: options,
                  onOptionSelected: (selectedOption) async {
                    if (selectedOption.key == AppKeys.deleteStory) {
                      bool result = await DeleteStoryService()
                          .deleteStory(post.postId);
                      String toastMessage = result
                          ? AppTexts.storyDeleted
                          : AppTexts.anErrorOccurred;
    
                      if (mounted) Toast.show(toastMessage, context);
    
                      if (result) {
                        setState(() {
                          widget.posts.remove(post);
                        });
                      }
                    }
                  },
                );
              });
            },
            onTapLike: () {
              AuthUtils().handleAuthenticatedAction(context, () async {
                ClapService.addClap(
                  post.postId,
                  UserInfoService.getInfo(AppKeys.username) ?? '',
                  post.userId,
                );
                 
                NotificationsService.addNotification(
                  fromId: AuthUtils().currentUserId, 
                  toId: post.userId,
                  notificationText: AppTexts.likedYourHaiku,
                  fromUsername: Hive.box(AppKeys.userDataBox).get(AppKeys.username),
                  type: NotificationType.postClapped.name,
                  clapperId: AuthUtils().currentUserId,
                  clappedPostId: post.postId,
                  clappedPostText: post.postText
                );
              });
            },
            onTapProfileImage: () {
              AuthUtils().handleAuthenticatedAction(context, () {
                Alerts.showProfilePhoto(context, post.userId);
              });
            },
            onTapUnLike: () {
              AuthUtils().handleAuthenticatedAction(context, () {
                ClapService.removeClap(
                  post.postId,
                  post.userId,
                );
              });
            },
          );
        } else if (isLoading) {
          return const GlobalLoading();
        }
        return nil;
      },
    );
  }
}