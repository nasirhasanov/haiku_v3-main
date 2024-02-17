import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:haiku/utilities/constants/app_colors.dart';

class GlobalHudLoading extends StatelessWidget {
  const GlobalHudLoading({
    super.key,
    this.color = AppColors.purple,
    this.backgroundColor = Colors.white,
    this.loaderSize = 40.0, // Size of the loader
    this.hudSize = 120.0, // Overall size of the HUD
  });

  final Color color;
  final Color backgroundColor;
  final double loaderSize;
  final double hudSize;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              color: Colors.black,
            ),
          ),
        ),
      Center(
        child: SizedBox(
          width: hudSize,
          height: hudSize,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: SpinKitThreeBounce(
              color: color,
              size: loaderSize,
            ),
          ),
        ),
      ),
    ]);
  }
}
