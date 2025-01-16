import 'dart:io';

import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:file_picker/file_picker.dart';
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
            if (widget.curMode != 0)
              CustomTextField.dropdown(
                controller.allMetersMap.keys.toList(),
                tecs[0],
                "Select Lane/Meter",
                initOption: controller.lane.toString(),
              ),
            if (widget.curMode == 3)
              CustomTextField(
                "Enter K Factor",
                tecs[1],
              ),
            CustomTextField(
              "Tap To Select File",
              tecs[2],
              readOnly: true,
              suffix: Icon(Icons.upload_file_rounded),
              onTap: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  tecs[2].text = result.files.single.path!;
                  file = File(result.files.single.path!);
                }
              },
            ),
            if (widget.curMode == 0)
            AppText.bold("Select Lanes"),
            Expanded(
                child: (widget.curMode != 0)
                    ? SizedBox()
                    : ListView.builder(
                        itemBuilder: (_, i) {
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(4),
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
                    if (tecs[0].text.isEmpty) {
                      return Ui.showError("Location/Lane cannot be empty");
                    }
                    if (lanes.isEmpty) return Ui.showError("Lanes empty");
                    await controller.uploadPOforLanes(
                        lanes.map((e) => e.split(" - ")[1].trim()).toList(),
                        controller.allMetersMap[lanes[0]]!.location.title,
                        file!);
                  } else if (widget.curMode == 1 || widget.curMode == 2) {
                    if (tecs[0].text.isEmpty) {
                      return Ui.showError("Location/Lane cannot be empty");
                    }

                    await controller.uploadSheetToLocal(
                        controller.allMetersMap[tecs[0].text]!.lane,
                        controller.allMetersMap[tecs[0].text]!.location.title,
                        file!,
                        isExternal: widget.curMode == 2);
                  } else {
                    if (tecs[0].text.isEmpty) {
                      return Ui.showError("Location/Lane cannot be empty");
                    }
                    if (tecs[1].text.isEmpty) {
                      return Ui.showError("KFactor cannot be empty");
                    }
                    await controller.uploadCertificate(
                        controller.allMetersMap[tecs[0].text]!.lane,
                        controller.allMetersMap[tecs[0].text]!.location.title,
                        file!,
                        double.tryParse(tecs[1].text) ?? 0);
                  }
                },
                text: "Upload File")
          ],
        ),
      ),
    );
  }
}
