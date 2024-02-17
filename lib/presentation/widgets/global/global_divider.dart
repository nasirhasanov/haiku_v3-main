import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_colors.dart';

class GlobalDivider extends StatelessWidget {
  final double height;
  final double width;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final Color color;

  const GlobalDivider.horizontal({
    super.key,
    this.height = 0.3,
    this.width = double.infinity,
    this.left = 0,
    this.right = 0,
    this.top = 10,
    this.bottom = 10,
    this.color = AppColors.grey300,
  });

  const GlobalDivider.vertical({
    super.key,
    this.height = double.infinity,
    this.width = 0.3,
    this.left = 10,
    this.right = 10,
    this.top = 0,
    this.bottom = 0,
    this.color = AppColors.grey300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
      margin: EdgeInsetsDirectional.only(
        start: left,
        end: right,
        top: top,
        bottom: bottom,
      ),
    );
  }
}
