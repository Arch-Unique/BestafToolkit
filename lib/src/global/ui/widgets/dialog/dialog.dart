import 'package:flutter/material.dart';

import '../../ui_barrel.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({required this.title, required this.content, super.key});
  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
    );
  }

  static normal(String title, String body,
      {String titleA = "Yes",
      Function? onPressedA,
      String titleB = "No",
      Function? onPressedB}) {
    return AppDialog(
      title: AppText.medium(title, fontSize: 18),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.thin(body),
          Ui.boxHeight(24),
          AppButton.column(titleA, onPressedA, titleB, onPressedB),
        ],
      ),
    );
  }

  static normalIcon(String icon, String body,
      {String titleA = "",
      Function? onPressedA,
      String titleB = "",
      Function? onPressedB}) {
    return AppDialog(
      title: AppIcon(icon),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.thin(body),
          Ui.boxHeight(24),
          AppButton.column(titleA, onPressedA, titleB, onPressedB),
        ],
      ),
    );
  }

  static status({String body = "", String? icon}) {
    return AppDialog(
        title: icon == null ? SizedBox() : AppIcon(icon),
        content: AppText.thin(body));
  }
}
