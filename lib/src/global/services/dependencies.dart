import 'package:get/get.dart';

import '../controller/connection_controller.dart';
import 'package:bestaf_toolkit/src/features/modes/controllers/toolkit_controller.dart';
import 'barrel.dart';

class AppDependency {
  static init() async {
    Get.put(MyPrefService());
    Get.put(DioApiService());
    await Get.putAsync(() async {
      final connectTivity = ConnectionController();
      await connectTivity.init();
      return connectTivity;
    });
    await Get.putAsync(() async {
      final appService = AppService();
      await appService.initUserConfig();
      return appService;
    });

    //repos
    // Get.put(AuthRepo());
    // Get.put(DashboardRepo());
    // Get.put(ProfileRepo());
    // Get.put(FacilityRepo());

    //controllers
    await Get.putAsync(() async {
      final toolkitController = ToolkitController();
      await toolkitController.initWorkSheet();
      return toolkitController;
    });
    // Get.put(DashboardController());
    // Get.put(FacilityController());
  }
}
