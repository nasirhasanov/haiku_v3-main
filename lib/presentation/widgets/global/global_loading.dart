import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../utilities/constants/app_colors.dart';

class GlobalLoading extends StatelessWidget {
  const GlobalLoading({
    super.key,
    this.color = AppColors.purple,
  });
  const GlobalLoading.white({
    super.key,
    this.color = AppColors.white,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color,
      size: 24,
    );
  }
}
