import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/ui/ui_barrel.dart';

class KFactorCalculatorPage extends StatefulWidget {
  const KFactorCalculatorPage({super.key});

  @override
  State<KFactorCalculatorPage> createState() => _KFactorCalculatorPageState();
}

class _KFactorCalculatorPageState extends State<KFactorCalculatorPage> {
  final controller = Get.find<ToolkitController>();

  @override
  void initState() {
    // TODO: implement initState
    controller.mode = ToolkitModes.internalCheck;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "K-Factor Calculator",
      child: SingleChildScrollView(
        child: Ui.padding(
          child: Column(
            children: [
              CustomTextField.dropdown(
                ToolkitLocation.values.map((e) => e.title).toList(),
                TextEditingController(),
                "Location",
                onChanged: (p0) {
                  controller.location = ToolkitLocation.values
                      .firstWhere((element) => element.title == p0);
                },
              ),
              CustomTextField("Batch Volume", TextEditingController()),
              CustomTextField("Old K Factor", TextEditingController()),
              Ui.padding(child: AppDivider()),
              CustomTextField("Prover Volume", TextEditingController()),
              CustomTextField("Meter Volume", TextEditingController()),
              Ui.padding(child: AppDivider()),
              AppButton(
                onPressed: () {},
                text: "Calculate",
              )
            ],
          ),
        ),
      ),
    );
  }
}
