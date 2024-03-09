import 'package:flutter/material.dart';

import '../extensions/color_extensions.dart';
import 'app_colors.dart';

class AppThemes {
  const AppThemes._();

static ThemeData get appTheme => ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: AppColors.purple.toMaterialColor,
  ),
  scaffoldBackgroundColor: AppColors.white,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.grey), 
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.grey), 
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.purple), 
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.red), 
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.red), 
    ),
    floatingLabelStyle: TextStyle(color: AppColors.black), 
    labelStyle: TextStyle(color: AppColors.black), 
  ),
  
);
}
