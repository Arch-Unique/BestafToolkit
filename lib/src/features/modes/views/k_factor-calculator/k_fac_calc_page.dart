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
  List<TextEditingController> tecs =
      List.generate(10, (index) => TextEditingController());
  double nkfactor = 0;
  double diff = 0;

  @override
  void initState() {
    // TODO: implement initState
    controller.mode = ToolkitModes.internalCheck;
    tecs[4].addListener(() {
      if (tecs[4].text.isNotEmpty && tecs[5].text.isNotEmpty) {
        setState(() {
          diff = double.parse(tecs[4].text) - double.parse(tecs[5].text);

          tecs[6].text = diff.toString();
        });
      }
    });
    tecs[5].addListener(() {
      if (tecs[4].text.isNotEmpty && tecs[5].text.isNotEmpty) {
        setState(() {
          diff = double.parse(tecs[4].text) - double.parse(tecs[5].text);
          tecs[6].text = diff.toString();
        });
      }
    });
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
                tecs[0],
                "Location",
                onChanged: (p0) {
                  controller.location = ToolkitLocation.values
                      .firstWhere((element) => element.title == p0);
                },
              ),
              CustomTextField(
                "Batch Volume",
                tecs[1],
                varl: FPL.number,
              ),
              CustomTextField(
                "Old K Factor",
                tecs[2],
                varl: FPL.number,
                shdValidate: false,
              ),
              CustomTextField(
                "Desired Diff",
                tecs[3],
                varl: FPL.number,
                shdValidate: false,
              ),
              AppDivider(),
              CustomTextField(
                "Prover Volume",
                tecs[4],
                varl: FPL.number,
                shdValidate: false,
              ),
              CustomTextField(
                "Meter Volume",
                tecs[5],
                varl: FPL.number,
                shdValidate: false,
              ),
              CustomTextField(
                "Difference",
                tecs[6],
                varl: FPL.number,
                readOnly: true,
                shdValidate: false,
              ),
              AppDivider(),
              AppText.medium(
                  "K Factor at $diff - ${tecs[2].value.text}\nK Factor at ${tecs[3].value.text} - $nkfactor"),
              AppDivider(),
              AppButton(
                onPressed: () {
                  if (tecs[1].value.text.isEmpty ||
                      tecs[2].value.text.isEmpty ||
                      tecs[3].value.text.isEmpty ||
                      tecs[4].value.text.isEmpty ||
                      tecs[5].value.text.isEmpty) {
                    Ui.showError("Please fill all the fields");
                    return;
                  }
                  setState(() {
                    nkfactor = ToolkitController.calcKFactor(
                        double.parse(tecs[1].value.text),
                        double.parse(tecs[2].value.text),
                        double.parse(tecs[3].value.text),
                        double.parse(tecs[4].value.text),
                        double.parse(tecs[5].value.text),
                        tecs[0].value.text == "APAPA");
                  });
                },
                text: "Calculate",
              )
            ],
          ),
        ),
      ),
    );
  }
}
