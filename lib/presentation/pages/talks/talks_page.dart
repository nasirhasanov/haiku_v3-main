import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/talks/talks_cubit.dart';
import 'package:haiku/data/data_sources/remote/firebase/clap/clap_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/user_info_service.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/presentation/pages/home/widgets/talks_builder.dart';
import 'package:haiku/presentation/pages/talks/widgets.dart/talk_input_field.dart';
import 'package:haiku/presentation/widgets/app/talks/post_widget_for_talks.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';
import 'package:haiku/utilities/helpers/toast.dart';
import 'package:nil/nil.dart';

class TalksPage extends StatefulWidget {
  const TalksPage({super.key});

  @override
  State<TalksPage> createState() => _TalksPageState();
}

class _TalksPageState extends State<TalksPage> {
  @override
  Widget build(BuildContext context) {
    final talksCubit = context.read<TalksCubit>();
    String talkText = "";

    return Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.talks),
          centerTitle: true,
        ),
        body: BlocBuilder<TalksCubit, TalksState>(builder: (context, state) {
          if (state is TalksLoading || state is TalksInitial) {
            return const GlobalLoading();
          } else if (state is TalksSuccess) {
            return Column(
              children: [
                StreamBuilder<PostModel?>(
                    stream: talksCubit.postInfoStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return PostWidgetForTalks(
                          postModel: snapshot.data!,
                          onTapLike: () {
                            AuthUtils().handleAuthenticatedAction(context,
                                () async {
                              ClapService.addClap(
                                snapshot.data!.postId,
                                UserInfoService.getInfo(AppKeys.username) ?? '',
                                snapshot.data!.userId,
                              );
                            });
                          },
                          onTapUnLike: () {
                            AuthUtils().handleAuthenticatedAction(context, () {
                              ClapService.removeClap(
                                snapshot.data!.postId,
                                snapshot.data!.userId,
                              );
                            });
                          },
                          onTapProfileImage: () {},
                        );
                      } else {
                        return const Center(
                          child: Text('Some Error occurred'),
                        );
                      }
                    }),
                Expanded(
                  child: TalksBuilder(
                    stream: talksCubit.talksStream,
                    onRefresh: () async =>
                        await talksCubit.getTalks(isRefresh: true),
                  ),
                ),
                TalkInputField(
                  onChanged: (text) => {talkText = text},
                  onTapSend: () async {
                    var isSent = await talksCubit.sendTalk(
                      talkText: talkText,
                      postId: talksCubit.postId,
                      posterId: talksCubit.posterId,
                    );
                    if (isSent) {
                      talksCubit.getTalks(isRefresh: true);
                    }
                    if (mounted) {
                      final message = isSent
                          ? AppTexts.talkSentSuccessfully
                          : AppTexts.anErrorOccurred;
                      Toast.show(message, context);
                    }
                  },
                ),
              ],
            );
          }
          return nil;
        }));
  }
}
