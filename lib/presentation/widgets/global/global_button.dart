import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_colors.dart';

class GlobalButton extends StatelessWidget {
  final bool isEnabled;
  final String buttonText;
  final VoidCallback? onPressed;

  const GlobalButton({
    super.key,
    required this.isEnabled,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? AppColors.purple : AppColors.grey,
        foregroundColor: Colors.white, 
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: isEnabled ? onPressed : null,
      child: Text(buttonText),
    );
  }
}
