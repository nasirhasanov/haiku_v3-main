import 'package:flutter/material.dart';
import 'package:haiku/data/services/clap/clap_service.dart';
import 'package:haiku/data/services/notifications/notifications_service.dart';
import 'package:haiku/data/services/post/delete_post_service.dart';
import 'package:haiku/data/services/user/user_info_service.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/enums/notification_type_enum.dart';
import 'package:haiku/utilities/helpers/bottom_options_provider.dart';
import 'package:haiku/utilities/helpers/bottom_sheet_dialogs.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';
import 'package:haiku/utilities/helpers/toast.dart';
import 'package:hive/hive.dart';
import 'package:nil/nil.dart';

import '../../../../data/models/post_model.dart';
import '../../../../utilities/extensions/list_extensions.dart';
import '../../../../utilities/extensions/timestamp_extensions.dart';
import '../../../../utilities/helpers/alerts.dart';
import '../../../../utilities/helpers/auth_utils.dart';
import '../../../widgets/app/post/post_widget.dart';
import '../../../widgets/global/global_divider.dart';
import '../../../widgets/global/global_loading.dart';

class FeedListView extends StatefulWidget {
  const FeedListView({
    super.key,
    required this.posts,
    this.scrollController,
    this.onRefresh,
  });

  final List<PostModel> posts;
  final ScrollController? scrollController;
  final Future<void> Function()? onRefresh;

  @override
  State<FeedListView> createState() => _FeedListViewState();
}

class _FeedListViewState extends State<FeedListView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh ?? () async {},
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.posts.paginatedLength,
          physics: const NeverScrollableScrollPhysics(),
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
                      clappedPostId: post.postId
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
        ),
      ),
    );
  }
}
