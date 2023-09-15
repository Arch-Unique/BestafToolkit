import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/ui/ui_barrel.dart';

class ExternalCalibPage extends StatefulWidget {
  const ExternalCalibPage({super.key});

  @override
  State<ExternalCalibPage> createState() => _ExternalCalibPageState();
}

class _ExternalCalibPageState extends State<ExternalCalibPage> {
  final controller = Get.find<ToolkitController>();

  @override
  void initState() {
    // TODO: implement initState
    controller.mode = ToolkitModes.externalCalibration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "External Calibration",
      child: SingleChildScrollView(
        child: Ui.padding(
          child: Column(
            children: [
              CustomTextField.dropdown(
                controller.allMetersMap.keys.toList(),
                TextEditingController(),
                "Select Lane/Meter",
                onChanged: (p0) {
                  controller.lane = controller.allMetersMap[p0]!;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
