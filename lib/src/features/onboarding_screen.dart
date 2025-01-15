import 'package:bestaf_toolkit/src/features/modes/views/demo_check_page.dart';
import 'package:bestaf_toolkit/src/features/modes/views/upload_file_page.dart';
import 'package:bestaf_toolkit/src/features/modes/views/util_widgets.dart';
import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modes/views/barrel.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final screens = [
    const UploadFilePage(0),
    const DemoCheckPage(ToolkitModes.internalCheck),
    const UploadFilePage(1),
    const DemoCheckPage(ToolkitModes.externalCalibration),
    const UploadFilePage(2),
    const UploadFilePage(3),
    const KFactorCalculatorPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(hasBack: false, title: "Bestaf ToolKit", center: true),
      body: Ui.padding(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(Assets.logo, height: 120),
            Ui.boxHeight(24),
            UtilDateTime(),
            Ui.boxHeight(24),
            ...List.generate(
                ToolkitModes.values.length, (index) => menuItem(index))
          ]),
        ),
      ),
    );
  }

  menuItem(int i) {
    return Align(
      alignment: Alignment.center,
      child: CurvedContainer(
        radius: 16,
        width: Ui.width(context) - 56,
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        onPressed: () {
          Get.to(screens[i]);
        },
        color: AppColors.primaryColor,
        child: AppText.button(
          ToolkitModes.values[i].title,
          color: AppColors.white,
          alignment: TextAlign.center,
        ),
      ),
    );
  }
}
