import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../src_barrel.dart';
import '../services/dio_api_service.dart';

class ConnectionController extends GetxController {
  RxBool isConnected = false.obs;
  late Stream<ConnectivityResult> _connectivityStream;
  final controller = Get.find<DioApiService>();

  init() {
    isConnected.value = true;
    _connectivityStream = Connectivity().onConnectivityChanged;
    _connectivityStream.listen((result) {
      isConnected.value = result != ConnectivityResult.none;
      if (!isConnected.value) {
        controller.currentErrorType.value = ErrorTypes.noInternet;
      }
    });
  }
}
