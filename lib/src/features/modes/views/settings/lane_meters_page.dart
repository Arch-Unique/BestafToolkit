import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/features/modes/views/settings/edit_lanemeter_page.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/dialog/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../../../src_barrel.dart';

class LaneMeterspage extends StatelessWidget {
  LaneMeterspage({super.key});
  final controller = Get.find<ToolkitController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Lane Meters", hasBack: true, trailing: [
        IconButton(
            onPressed: () {
              Get.to(EditLaneMeter());
            },
            icon: Icon(
              Icons.add,
              color: AppColors.primaryColor,
            ))
      ]),
      body: ListView.separated(
          itemBuilder: (_, i) {
            return ListTile(
              title: AppText.medium(controller.allMeters[i].toString()),
              onTap: () {
                Get.to(EditLaneMeter(
                  index: i,
                  lm: controller.allMeters[i],
                ));
              },
              trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AppDialog.normal("CONFIRMATION",
                              "Are you sure you want to delete ${controller.allMeters[i].toString()}",
                              onPressedA: () async {
                            //delete
                            await controller.appService.removeLaneMeter(i);
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
          itemCount: controller.allMeters.length),
    );
  }
}
