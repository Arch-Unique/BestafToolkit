import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/features/modes/models/lanemeter.dart';
import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChangeServer extends StatefulWidget {
  const ChangeServer({super.key});

  @override
  State<ChangeServer> createState() => _ChangeServerState();
}

class _ChangeServerState extends State<ChangeServer> {
  final controller = Get.find<ToolkitController>();
  final tec = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Change Server URL",
      child: Ui.padding(
        child: Column(
          children: [
            CustomTextField(
              "192.168.0.136",
              tec,
            ),
            Spacer(),
            AppButton(
              onPressed: () async{
                if (tec.text.isEmpty) {
                  Ui.showError("Fields cannot be empty");
                  return;
                }

                await controller.appService.changeServerAddress(url: tec.text);

                Ui.showInfo("Server URL updated successfully");
              },
              text: "Save",
            )
          ],
        ),
      ),
    );
  }
}
