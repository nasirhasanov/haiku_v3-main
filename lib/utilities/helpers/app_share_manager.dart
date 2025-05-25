import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/app_colors.dart';
import '../constants/app_keys.dart';
import '../constants/app_paddings.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_texts.dart';

class AppShareManager {
  /// The app store link for sharing
  static const String appStoreLink = 'https://play.google.com/store/apps/details?id=com.haiku.android';
  
  /// Share text template
  static const String _shareTextTemplate = 'Check out Haiku, for sharing your poems, ideas and thoughts! ';

  /// Checks the number of app launches and suggests sharing on the 3rd launch.
  /// Returns true if the share dialog should be shown.
  Future<bool> checkAndRequestShare(BuildContext context) async {
    var box = Hive.box(AppKeys.userDataBox);
    var launchCount = box.get(AppKeys.shareAppPrompt) ?? 0;

    // Increment the launch count.
    launchCount++;
    await box.put(AppKeys.shareAppPrompt, launchCount);

    // Show share dialog on the 3rd launch.
    bool shouldShow = launchCount == 3;
    
    if (shouldShow) {
      // Delay showing the prompt a bit to let the app load
      Future.delayed(const Duration(seconds: 2), () {
        showShareDialog(context);
      });
    }
    
    return shouldShow;
  }

  /// Shows a bottom sheet dialog prompting the user to share the app with friends.
  void showShareDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: AppPaddings.a30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppTexts.inviteFriends,
                style: AppTextStyles.normalGrey20.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppTexts.inviteDescription,
                style: AppTextStyles.normalGrey14,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  shareApp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  AppTexts.shareWithFriends,
                  style: AppTextStyles.normalGrey14.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppTexts.cancel,
                style: AppTextStyles.normalGrey14.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shares the app with friends using the device's share dialog.
  Future<void> shareApp() async {
    await Share.share(
      '$_shareTextTemplate$appStoreLink',
    );
  }
  
  /// Allows users to share the app via an invite button.
  void onInviteFriends(BuildContext context) async {
    shareApp();
  }
} 