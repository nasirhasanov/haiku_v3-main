import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_colors.dart';

class ShowProfilePicFullScreen extends StatelessWidget {
  final String imageUrl;

  const ShowProfilePicFullScreen({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(
          color: AppColors.white,),
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }
}
