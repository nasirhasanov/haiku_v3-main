import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_colors.dart';
import 'package:haiku/utilities/helpers/text_input_max_lines_formatter.dart';

class PostTextInput extends StatelessWidget {
  const PostTextInput({
    super.key,
    this.hintText,
    this.onChanged,
  });

  final String? hintText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      surfaceTintColor: AppColors.white,
      child: TextField(
        onChanged: onChanged,
        maxLength: 100,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: hintText, 
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(20),
          counterText: "",
        ),
        inputFormatters: [
          MaxLinesTextInputFormatter(maxLines: 5),
        ],
      ),
    );
  }
}
