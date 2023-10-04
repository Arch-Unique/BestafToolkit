package com.mrsholdings.bestaf_toolkit

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.spire.doc.Document
import com.spire.doc.FileFormat


class MainActivity: FlutterActivity() {

    private val CHANNEL = "bestaf_toolkit"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      // This method is invoked on the main thread.
      if (call.method == "convertDocxToPdf") {
            val inputFilePath = call.argument<String>("inputFilePath")
            val outputFilePath = call.argument<String>("outputFilePath")
            val pdfFilePath = convertDocxToPdf(inputFilePath!!, outputFilePath!!)
            result.success(pdfFilePath)
        } else {
            result.notImplemented()
        }
    }
  }

  private fun convertDocxToPdf(inputFilePath: String, outputFilePath: String): String {
        val doc = Document();
        doc.loadFromFile(inputFilePath);
        doc.saveToFile(outputFilePath,FileFormat.PDF)
        return outputFilePath
    }


}
