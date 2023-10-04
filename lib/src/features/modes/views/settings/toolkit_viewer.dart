import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ToolkitSheetViewerPage extends StatelessWidget {
  const ToolkitSheetViewerPage(this.path, {super.key});
  final String path;

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Toolkit Sheet Viewer",
      child: PDFView(
        filePath: path,
        autoSpacing: false,
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      ),
    );
  }
}
