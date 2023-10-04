import 'package:flutter/services.dart';

class BestafToolkitPlugin {
  static const _channel = MethodChannel('bestaf_toolkit');

  static Future<String?> convertDocxToPdf(
      String inputFilePath, String outputFilePath) async {
    // inputFilePath = inputFilePath.replaceFirst("/", "");
    print(Uri.file(inputFilePath).toString());
    try {
      final String? result = await _channel.invokeMethod(
        "convertDocxToPdf",
        {"inputFilePath": inputFilePath, "outputFilePath": outputFilePath},
      );
      return result;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
