import 'package:flutter/material.dart';

import '../../../../../utilities/constants/app_colors.dart';
import '../../post/widgets/post_icon_widget.dart';

class NavBarIcon extends StatelessWidget {
  final Function() onTap;
  final String icon;
  final Color color;
  const NavBarIcon({
    super.key,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: icon,
      backgroundColor: AppColors.transparent,
      highlightElevation: 0,
      elevation: 0,
      onPressed: onTap,
      child: PostIconWidget(
        icon: icon,
        color: color,
      ),
    );
  }
}
