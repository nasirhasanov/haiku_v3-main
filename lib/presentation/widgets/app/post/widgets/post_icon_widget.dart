import 'package:flutter/material.dart';

class PostIconWidget extends StatelessWidget {
  final String icon;
  final Color color;
  const PostIconWidget({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      icon,
      color: color,
      height: 24,
      width: 24,
    );
  }
}
