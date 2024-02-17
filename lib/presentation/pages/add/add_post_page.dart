import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/user/profile_cubit.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/data/services/post/add_new_post_service.dart';
import 'package:haiku/presentation/pages/add/widgets/post_text_input.dart';
import 'package:haiku/presentation/widgets/global/global_divider.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/presentation/widgets/global/profile_photo_widget.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/input_hints_util.dart';
import 'package:haiku/utilities/helpers/toast.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  AddPostPageState createState() => AddPostPageState();
}

class AddPostPageState extends State<AddPostPage> {
  String _text = "";
  bool _isPosting = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return StreamBuilder<UserInfoModel?>(
        initialData: null,
        stream: cubit.userInfoStream,
        builder: (context, snapshot) {
          final profilePicUrl = snapshot.data?.profilePicPath;
          final userName = snapshot.data?.userName;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Go.back(context);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => _handlePosting(context, userName ?? ''),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: (_text.trim().isEmpty || _isPosting)
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ProfilePhotoWidget(imageRadius: 44, imageUrl: profilePicUrl),
                  AppSizedBoxes.h16,
                  PostTextInput(
                    hintText: HintsUtil.getRandomPostHint(),
                    onChanged: (text) => {
                      setState(() {
                        _text = text;
                      })
                    },
                  ),
                  const Spacer(),
                  if (_isPosting) const GlobalLoading(),
                  const Spacer(),
                  const GlobalDivider.horizontal(height: 1),
                  Align(
                    alignment: Alignment.center,
                    child: Text('${_text.length} / 100',
                        style: const TextStyle(color: Colors.grey)),
                  ),
                  AppSizedBoxes.h16
                ],
              ),
            ),
          );
        });
  }

  void _handlePosting(BuildContext context, String userName) async {
    if (_text.trim().isEmpty && _isPosting) {
      return;
    }
    setState(() {
      _isPosting = true;
    });
    bool success = await AddPostService().attemptToPost(_text.trim(), userName);
    setState(() {
      _isPosting = false;
    });

    if (success) {
      Go.back(context);
    } else {
      Toast.show('Failed to post.', context);
    }
  }
}
