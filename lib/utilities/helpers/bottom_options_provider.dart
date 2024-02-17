import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/bottom_sheet_dialogs.dart';

class BottomOptionsProvider {
  BottomOptionsProvider._();
  static final BottomOptionsProvider _instance = BottomOptionsProvider._();
  static BottomOptionsProvider get instance => _instance;

  List<BottomSheetOptionItem> getOptionsForMyPosts() {
    return [
      BottomSheetOptionItem(
          icon: Icons.delete,
          title: AppTexts.deleteStory,
          key: AppKeys.deleteStory),
    ];
  }

  List<BottomSheetOptionItem> getOptionsForOtherPosts() {
    return [
      BottomSheetOptionItem(
        icon: Icons.block,
        title: AppTexts.blockUser,
        key: AppKeys.blockUser,
      ),
      BottomSheetOptionItem(
        icon: Icons.report,
        title: AppTexts.report,
        key: AppKeys.report,
      ),
    ];
  }

  List<BottomSheetOptionItem> getOptionsForMyTalk() {
    return [
      BottomSheetOptionItem(
          icon: Icons.delete,
          title: AppTexts.deleteTalk,
          key: AppKeys.deleteTalk),
    ];
  }

  List<BottomSheetOptionItem> getOptionsForOtherTalks() {
    return [
      BottomSheetOptionItem(
        icon: Icons.block,
        title: AppTexts.blockUser,
        key: AppKeys.blockUser,
      ),
      BottomSheetOptionItem(
        icon: Icons.report,
        title: AppTexts.report,
        key: AppKeys.report,
      ),
    ];
  }

  List<BottomSheetOptionItem> getOptionsForProfilePhoto() {
    return [
      BottomSheetOptionItem(
        icon: Icons.person_2,
        title: AppTexts.seeProfilePhoto,
        key: AppKeys.seeProfilePhoto,
      ),
      BottomSheetOptionItem(
        icon: Icons.photo,
        title: AppTexts.chooseProfilePic,
        key: AppKeys.chooseAnotherPic,
      ),
      BottomSheetOptionItem(
        icon: Icons.delete,
        title: AppTexts.removePhoto,
        key: AppKeys.removeProfilePic,
      ),
    ];
  }
}
