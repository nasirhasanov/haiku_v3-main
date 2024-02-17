import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utilities/constants/app_assets.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final double? imageRadius;
  final String? imageUrl;

  const ProfilePhotoWidget({
    super.key,
    this.imageRadius = 28,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: imageRadius,
      backgroundImage: imageUrl != null
          ? CachedNetworkImageProvider(imageUrl!)
          : const AssetImage(AppAssets.profileAvatar) as ImageProvider,
    );
  }
}
