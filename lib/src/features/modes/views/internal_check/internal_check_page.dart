import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:flutter/material.dart';

class InternalCheckPage extends StatefulWidget {
  const InternalCheckPage({super.key});

  @override
  State<InternalCheckPage> createState() => _InternalCheckPageState();
}

class _InternalCheckPageState extends State<InternalCheckPage> {
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Internal Check",
      child: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
