import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/ui/ui_barrel.dart';

class InternalCheckPage extends StatefulWidget {
  const InternalCheckPage({super.key});

  @override
  State<InternalCheckPage> createState() => _InternalCheckPageState();
}

class _InternalCheckPageState extends State<InternalCheckPage> {
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
      title: "Internal Check",
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
              ),
              CustomTextField("Programmed Qty", TextEditingController())
            ],
          ),
        ),
      ),
    );
  }
}
