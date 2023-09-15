import 'package:get/get.dart';

import '../../src_barrel.dart';

abstract class ErrorService extends GetxService {
  Rx<ErrorTypes> currentErrorType = ErrorTypes.noInternet.obs;

  setError(ErrorTypes et) {
    currentErrorType.value = et;
  }
}
