import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../util_widgets.dart';

class ExternalCalibPage extends StatefulWidget {
  const ExternalCalibPage({super.key});

  @override
  State<ExternalCalibPage> createState() => _ExternalCalibPageState();
}

class _ExternalCalibPageState extends State<ExternalCalibPage> {
  final controller = Get.find<ToolkitController>();
  List<TextEditingController> alltecs = List.generate(8, (index) {
    return TextEditingController(text: index == 0 ? "5000" : null);
  });
  TextEditingController calibByTec = TextEditingController();
  TextEditingController checkByTec = TextEditingController();
  List<List<dynamic>> entries = [];
  int cur = 0;
  List<Widget> allEntryWidgets = [];

  @override
  void initState() {
    // TODO: implement initState
    controller.mode = ToolkitModes.externalCalibration;
    controller.lane = controller.allMetersMap.entries.first.value;
    controller.location = controller.lane.location;

    allEntryWidgets.add(EntryWidget(alltecs.sublist(0, 8)));
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
                  controller.location = controller.lane.location;
                },
                initOption: controller.lane.toString(),
              ),
              AppDivider(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(children: [
                  EntryHeader(),
                  Column(
                    children: allEntryWidgets,
                  ),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (alltecs.length > 14)
                    SizedBox(
                        width: Ui.width(context) / 3,
                        child: AppButton(
                          onPressed: () {
                            List<List<dynamic>> demoEntries = [];
                            int len = alltecs.length ~/ 8;

                            for (var i = 0; i < len; i++) {
                              demoEntries.add(convertTecsToText(
                                  alltecs.sublist(i * 8, (i + 1) * 8)));
                            }
                            len = demoEntries.length;
                            final lastBatch = demoEntries[len - 1];
                            final previousBatch = demoEntries[len - 2];
                            if (previousBatch[1].isEmpty ||
                                previousBatch[2].isEmpty ||
                                previousBatch[6].isEmpty) {
                              Ui.showError(
                                "Please fill Meter and Prover Volume, and Old kFactor",
                              );
                              return;
                            }
                            if (lastBatch[1].isEmpty || lastBatch[2].isEmpty) {
                              Ui.showError(
                                "Please fill Meter and Prover Volume",
                              );
                              return;
                            }
                            final kfac = ToolkitController.calcKFactor(
                                double.parse(lastBatch[0]),
                                double.parse(previousBatch[6]),
                                controller.location.factor,
                                double.parse(lastBatch[2]),
                                double.parse(lastBatch[1]),
                                controller.location == ToolkitLocation.apapa);
                            alltecs[(len * 8) - 2].text = kfac.toString();
                            alltecs[(len * 8) - 3].text = "Y";
                          },
                          text: "Calc KFactor",
                        )),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        if (allEntryWidgets.length < 12) {
                          addNewEntries();
                        }
                      },
                      icon: Icon(Icons.add)),
                  Ui.boxWidth(24),
                  IconButton(
                      onPressed: () {
                        if (allEntryWidgets.length > 1) {
                          removeLastEntries();
                        }
                      },
                      icon: Icon(Icons.remove)),
                ],
              ),
              AppDivider(),
              CustomTextField("Calibrated By", calibByTec),
              CustomTextField("Checked By", checkByTec),
              AppDivider(),
              AppButton(
                onPressed: () async {
                  entries.clear();
                  int len = alltecs.length ~/ 8;

                  for (var i = 0; i < len; i++) {
                    entries.add(
                        convertTecsToText(alltecs.sublist(i * 8, (i + 1) * 8)));
                  }
                  await controller.saveToolkitSheet(
                      checkByTec.text, calibByTec.text, entries);
                },
                text: "Save",
              )
            ],
          ),
        ),
      ),
    );
  }

  addNewEntries() {
    final ntecs = List.generate(8, (index) {
      return TextEditingController(text: index == 0 ? "5000" : null);
    });
    alltecs.addAll(ntecs);
    setState(() {
      allEntryWidgets.add(EntryWidget(ntecs));
    });
  }

  removeLastEntries() {
    alltecs.removeRange(alltecs.length - 8, alltecs.length);
    setState(() {
      allEntryWidgets.removeLast();
    });
  }

  List<String> convertTecsToText(List<TextEditingController> alltecss) {
    return alltecss.map((e) => e.value.text).toList();
  }
}
