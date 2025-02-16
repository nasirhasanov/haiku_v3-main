import 'package:hive/hive.dart';
import 'package:in_app_review/in_app_review.dart';

import '../constants/app_keys.dart';

class AppReviewManager {

  /// Checks the number of app launches and triggers a review request on the 3rd launch.
  Future<void> checkAndRequestReview() async {
    var box = Hive.box(AppKeys.userDataBox);
    var launchCount = box.get(AppKeys.showReview) ?? 0;

    // Increment the launch count.
    launchCount++;
    await box.put(AppKeys.showReview, launchCount);

    // Request review on the 3rd launch.
    if (launchCount == 3) {
      await requestReview();
    }
  }

  /// Triggers the in-app review prompt or opens the store listing if not available.
  Future<void> requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    } else {
      await inAppReview.openStoreListing(
        appStoreId: 'com.haiku.android',
      );
    }
  }
}