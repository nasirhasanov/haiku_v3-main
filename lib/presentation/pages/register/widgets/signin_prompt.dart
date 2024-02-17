import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';

class SignInPrompt extends StatelessWidget {
  final String messageText;
  final String actionText;
  final Function() onActionPressed;
  final Color actionTextColor;

  const SignInPrompt({
    super.key,
    required this.messageText,
    required this.actionText,
    required this.onActionPressed,
    this.actionTextColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft, 
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            messageText,
            style: const TextStyle(fontSize: 14),
          ),
          AppSizedBoxes.w4,
          GestureDetector(
            onTap: onActionPressed,
            child: Text(
              actionText,
              style: TextStyle(
                color: actionTextColor,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
