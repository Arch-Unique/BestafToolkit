import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/features/modes/views/settings/edit_ref.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/dialog/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../../../src_barrel.dart';

class RefInstrumentsPage extends StatelessWidget {
  RefInstrumentsPage({super.key});
  final controller = Get.find<ToolkitController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Lane Meters", hasBack: true, trailing: [
        IconButton(
            onPressed: () {
              Get.to(EditRefInstrument());
            },
            icon: Icon(
              Icons.add,
              color: AppColors.primaryColor,
            ))
      ]),
      body: ListView.separated(
          itemBuilder: (_, i) {
            return ListTile(
              title: AppText.medium(controller.allRefs[i].toString()),
              onTap: () {
                Get.to(EditRefInstrument(
                  index: i,
                  lm: controller.allRefs[i],
                ));
              },
              trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AppDialog.normal("CONFIRMATION",
                              "Are you sure you want to delete ${controller.allRefs[i].toString()}",
                              onPressedA: () async {
                            //delete
                            await controller.appService.removeRefInstrument(i);
                          }, onPressedB: () {
                            Get.back();
                          });
                        });
                  },
                  icon: Icon(Icons.delete)),
            );
          },
          separatorBuilder: (_, i) {
            return AppDivider();
          },
          itemCount: controller.allRefs.length),
    );
  }
}
