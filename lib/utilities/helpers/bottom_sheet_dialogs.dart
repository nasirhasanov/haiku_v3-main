import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_colors.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';

class BottomDialog {
  BottomDialog._();

  static void showOptionsDialog({
    required BuildContext context,
    required List<BottomSheetOptionItem> options,
    required Function(BottomSheetOptionItem) onOptionSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              width: 20,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return ListTile(
                  leading: Icon(option.icon),
                  title: Text(option.title),
                  onTap: () {
                    onOptionSelected(option);
                  },
                );
              },
            ),
            AppSizedBoxes.h48,
          ],
        );
      },
    );
  }
}

class BottomSheetOptionItem {
  final IconData? icon;
  final String title;
  final String key;

  BottomSheetOptionItem({
    this.icon,
    required this.title,
    required this.key,
  });
}
