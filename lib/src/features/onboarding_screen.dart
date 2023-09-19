import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modes/controllers/toolkit_controller.dart';
import 'modes/views/barrel.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final screens = [
    InternalCheckPage(),
    ExternalCalibPage(),
    KFactorCalculatorPage(),
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(hasBack: false, title: "Choose What To Do"),
      body: Ui.padding(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                ToolkitModes.values.length, (index) => menuItem(index))),
      ),
    );
  }

  menuItem(int i) {
    return CurvedContainer(
      radius: 16,
      width: Ui.width(context) * 0.667,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      onPressed: () {
        Get.to(screens[i]);
      },
      color: AppColors.primaryColor,
      child:
          AppText.button(ToolkitModes.values[i].title, color: AppColors.white),
    );
  }
}
