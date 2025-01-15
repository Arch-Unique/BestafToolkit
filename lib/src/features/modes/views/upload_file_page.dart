import 'dart:io';

import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../global/ui/widgets/fields/custom_textfield.dart';
import '../../../src_barrel.dart';

class UploadFilePage extends StatefulWidget {
  const UploadFilePage(this.curMode, {super.key});
  final int curMode;

  @override
  State<UploadFilePage> createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  List<String> modes = [
    "PO",
    "Internal Calibration",
    "External Calibration",
    "Certificate"
  ];

  List<TextEditingController> tecs =
      List.generate(6, (i) => TextEditingController());
  final controller = Get.find<ToolkitController>();
  List<String> lanes = [];
  File? file;

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Upload ${modes[widget.curMode]}",
      child: Ui.padding(
        child: Column(
          children: [
            CustomTextField.dropdown(
                ToolkitLocation.values.map((e) => e.title).toList(),
                tecs[0],
                "Select Location",
                initOption: "TINCAN"),
            if (widget.curMode == 0)
              CustomTextField.dropdown(
                controller.allMetersMap.keys.toList(),
                tecs[1],
                "Select Lane/Meter",
                initOption: controller.lane.toString(),
              ),
            if (widget.curMode == 3)
              CustomTextField(
                "Enter K Factor",
                tecs[2],
              ),
            Expanded(
                child: (widget.curMode != 0)
                    ? SizedBox()
                    : ListView.builder(
                        itemBuilder: (_, i) {
                          return ListTile(
                            title: AppText.thin(
                                controller.allMetersMap.keys.toList()[i]),
                            selected: lanes.contains(
                                controller.allMetersMap.keys.toList()[i]),
                            trailing: lanes.contains(
                                    controller.allMetersMap.keys.toList()[i])
                                ? AppIcon(Icons.check)
                                : null,
                            onTap: () {
                              setState(() {
                                if (lanes.contains(
                                    controller.allMetersMap.keys.toList()[i])) {
                                  lanes.remove(
                                      controller.allMetersMap.keys.toList()[i]);
                                } else {
                                  lanes.add(
                                      controller.allMetersMap.keys.toList()[i]);
                                }
                              });
                            },
                          );
                        },
                        itemCount: controller.allMetersMap.keys.toList().length,
                      )),
            AppButton(
                onPressed: () async {
                  if (file == null) return Ui.showError("File cannot be empty");
                  if (widget.curMode == 0) {
                    if (tecs[0].text.isEmpty)
                      return Ui.showError("Location cannot be empty");
                    if (lanes.isEmpty) return Ui.showError("Lanes empty");
                    await controller.uploadPOforLanes(
                        lanes, tecs[0].text, file!);
                  } else if (widget.curMode == 1 || widget.curMode == 2) {
                    if (tecs[0].text.isEmpty)
                      return Ui.showError("Location cannot be empty");
                    if (tecs[1].text.isEmpty)
                      return Ui.showError("Lane cannot be empty");
                    await controller.uploadSheetToLocal(
                        tecs[1].text, tecs[0].text, file!,
                        isExternal: widget.curMode == 2);
                  } else {
                    if (tecs[0].text.isEmpty)
                      return Ui.showError("Location cannot be empty");
                    if (tecs[1].text.isEmpty)
                      return Ui.showError("Lane cannot be empty");
                    if (tecs[2].text.isEmpty)
                      return Ui.showError("KFactor cannot be empty");
                    await controller.uploadCertificate(
                        tecs[1].text,
                        tecs[0].text,
                        file!,
                        double.tryParse(tecs[2].text) ?? 0);
                  }
                },
                text: "Upload File")
          ],
        ),
      ),
    );
  }
}
