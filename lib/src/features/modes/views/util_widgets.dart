import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../../../src_barrel.dart';

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
    widget.tecs[3].addListener(() {
      if (widget.tecs[1].text.isNotEmpty && widget.tecs[2].text.isNotEmpty) {
        setState(() {
          final diff = double.parse(widget.tecs[1].value.text) -
              double.parse(widget.tecs[2].value.text);

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
              index == 5 ? "Y/N" : "",
              widget.tecs[index],
              varl: FPL.text,
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
            readOnly: index == 0 || index == 3,
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
    "Programmed Qty",
    "Meter Vol",
    "Ref Vol",
    "Difference",
    "Flowrate",
    "Adjustments",
    "Prev K-Factor",
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
              width: (Ui.width(context) - 48) * 0.1667,
              height: 48,
              child: AppText.bold(headerTexts[index], color: AppColors.black),
            ));
      }),
    );
  }
}
