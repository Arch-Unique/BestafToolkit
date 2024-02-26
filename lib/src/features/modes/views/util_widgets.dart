import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/features/modes/views/settings/edit_lanemeter_page.dart';
import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../src_barrel.dart';
import 'settings/edit_ref.dart';

class EntryWidget extends StatefulWidget {
  final List<TextEditingController> tecs;
  const EntryWidget(this.tecs, {super.key});

  @override
  State<EntryWidget> createState() => _EntryWidgetState();
}

class _EntryWidgetState extends State<EntryWidget> {
  @override
  void initState() {
    // TODO: implement initState
    widget.tecs[5].text = "N";
    widget.tecs[0].text = "5000";
    widget.tecs[1].addListener(() {
      if (widget.tecs[1].text.isNotEmpty && widget.tecs[2].text.isNotEmpty) {
        setState(() {
          final diff = (double.parse(widget.tecs[2].value.text) -
                  double.parse(widget.tecs[1].value.text))
              .toPrecision(2);

          widget.tecs[3].text = diff.toString();
        });
      }
    });
    widget.tecs[2].addListener(() {
      if (widget.tecs[1].text.isNotEmpty && widget.tecs[2].text.isNotEmpty) {
        setState(() {
          final diff = (double.parse(widget.tecs[2].value.text) -
                  double.parse(widget.tecs[1].value.text))
              .toPrecision(2);

          widget.tecs[3].text = diff.toString();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.tecs.length, (index) {
        if (index == 5 || index == 8) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
            child: CustomTextField(
              "",
              widget.tecs[index],
              varl: FPL.text,
              readOnly: index == 5,
              onTap: index == 5
                  ? () {
                      widget.tecs[index].text =
                          widget.tecs[index].text == "Y" ? "N" : "Y";
                    }
                  : null,
              isEntry: true,
              shdValidate: false,
              hasBottomPadding: false,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
          child: CustomTextField(
            "",
            widget.tecs[index],
            varl: FPL.number,
            isEntry: true,
            readOnly: index == 3,
            shdValidate: false,
            hasBottomPadding: false,
          ),
        );
      }),
    );
  }
}

class EntryHeader extends StatelessWidget {
  EntryHeader({super.key});
  final List<String> headerTexts = [
    "Prog Qty",
    "Meter Vol",
    "Ref Vol",
    "Difference",
    "Flowrate",
    "Adjustment",
    "Old K-Factor",
    "New K-Factor",
    "Remarks"
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(9, (index) {
        return Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
            child: SizedBox(
              width: 84,
              height: 48,
              child: AppText.bold(headerTexts[index],
                  color: AppColors.black, fontSize: 14),
            ));
      }),
    );
  }
}

class SignatureView extends StatefulWidget {
  const SignatureView(this.isCheck, {super.key});
  final bool isCheck;

  @override
  State<SignatureView> createState() => _SignatureViewState();
}

class _SignatureViewState extends State<SignatureView> {
  bool isCaptured = false;
  Uint8List? bytes;
  final controller = Get.find<ToolkitController>();

  GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.black, width: 1)),
          height: 84,
          width: 480,
          child: isCaptured && bytes != null
              ? Image.memory(bytes!)
              : SfSignaturePad(
                  key: signaturePadKey,
                  backgroundColor: AppColors.white,
                ),
        ),
        Ui.boxHeight(24),
        AppButton.row(
          "Capture",
          () async {
            ui.Image image = await signaturePadKey.currentState!.toImage();
            var data = await image.toByteData(format: ui.ImageByteFormat.png);
            final dd = data!.buffer.asUint8List();

            if (widget.isCheck) {
              controller.checkSig = dd;
            } else {
              controller.calibSig = dd;
            }
            Ui.showInfo("Signature captured");
            setState(() {
              bytes = dd;
              isCaptured = true;
            });
          },
          "Clear",
          () {
            if (isCaptured) {
              setState(() {
                isCaptured = false;
                bytes = null;
              });
            } else {
              signaturePadKey.currentState!.clear();
            }
          },
        )
      ],
    );
  }
}

class EntryDetails extends StatelessWidget {
  const EntryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ToolkitController>();
    return SizedBox(
      width: Ui.width(context) - 48,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.medium("Reference Details"),
                Obx(() {
                  return AppText.thin("TYPE: ${controller.ref.type}");
                }),
                Obx(() {
                  return AppText.thin("MODEL: ${controller.ref.model}");
                }),
                Obx(() {
                  return AppText.thin("SERIAL NO: ${controller.ref.serialno}");
                }),
                Obx(() {
                  return AppText.thin("CAPACITY: ${controller.ref.capacity}");
                }),
                Obx(() {
                  return AppText.thin("MAKE: ${controller.ref.make}");
                }),
                AppButton.white(() {
                  Get.to(EditRefInstrument(
                      index: controller.allRefs.indexWhere((element) =>
                          element.toString() == controller.ref.toString()),
                      lm: controller.ref));
                  controller.ref = controller.allRefs[controller.allRefs
                      .indexWhere((element) =>
                          element.toString() == controller.ref.toString())];
                }, "Edit")
              ],
            ),
          ),
          Ui.boxWidth(48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.medium("Meter Details"),
                Obx(() {
                  return AppText.thin("MAKE: ${controller.lane.make}");
                }),
                Obx(() {
                  return AppText.thin("MODEL: ${controller.lane.model}");
                }),
                Obx(() {
                  return AppText.thin("SERIAL NO: ${controller.lane.serialno}");
                }),
                Obx(() {
                  return AppText.thin(
                      "FLOW RANGE: ${controller.lane.flowrange}");
                }),
                Obx(() {
                  return AppText.thin(
                      "PRODUCT TYPE: ${controller.lane.product}");
                }),
                AppButton.white(() async {
                  Get.to(EditLaneMeter(
                      index: controller.allMeters.indexWhere((element) =>
                          element.toString() == controller.lane.toString()),
                      lm: controller.lane));
                  controller.lane = controller.allMeters[controller.allMeters
                      .indexWhere((element) =>
                          element.toString() == controller.lane.toString())];
                }, "Edit")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UtilDateTime extends StatefulWidget {
  const UtilDateTime({super.key});

  @override
  State<UtilDateTime> createState() => _UtilDateTimeState();
}

class _UtilDateTimeState extends State<UtilDateTime> {
  RxString dtText =
      DateFormat("dd/MM/yyyy hh:mm:ss").format(DateTime.now()).obs;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      dtText.value = DateFormat("dd/MM/yyyy hh:mm:ss").format(DateTime.now());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppText.medium(dtText.value, color: AppColors.black, fontSize: 14);
    });
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          AppText.bold('Please Wait ...', color: AppColors.white),
        ],
      ),
    );
  }
}
