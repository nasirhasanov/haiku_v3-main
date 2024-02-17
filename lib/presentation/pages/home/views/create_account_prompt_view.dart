import 'package:flutter/material.dart';
import 'package:haiku/presentation/widgets/global/global_button.dart';
import 'package:haiku/utilities/constants/app_assets.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/app_sizes.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';

class CreateAccountPromptView extends StatelessWidget {
  final TabController tabController;
  const CreateAccountPromptView({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.createAccount),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            Image.asset(
              AppAssets.magicBook,
              width: 100,
              height: 100,
            ),
            AppSizedBoxes.h20,
            const Text(
              AppTexts.signInToTellStories,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppSizes.d20),
              child: GlobalButton(
                buttonText: AppTexts.signIn,
                isEnabled: true,
                onPressed: () {
                  Go.to(context, Pager.login);
                },
              ),
            ),
            AppSizedBoxes.h20,
          ],
        ),
      ),
    );
  }
}
