import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle normalGrey14 = TextStyle(
    fontSize: 14,
    fontStyle: FontStyle.normal,
    color: AppColors.grey,
  );

  static const TextStyle normalLightBlue16 = TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    color: AppColors.lightBlue,
  );

  static const TextStyle normalGrey20 = TextStyle(
    fontSize: 20,
    fontStyle: FontStyle.normal,
    color: AppColors.grey,
  );

  static const TextStyle normalGrey22 = TextStyle(
    fontSize: 22,
    color: AppColors.grey,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle normalBlack20 = TextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle normalBlack24 = TextStyle(
    fontSize: 24,
    color: AppColors.black,
    fontStyle: FontStyle.normal,
  );
}
