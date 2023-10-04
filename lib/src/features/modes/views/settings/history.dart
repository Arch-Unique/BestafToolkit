import 'dart:io';

import 'package:bestaf_toolkit/src/features/modes/views/settings/toolkit_viewer.dart';
import 'package:bestaf_toolkit/src/global/ui/widgets/others/containers.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../../../global/ui/widgets/dialog/dialog.dart';
import '../../../../src_barrel.dart';
import '../util_widgets.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<File> files = [];
  bool isLoading = true;
  bool selectionMode = false;
  bool isSelectAll = false;
  List<int> selectedFiles = [];

  @override
  void initState() {
    checkFiles();
    super.initState();
  }

  Future checkFiles() async {
    files = [];
    final add = await getApplicationDocumentsDirectory();
    final directory = Directory("${add.path}/files");

    // Check if the directory exists.
    if (directory.existsSync()) {
      // List the files in the directory.
      final filess = directory.listSync();

      // Loop through each file in the directory.
      for (var file in filess) {
        // Check if the item is a File (not a Directory).
        if (file is File) {
          // print(file.path);
          files.add(file);
        }
      }
      files
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      setState(() {
        isLoading = false;
      });
    } else {
      await directory.create();
      await checkFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(
        title: "History",
        trailing: selectionMode
            ? [
                if (selectedFiles.isNotEmpty)
                  IconButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => AppDialog.normal("Delete",
                                    "Are you sure you want to delete these files?",
                                    onPressedA: () async {
                                  await Future.wait(selectedFiles
                                      .map((e) => files[e].delete()));
                                  setState(() {
                                    selectedFiles.clear();
                                    selectionMode = false;
                                  });
                                  Get.back();
                                  await checkFiles();
                                }, onPressedB: () {
                                  Get.back();
                                }));
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.red,
                      )),
                if (selectedFiles.isNotEmpty)
                  IconButton(
                      onPressed: () async {
                        await Get.showOverlay(
                            asyncFunction: exportToZip,
                            loadingWidget: LoadingOverlay());
                      },
                      icon: const Icon(
                        Icons.download,
                        color: AppColors.black,
                      )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (isSelectAll) {
                          selectedFiles.clear();
                          isSelectAll = false;
                        } else {
                          selectedFiles =
                              List.generate(files.length, (index) => index);
                          isSelectAll = true;
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.select_all_rounded,
                      color: AppColors.black,
                    ))
              ]
            : null,
      ),
      body: isLoading
          ? CircularProgress(54)
          : files.isEmpty
              ? Center(child: AppText.bold("Empty"))
              : RefreshIndicator(
                  onRefresh: checkFiles,
                  child: ListView.separated(
                      itemBuilder: (_, i) {
                        return ListTile(
                          title: AppText.medium(files[i].path.split("/").last,
                              color: AppColors.lightTextColor),
                          subtitle: AppText.thin(
                              DateFormat("dd/MM/yyyy hh:mm")
                                  .format(files[i].lastModifiedSync()),
                              color: AppColors.lightTextColor),
                          trailing: selectionMode
                              ? Checkbox(
                                  value: selectedFiles.contains(i),
                                  onChanged: (b) {
                                    setState(() {
                                      (b ?? false)
                                          ? selectedFiles.add(i)
                                          : selectedFiles.remove(i);
                                    });
                                  })
                              : IconButton(
                                  onPressed: () async {
                                    await Share.shareXFiles(
                                      [XFile(files[i].path)],
                                    );
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color: AppColors.black,
                                  ),
                                ),
                          onTap: () async {
                            Get.to(ToolkitSheetViewerPage(files[i].path));
                          },
                          onLongPress: () {
                            setState(() {
                              selectionMode = !selectionMode;
                              selectedFiles.add(i);
                            });
                          },
                        );
                      },
                      separatorBuilder: (_, i) {
                        return AppDivider();
                      },
                      itemCount: files.length),
                ),
    );
  }

  Future<void> exportToZip() async {
    final add = await getApplicationDocumentsDirectory();
    final directory = Directory("${add.path}/files");
    final zipFile =
        File("${add.path}/bestaf-${DateTime.now().millisecondsSinceEpoch}.zip");
    try {
      await ZipFile.createFromFiles(
          sourceDir: directory,
          files: selectedFiles.map((e) => files[e]).toList(),
          zipFile: zipFile);

      print("zipped successfully");

      await FileSaver.instance.saveFile(
          name: zipFile.path.split("/").last,
          file: zipFile,
          mimeType: MimeType.zip);

      print("saved successfully");

      Ui.showInfo("Saved to ${zipFile.path}");
    } catch (e) {
      print(e);
    }
  }
}
