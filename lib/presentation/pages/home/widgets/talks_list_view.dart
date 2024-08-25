import 'package:flutter/material.dart';
import 'package:haiku/data/models/talk_model.dart';
import 'package:haiku/data/data_sources/remote/firebase/clap/talk_clap_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/talks/talks_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/user_info_service.dart';
import 'package:haiku/presentation/widgets/app/talks/talk_widget.dart';
import 'package:haiku/presentation/widgets/global/global_divider.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/extensions/list_extensions.dart';
import 'package:haiku/utilities/extensions/timestamp_extensions.dart';
import 'package:haiku/utilities/helpers/alerts.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/bottom_options_provider.dart';
import 'package:haiku/utilities/helpers/bottom_sheet_dialogs.dart';
import 'package:haiku/utilities/helpers/toast.dart';
import 'package:nil/nil.dart';

class TalksListView extends StatefulWidget {
  const TalksListView({
    super.key,
    required this.talks,
    this.scrollController,
    this.onRefresh,
  });

  final List<TalkModel> talks;
  final ScrollController? scrollController;
  final Future<void> Function()? onRefresh;

  @override
  State<TalksListView> createState() => _TalksListViewState();
}

class _TalksListViewState extends State<TalksListView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh ?? () async {},
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.talks.paginatedLength,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) =>
              const GlobalDivider.horizontal(left: 70),
          itemBuilder: (context, index) {
            final isSuccess = index < widget.talks.length;
            final isLoading = index == widget.talks.length;
            if (isSuccess) {
              final talk = widget.talks[index];
              return TalkWidget(
                posterId: talk.userId,
                talkText: talk.commentText,
                time: talk.timeStamp.customTimeAgo,
                likeCount: talk.clapCount,
                talkId: talk.talkId,
                onTapMore: () {
                  AuthUtils().handleAuthenticatedAction(context, () {
                    final optionsProvider = BottomOptionsProvider.instance;
                    final options = (talk.userId == AuthUtils().currentUserId)
                        ? optionsProvider.getOptionsForMyTalk()
                        : optionsProvider.getOptionsForOtherTalks();

                    BottomDialog.showOptionsDialog(
                      context: context,
                      options: options,
                      onOptionSelected: (selectedOption) async {
                        if (selectedOption.key == AppKeys.deleteTalk) {
                          bool result = await TalksService().removeTalk(
                            talkId: talk.talkId,
                            postId: talk.postId,
                          );
                          String toastMessage = result
                              ? AppTexts.talkDeleted
                              : AppTexts.anErrorOccurred;

                          if (mounted) Toast.show(toastMessage, context);

                          if (result) {
                            setState(() {
                              widget.talks.remove(talk);
                            });
                          }
                        }
                      },
                    );
                  });
                },
                onTapLike: () {
                  AuthUtils().handleAuthenticatedAction(context, () {
                    TalkClapService.addClap(
                      talk.talkId,
                      UserInfoService.getInfo(AppKeys.username) ?? '',
                      talk.userId,
                    );
                  });
                },
                onTapProfileImage: () =>
                    Alerts.showProfilePhoto(context, talk.userId),
                onTapUnLike: () {
                  AuthUtils().handleAuthenticatedAction(context, () {
                    TalkClapService.removeClap(
                      talk.talkId,
                      talk.userId,
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
