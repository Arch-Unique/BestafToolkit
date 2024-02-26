import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'package:bestaf_toolkit/src/features/modes/views/settings/history.dart';
import 'package:bestaf_toolkit/src/features/modes/views/settings/lane_meters_page.dart';
import 'package:bestaf_toolkit/src/features/modes/views/settings/ref.dart';
import 'package:bestaf_toolkit/src/global/ui/ui_barrel.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final screens = [LaneMeterspage(), RefInstrumentsPage(), HistoryPage()];
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Settings",
      child: ListView.separated(
          itemBuilder: (_, i) {
            return ListTile(
              title: AppText.medium(SettingsModes.values[i].title),
              subtitle: AppText.thin(SettingsModes.values[i].description,
                  color: AppColors.lightTextColor),
              onTap: () {
                if (i == 3) {
                } else {
                  Get.to(screens[i]);
                }
              },
              trailing: i == 3 ? changeUOM() : null,
            );
          },
          separatorBuilder: (_, i) {
            return AppDivider();
          },
          itemCount: SettingsModes.values.length),
    );
  }

  Widget changeUOM() {
    final controller = Get.find<ToolkitController>();
    return GestureDetector(
        onTap: () async {
          await controller.editUOM(!controller.getUOM());
          setState(() {});
          Ui.showInfo(
              "UOM successfully changed to ${controller.getUOM() ? "Litre" : "Mass"}");
        },
        child: AppText.bold(controller.getUOM() ? "Litre" : "Mass"));
  }
}
