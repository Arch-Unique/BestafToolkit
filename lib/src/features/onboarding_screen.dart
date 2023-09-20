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
    const InternalCheckPage(),
    const ExternalCalibPage(),
    const KFactorCalculatorPage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    print("in init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Ui.width(context));
    return Scaffold(
      appBar: backAppBar(hasBack: false, title: "Choose What To Do"),
      body: Ui.padding(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  ToolkitModes.values.length, (index) => menuItem(index))),
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
