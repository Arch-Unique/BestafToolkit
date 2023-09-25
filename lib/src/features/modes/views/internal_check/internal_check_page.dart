import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/features/modes/views/settings/edit_lanemeter_page.dart';
import 'package:bestaf_toolkit/src/features/modes/views/util_widgets.dart';
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
  List<TextEditingController> alltecs = List.generate(9, (index) {
    return TextEditingController();
  });
  TextEditingController calibByTec = TextEditingController();
  TextEditingController checkByTec = TextEditingController();
  List<List<dynamic>> entries = [];
  int cur = 0;
  List<Widget> allEntryWidgets = [];

  @override
  void initState() {
    // TODO: implement initState
    controller.mode = ToolkitModes.internalCheck;

    controller.lane = controller.allMetersMap.entries.first.value;
    controller.location = controller.lane.location;
    allEntryWidgets.add(EntryWidget(alltecs.sublist(0, 9)));
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
              AppButton.row(
                  "Share",
                  () async {
                    entries.clear();
                    int len = alltecs.length ~/ 9;

                    for (var i = 0; i < len; i++) {
                      entries.add(convertTecsToText(
                          alltecs.sublist(i * 9, (i + 1) * 9)));
                    }
                    await controller.shareToolkitSheet(
                        checkByTec.text, calibByTec.text, entries);
                  },
                  "Print",
                  () async {
                    entries.clear();
                    int len = alltecs.length ~/ 9;

                    for (var i = 0; i < len; i++) {
                      entries.add(convertTecsToText(
                          alltecs.sublist(i * 9, (i + 1) * 9)));
                    }
                    await controller.printToolkitSheet(
                        checkByTec.text, calibByTec.text, entries);
                  })
            ],
          ),
        ),
      ),
    );
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
}
