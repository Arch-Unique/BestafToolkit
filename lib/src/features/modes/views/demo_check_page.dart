import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/features/modes/views/settings/edit_lanemeter_page.dart';
import 'package:bestaf_toolkit/src/features/modes/views/util_widgets.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/dialog/dialog.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../global/ui/ui_barrel.dart';

class DemoCheckPage extends StatefulWidget {
  const DemoCheckPage(this.toolkitMode, {super.key});
  final ToolkitModes toolkitMode;

  @override
  State<DemoCheckPage> createState() => _DemoCheckPageState();
}

class _DemoCheckPageState extends State<DemoCheckPage> {
  final controller = Get.find<ToolkitController>();
  List<TextEditingController> alltecs = List.generate(9, (index) {
    return TextEditingController();
  });
  TextEditingController calibByTec = TextEditingController();
  TextEditingController checkByTec = TextEditingController();
  List<List<dynamic>> entries = [];
  int cur = 0;
  bool saveDraft = true;
  bool btnPressed = false;
  List<Widget> allEntryWidgets = [];

  @override
  void initState() {
    // TODO: implement initState
    controller.resetToolkitSheet();
    controller.mode = widget.toolkitMode;
    controller.lane = controller.allMetersMap.entries.first.value;
    controller.ref = controller.allRefsMap.entries.first.value;
    controller.location = controller.lane.location;
    allEntryWidgets.add(EntryWidget(alltecs.sublist(0, 9)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This callback will be called after the build is complete.
      if (controller.getToolkitLater() != null) {
        showDialog(
            context: context,
            builder: (context) => AppDialog.normal("Continue",
                    "You have a pending toolkit sheet. Do you want to continue?",
                    onPressedA: () {
                  final c = controller.useOldToolkit();
                  useOldEntries(c);
                  setState(() {});
                  Get.back();
                }, onPressedB: () {
                  controller.clearOldToolkit();
                  Get.back();
                }));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: widget.toolkitMode.title,
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
              CustomTextField.dropdown(
                controller.allRefsMap.keys.toList(),
                TextEditingController(),
                "Select Reference Instrument",
                onChanged: (p0) {
                  controller.ref = controller.allRefsMap[p0]!;
                },
                initOption: controller.ref.toString(),
              ),
              EntryDetails(),
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
                  if (widget.toolkitMode == ToolkitModes.externalCalibration &&
                      alltecs.length > 14)
                    SizedBox(
                        width: Ui.width(context) / 3,
                        child: AppButton(
                          onPressed: () {
                            List<List<dynamic>> demoEntries = [];
                            int len = alltecs.length ~/ 9;

                            for (var i = 0; i < len; i++) {
                              demoEntries.add(convertTecsToText(
                                  alltecs.sublist(i * 9, (i + 1) * 9)));
                            }
                            len = demoEntries.length;
                            final lastBatch = demoEntries[len - 1];
                            if (lastBatch[1].isEmpty ||
                                lastBatch[2].isEmpty ||
                                lastBatch[6].isEmpty) {
                              Ui.showError(
                                "Please fill Meter and Prover Volume, and Old kFactor",
                              );
                              return;
                            }

                            showDialog(
                                context: context,
                                builder: (_) {
                                  final teckfac = TextEditingController();
                                  return AppDialog(
                                      title: AppText.medium(
                                          "Enter Desired K Factor"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            "K-Factor",
                                            teckfac,
                                            varl: FPL.number,
                                            shdValidate: false,
                                          ),
                                          AppButton(
                                            onPressed: () {
                                              final kfac =
                                                  ToolkitController.calcKFactor(
                                                      double.parse(
                                                          lastBatch[0]),
                                                      double.parse(
                                                          lastBatch[6]),
                                                      double.parse(
                                                          teckfac.value.text),
                                                      double.parse(
                                                          lastBatch[2]),
                                                      double.parse(
                                                          lastBatch[1]),
                                                      controller.location ==
                                                          ToolkitLocation
                                                              .apapa);
                                              alltecs[(len * 9) - 2].text =
                                                  kfac.toStringAsFixed(4);
                                              alltecs[(len * 9) - 4].text = "Y";
                                              Get.back();
                                            },
                                            text: "Continue",
                                          )
                                        ],
                                      ));
                                });
                          },
                          text: "Calc KFactor",
                        )),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        if (allEntryWidgets.length < 11) {
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
              CustomTextField("Checked By", checkByTec),
              SignatureView(true),
              AppDivider(),
              CustomTextField("Calibrated By", calibByTec),
              SignatureView(false),
              AppDivider(),
              SizedBox(
                width: Ui.width(context) - 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          saveDraft = true;

                          if (checkByTec.text.isEmpty ||
                              calibByTec.text.isEmpty) {
                            Ui.showError("Please fill all fields");
                            return;
                          }
                          saveDraft = false;

                          populateEntries();

                          await controller.shareToolkitSheet(
                              checkByTec.text, calibByTec.text, entries);
                        },
                        icon: Icon(
                          Icons.share,
                          color: AppColors.black,
                        )),
                    IconButton(
                        onPressed: () async {
                          saveDraft = true;

                          if (checkByTec.text.isEmpty ||
                              calibByTec.text.isEmpty) {
                            Ui.showError("Please fill all fields");
                            return;
                          }
                          saveDraft = false;
                          populateEntries();
                          await Get.showOverlay(
                              asyncFunction: sharepointShare,
                              loadingWidget: LoadingOverlay());
                          // try {
                          //   await ;
                          // } catch (e) {
                          //   // TODO
                          //   Ui.showError("Conversion to PDF failed");
                          // }
                        },
                        icon: Logo(
                          Logos.microsoft,
                        )),
                    IconButton(
                        onPressed: () async {
                          saveDraft = true;
                          await saveDraftNow();
                        },
                        icon: Icon(
                          Icons.drafts,
                          color: AppColors.grey,
                        )),
                    IconButton(
                        onPressed: () async {
                          saveDraft = false;
                          if (checkByTec.text.isEmpty ||
                              calibByTec.text.isEmpty) {
                            Ui.showError("Please fill all fields");
                            return;
                          }
                          populateEntries();
                          await Get.showOverlay(
                              asyncFunction: _simulateAsyncTask,
                              loadingWidget: LoadingOverlay());
                        },
                        icon: Icon(
                          Icons.save,
                          color: AppColors.green,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() async {
    print("entries");
    super.dispose();
    if (!saveDraft) return;
    populateEntries();
    for (var element in entries) {
      if (element.where((i) => i.toString().isNotEmpty).toList().length > 2) {
        break;
      } else {
        btnPressed = false;
      }
    }

    if (btnPressed) {
      await saveDraftNow();
    }
  }

  Future<void> saveDraftNow() async {
    populateEntries();
    await controller.saveToolkitLater(entries);
    // Get.back();

    Ui.showInfo("Draft Saved Successfully");
  }

  void populateEntries() {
    entries.clear();
    int len = alltecs.length ~/ 9;

    for (var i = 0; i < len; i++) {
      entries.add(convertTecsToText(alltecs.sublist(i * 9, (i + 1) * 9)));
    }
    btnPressed = true;
  }

  addNewEntries() {
    final ntecs = List.generate(9, (index) {
      return TextEditingController();
    });
    alltecs.addAll(ntecs);
    setState(() {
      allEntryWidgets.add(EntryWidget(ntecs));
    });
  }

  removeLastEntries() {
    alltecs.removeRange(alltecs.length - 9, alltecs.length);
    setState(() {
      allEntryWidgets.removeLast();
    });
  }

  List<String> convertTecsToText(List<TextEditingController> alltecss) {
    return alltecss.map((e) => e.value.text).toList();
  }

  void useOldEntries(List<List<dynamic>> entries) {
    alltecs = [];
    allEntryWidgets = [];

    final ntecs = List.generate(entries.length * 9, (index) {
      return TextEditingController();
    });
    alltecs.addAll(ntecs);

    for (int j = 0; j < entries.length; j++) {
      var element = entries[j];
      for (var i = 0; i < element.length; i++) {
        alltecs[(j * 9) + i].text = element[i].toString();
      }
      allEntryWidgets.add(EntryWidget(alltecs.sublist(j * 9, (j + 1) * 9)));
    }
  }

  Future _simulateAsyncTask() async {
    await controller.saveToolkitSheet(
        checkByTec.text, calibByTec.text, entries);
    controller.clearOldToolkit();

    Get.back();

    Ui.showInfo("Saved Successfully");
  }

  Future sharepointShare() async {
    await controller.printToolkitSheet(
        checkByTec.text, calibByTec.text, entries);
  }
}
