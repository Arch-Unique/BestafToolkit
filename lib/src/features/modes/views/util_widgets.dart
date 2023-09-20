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
    widget.tecs[5].text = "N";
    widget.tecs[0].text = "5000";
    widget.tecs[1].addListener(() {
      if (widget.tecs[1].text.isNotEmpty && widget.tecs[2].text.isNotEmpty) {
        setState(() {
          final diff = double.parse(widget.tecs[2].value.text) -
              double.parse(widget.tecs[1].value.text);

          widget.tecs[3].text = diff.toString();
        });
      }
    });
    widget.tecs[2].addListener(() {
      if (widget.tecs[1].text.isNotEmpty && widget.tecs[2].text.isNotEmpty) {
        setState(() {
          final diff = double.parse(widget.tecs[2].value.text) -
              double.parse(widget.tecs[1].value.text);

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
        if (index == 5 || index == 7) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
            child: CustomTextField(
              "",
              widget.tecs[index],
              varl: FPL.text,
              readOnly: true,
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
    "Prog Qty",
    "Meter Vol",
    "Ref Vol",
    "Difference",
    "Flowrate",
    "Adjustment",
    "K-Factor",
    "Remarks"
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(8, (index) {
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
