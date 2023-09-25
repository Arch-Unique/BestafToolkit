import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/features/modes/models/lanemeter.dart';
import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EditLaneMeter extends StatefulWidget {
  const EditLaneMeter({this.lm, this.index = -1, super.key});
  final LaneMeter? lm;
  final int index;

  @override
  State<EditLaneMeter> createState() => _EditLaneMeterState();
}

class _EditLaneMeterState extends State<EditLaneMeter> {
  final controller = Get.find<ToolkitController>();
  List<TextEditingController> tecs =
      List.generate(8, (index) => TextEditingController());

  @override
  void initState() {
    // TODO: implement initState
    tecs[6].text = "TINCAN";
    if (widget.index != -1) {
      tecs[0].text = widget.lm!.make;
      tecs[1].text = widget.lm!.model;
      tecs[2].text = widget.lm!.serialno;
      tecs[3].text = widget.lm!.flowrange;
      tecs[4].text = widget.lm!.product;
      tecs[5].text = widget.lm!.checks.toString();
      tecs[6].text = widget.lm!.location.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title:
          widget.lm == null ? "Add New Meter" : "Edit ${widget.lm.toString()}",
      child: SingleChildScrollView(
        child: Ui.padding(
          child: Column(
            children: [
              CustomTextField("Make", tecs[0]),
              CustomTextField("Model", tecs[1]),
              CustomTextField("Serial No", tecs[2]),
              CustomTextField("Flow Range", tecs[3]),
              CustomTextField("Product", tecs[4]),
              CustomTextField(
                "Checks Freq (In days)",
                tecs[5],
                varl: FPL.number,
                shdValidate: false,
              ),
              CustomTextField.dropdown(
                  ToolkitLocation.values.map((e) => e.title).toList(),
                  tecs[6],
                  "Location",
                  initOption: tecs[6].text),
              AppButton(
                onPressed: () {
                  if (tecs[0].text.isEmpty ||
                      tecs[1].text.isEmpty ||
                      tecs[2].text.isEmpty ||
                      tecs[3].text.isEmpty ||
                      tecs[4].text.isEmpty ||
                      tecs[5].text.isEmpty ||
                      tecs[6].text.isEmpty) {
                    Ui.showError("Fields cannot be empty");
                    return;
                  }

                  if (widget.lm == null) {
                    controller.addLaneMeter(LaneMeter(
                      location: ToolkitLocation.values.firstWhere(
                          (element) => element.title == tecs[6].text),
                      make: tecs[0].text,
                      model: tecs[1].text,
                      serialno: tecs[2].text,
                      flowrange: tecs[3].text,
                      product: tecs[4].text,
                      checks: int.parse(tecs[5].text),
                    ));
                  } else {
                    controller.editLaneMeter(
                        widget.index,
                        LaneMeter(
                          location: ToolkitLocation.values.firstWhere(
                              (element) => element.title == tecs[6].text),
                          make: tecs[0].text,
                          model: tecs[1].text,
                          serialno: tecs[2].text,
                          flowrange: tecs[3].text,
                          product: tecs[4].text,
                          checks: int.parse(tecs[5].text),
                        ));
                  }

                  Ui.showInfo("Entry updated successfully");
                },
                text: "Save",
              )
            ],
          ),
        ),
      ),
    );
  }
}
