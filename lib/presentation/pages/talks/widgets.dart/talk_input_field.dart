import 'package:flutter/material.dart';
import 'package:haiku/data/services/user/user_info_service.dart';
import 'package:haiku/presentation/widgets/global/profile_photo_widget.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/helpers/text_input_max_lines_formatter.dart';

class TalkInputField extends StatelessWidget {
  TalkInputField({super.key, this.onChanged, this.onTapSend});

  final void Function(String)? onChanged;
  final void Function()? onTapSend;

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          color: Colors.grey[200],
          child: Row(
            children: [
              ProfilePhotoWidget(
                imageUrl: UserInfoService.getInfo(AppKeys.profilePicPath),
              ),
              AppSizedBoxes.w4,
              Expanded(
                  child: TextField(
                controller: _textController,
                onChanged: onChanged,
                maxLength: 100,
                maxLines: 5,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Talk something!',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(20),
                  counterText: "",
                ),
                inputFormatters: [
                  MaxLinesTextInputFormatter(maxLines: 5),
                ],
              )),
              AppSizedBoxes.w4,
              ElevatedButton(
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    onTapSend?.call();
                    _textController.clear();
                  }
                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
