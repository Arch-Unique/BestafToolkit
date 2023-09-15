import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modes/controllers/toolkit_controller.dart';
import 'modes/views/barrel.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  final screens = [
    InternalCheckPage(),
    ExternalCalibPage(),
    KFactorCalculatorPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ToolkitController>();
    controller.initLanes();
    return Scaffold(
      appBar: backAppBar(hasBack: false, title: "Choose What To Do"),
      body: Ui.padding(
        child: Column(
            children: List.generate(
                ToolkitModes.values.length, (index) => menuItem(index))),
      ),
    );
  }

  menuItem(int i) {
    return CurvedContainer(
      radius: 16,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onPressed: () {
        Get.to(screens[i]);
      },
      child:
          AppText.button(ToolkitModes.values[i].title, color: AppColors.white),
    );
  }
}
