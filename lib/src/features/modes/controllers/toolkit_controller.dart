import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bestaf_toolkit/src/global/services/barrel.dart';
import 'package:bestaf_toolkit/src/plugin/docxtopdf.dart';
import 'package:dio/dio.dart' as dio;
import 'package:docx_template/docx_template.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onedrive/flutter_onedrive.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global/ui/ui_barrel.dart';
import '../../../src_barrel.dart';
import '../../../utils/constants/prefs/prefs.dart';
import '../models/lanemeter.dart';
import '../models/toolkitsheet.dart';

class ToolkitController extends GetxController {
  final appService = Get.find<AppService>();

  static const String locationKey = "location";
  static const String productKey = "product";
  static const String laneKey = "lane";
  static const String checksKey = "checksfreq";
  static const String nextdateKey = "nextdate";
  static const String dateKey = "date";
  static const String startKey = "start";
  static const String endkey = "end";
  static const String meterKey = "imeter";
  static const String makeKey = "imake";
  static const String modelKey = "imodel";
  static const String serialnoKey = "iserialno";
  static const String flowrangeKey = "iflowrange";

  //prover meter
  static const String typeKey = "type";
  static const String proverModelKey = "model";
  static const String proverSerialKey = "serialno";
  static const String proverCapacityKey = "capacity";
  static const String proverMakeKey = "make";

  //checks
  static const String internalCheckKey = "internal";
  static const String externalCalibKey = "external";
  static const String calibByKey = "calibby";
  static const String calibSigKey = "calibsig";
  static const String checkByKey = "checkby";
  static const String checkSigKey = "checksig";

  static const int sigWidth = 240;
  static const int sigHeight = 42;
  // static const int entryStartRow = 15;
  // static const int entryEndRow = 26;

  static const String programmedQtyKey = "progqty";
  static const String meterVolKey = "metervol";
  static const String referenceVolKey = "refvol";
  static const String differenceVolKey = "difference";
  static const String flowRateKey = "flowrate";
  static const String adjustmentsKey = "adjustment";
  static const String oldKFactorKey = "oldkfactor";
  static const String newKFactorKey = "newkfactor";
  static const String remarksKey = "remarks";

  final _mode = ToolkitModes.internalCheck.obs;
  final _location = ToolkitLocation.tincan.obs;
  final _startTime = DateTime.now().obs;
  final _lane = LaneMeter().obs;
  final _ref = RefInstrument().obs;
  final _allMeters = <LaneMeter>[].obs;
  final _allRefs = <RefInstrument>[].obs;
  final _toolkitSheet = ToolkitSheet(
    laneMeter: LaneMeter(),
    entry: [],
    ref: RefInstrument(),
    location: ToolkitLocation.tincan,
    nextdate: "",
    date: DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now()),
  ).obs;

  // late Excel excel;
  late DocxTemplate doc;

  ToolkitLocation get location => _location.value;
  set location(ToolkitLocation value) {
    _location.value = value;
    _toolkitSheet.value.location = value;
  }

  set startTime(DateTime value) {
    _startTime.value = value;
  }

  ToolkitModes get mode => _mode.value;
  set mode(ToolkitModes value) {
    _mode.value = value;
    _startTime.value = DateTime.now();
    if (value == ToolkitModes.internalCheck) {
      _toolkitSheet.value.internalCheck = "+++";
      _toolkitSheet.value.externalCalib = "";
    } else {
      _toolkitSheet.value.internalCheck = "";
      _toolkitSheet.value.externalCalib = "+++";
    }
  }

  LaneMeter get lane => _lane.value;
  set lane(LaneMeter value) {
    _lane.value = value;
    _toolkitSheet.value.laneMeter = value;
    _toolkitSheet.value.location = value.location;
  }

  RefInstrument get ref => _ref.value;
  set ref(RefInstrument value) {
    _ref.value = value;
    _toolkitSheet.value.ref = value;
  }

  Uint8List? get checkSig => _toolkitSheet.value.checkSig;
  set checkSig(Uint8List? cs) {
    _toolkitSheet.value.checkSig = cs;
  }

  Uint8List? get calibSig => _toolkitSheet.value.calibSig;
  set calibSig(Uint8List? cs) {
    _toolkitSheet.value.calibSig = cs;
  }

  List<LaneMeter> get allMeters => _allMeters;
  Map<String, LaneMeter> get allMetersMap =>
      {for (var e in _allMeters) e.toString(): e};

  List<RefInstrument> get allRefs => _allRefs;
  Map<String, RefInstrument> get allRefsMap =>
      {for (var e in _allRefs) e.toString(): e};

  _initLanes() {
    _allMeters.value = getLaneMeters();
    _allRefs.value = getRefInstruments();
  }

  initWorkSheet() async {
    _initLanes();
    // try {
    //   ByteData data = await rootBundle.load('assets/json/toolkitsheet.xlsx');
    //   var bytes =
    //       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    //   excel = Excel.decodeBytes(bytes);
    // } on Exception catch (e) {
    //   // TODO
    //   print(e);
    // }
    await _initSheet();
  }

  _initSheet() async {
    ByteData data = await rootBundle.load('assets/json/toolkitsheet.docx');
    var bytes = data.buffer.asUint8List();
    doc = await DocxTemplate.fromBytes(bytes);
  }

  resetToolkitSheet() {
    _toolkitSheet.value = ToolkitSheet(
      laneMeter: LaneMeter(),
      entry: [],
      ref: RefInstrument(),
      location: ToolkitLocation.tincan,
      nextdate: "",
      date: DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now()),
    );
  }

  shareToolkitSheet(
      String checkBy, String calibBy, List<List<dynamic>> entries) async {
    _toolkitSheet.value.date +=
        " - ${DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now())}";
    _toolkitSheet.value.nextdate = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(Duration(days: _toolkitSheet.value.checks)));
    _toolkitSheet.value.calibBy = calibBy;
    _toolkitSheet.value.checkBy = checkBy;
    _toolkitSheet.value.entry = entries;

    final c = await _saveToolkitSheet();

    await _shareWorkSheet(c);
  }

  printToolkitSheet(
      String checkBy, String calibBy, List<List<dynamic>> entries) async {
    _toolkitSheet.value.date +=
        " - ${DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now())}";
    _toolkitSheet.value.nextdate = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(Duration(days: _toolkitSheet.value.checks)));
    _toolkitSheet.value.calibBy = calibBy;
    _toolkitSheet.value.checkBy = checkBy;
    _toolkitSheet.value.entry = entries;

    final c = await _saveToolkitSheet();
    await _printWorkSheet(c);
  }

  saveToolkitSheet(
      String checkBy, String calibBy, List<List<dynamic>> entries) async {
    _toolkitSheet.value.date +=
        " - ${DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now())}";
    _toolkitSheet.value.nextdate = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(Duration(days: _toolkitSheet.value.checks)));
    _toolkitSheet.value.calibBy = calibBy;
    _toolkitSheet.value.checkBy = checkBy;
    _toolkitSheet.value.entry = entries;

    final c = await _saveToolkitSheet();
    await _saveFinal(c);
  }

  _saveITLater(List<List<dynamic>> entries) async {
    _toolkitSheet.value.entry = entries;
    // _toolkitSheet.value.date =
    //     DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now());
    String ts = _toolkitSheet.value.toString();

    await appService.prefService.save(MyPrefs.mpIncompleteIT, ts);
  }

  _saveETLater(List<List<dynamic>> entries) async {
    _toolkitSheet.value.entry = entries;
    // _toolkitSheet.value.date = DateFormat("dd/MM/yyyy").format(DateTime.now());
    String ts = _toolkitSheet.value.toString();

    await appService.prefService.save(MyPrefs.mpIncompleteET, ts);
  }

  saveToolkitLater(List<List<dynamic>> entries) async {
    if (mode == ToolkitModes.internalCheck) {
      await _saveITLater(entries);
    } else {
      await _saveETLater(entries);
    }
  }

  ToolkitSheet? getToolkitLater() {
    String? ts;

    if (mode == ToolkitModes.internalCheck) {
      ts = appService.prefService.get(MyPrefs.mpIncompleteIT);
    } else {
      ts = appService.prefService.get(MyPrefs.mpIncompleteET);
    }

    return ts == null ? null : ToolkitSheet.fromString(ts);
  }

  List<List<dynamic>> useOldToolkit() {
    _toolkitSheet.value = getToolkitLater()!;
    _startTime.value =
        DateFormat("dd/MM/yyyy hh:mm a").parse(_toolkitSheet.value.date);
    _lane.value = _toolkitSheet.value.laneMeter;
    _ref.value = _toolkitSheet.value.ref;
    _location.value = _toolkitSheet.value.location;
    return _toolkitSheet.value.entry;
  }

  clearOldToolkit() async {
    if (mode == ToolkitModes.internalCheck) {
      await appService.prefService.save(MyPrefs.mpIncompleteIT, null);
    } else {
      await appService.prefService.save(MyPrefs.mpIncompleteET, null);
    }
  }

  Future<File> _saveToolkitSheet() async {
    Content c = Content();

    c
      ..add(TextContent(locationKey, _toolkitSheet.value.location.title))
      ..add(TextContent(
          dateKey, DateFormat("dd/MM/yyyy").format(_startTime.value)))
      ..add(
          TextContent(startKey, DateFormat("hh:mm a").format(_startTime.value)))
      ..add(TextContent(
          endkey, DateFormat(_endDateFormat()).format(DateTime.now())))
      ..add(TextContent(typeKey, _toolkitSheet.value.ref.type))
      ..add(TextContent(proverModelKey, _toolkitSheet.value.ref.model))
      ..add(TextContent(proverSerialKey, _toolkitSheet.value.ref.serialno))
      ..add(TextContent(proverCapacityKey, _toolkitSheet.value.ref.capacity))
      ..add(TextContent(proverMakeKey, _toolkitSheet.value.ref.make))
      ..add(TextContent(makeKey, _toolkitSheet.value.laneMeter.make))
      ..add(TextContent(modelKey, _toolkitSheet.value.laneMeter.model))
      ..add(TextContent(serialnoKey, _toolkitSheet.value.laneMeter.serialno))
      ..add(TextContent(flowrangeKey, _toolkitSheet.value.laneMeter.flowrange))
      ..add(TextContent(meterKey, _toolkitSheet.value.laneMeter.lane))
      ..add(TextContent(productKey, _toolkitSheet.value.laneMeter.product))
      ..add(TextContent(laneKey, _toolkitSheet.value.laneMeter.lane))
      ..add(TextContent(checksKey, _toolkitSheet.value.checks))
      ..add(TextContent(internalCheckKey, _toolkitSheet.value.internalCheck))
      ..add(TextContent(externalCalibKey, _toolkitSheet.value.externalCalib))
      ..add(TextContent(nextdateKey, _toolkitSheet.value.nextdate))
      ..add(TextContent(checkByKey, _toolkitSheet.value.checkBy))
      ..add(TextContent(calibByKey, _toolkitSheet.value.calibBy))
      ..add(ImageContent(checkSigKey, _toolkitSheet.value.checkSig))
      ..add(ImageContent(calibSigKey, _toolkitSheet.value.calibSig));

    // print(_toolkitSheet.value.entry);

    for (var i = 0; i < _toolkitSheet.value.entry.length; i++) {
      c.add(TableContent("l${i + 1}", [
        RowContent()
          ..add(TextContent("no", "${i + 1}"))
          ..add(TextContent(programmedQtyKey, _toolkitSheet.value.entry[i][0]))
          ..add(TextContent(meterVolKey, _toolkitSheet.value.entry[i][1]))
          ..add(TextContent(referenceVolKey, _toolkitSheet.value.entry[i][2]))
          ..add(TextContent(differenceVolKey, _toolkitSheet.value.entry[i][3]))
          ..add(TextContent(flowRateKey, _toolkitSheet.value.entry[i][4]))
          ..add(TextContent(adjustmentsKey, _toolkitSheet.value.entry[i][5]))
          ..add(TextContent(oldKFactorKey, _toolkitSheet.value.entry[i][6]))
          ..add(TextContent(newKFactorKey, _toolkitSheet.value.entry[i][7]))
          ..add(TextContent(remarksKey, _toolkitSheet.value.entry[i][8]))
      ]));
    }

    for (var i = _toolkitSheet.value.entry.length; i < 11; i++) {
      c.add(TableContent("l${i + 1}", [
        RowContent()
          ..add(TextContent("no", "${i + 1}"))
          ..add(TextContent(programmedQtyKey, ""))
          ..add(TextContent(meterVolKey, ""))
          ..add(TextContent(referenceVolKey, ""))
          ..add(TextContent(differenceVolKey, ""))
          ..add(TextContent(flowRateKey, ""))
          ..add(TextContent(adjustmentsKey, ""))
          ..add(TextContent(oldKFactorKey, ""))
          ..add(TextContent(newKFactorKey, ""))
          ..add(TextContent(remarksKey, ""))
      ]));
    }

    final f = await _saveDocx(c);

    return f;
  }

  Future<File> _saveDocx(Content c) async {
    await _initSheet();
    var fileBytes = await doc.generate(c);
    var directory = await getTemporaryDirectory();
    var nameOfFile =
        "${_toolkitSheet.value.laneMeter.toString()}-${mode.title}-${DateFormat("dd-MM-yyyy hh-mm-ss").format(DateTime.now())}";

    final f = File('${directory.path}/$nameOfFile.docx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    return f;
  }

  String _endDateFormat() {
    final nw = DateFormat("dd/MM/yyyy").format(DateTime.now());
    final ow = DateFormat("dd/MM/yyyy").format(_startTime.value);
    return nw == ow ? "hh:mm a" : "dd/MM/yyyy hh:mm a";
  }

  Future<String> _saveFinal(File f) async {
    final add = await getApplicationDocumentsDirectory();
    final directory = Directory("${add.path}/files");
    // print(directory);
    var nameOfFile =
        "${_toolkitSheet.value.laneMeter.toString()}-${mode.title}-${DateFormat("MMM-yyyy").format(DateTime.now())}";

    // final cv = await _fetchSomeData(f);

    String inputFilePath = f.path;
    String outputFilePath = "${directory.path}/$nameOfFile.pdf";

    try {
      final mc = await _fetchSomeData(f);
      File(outputFilePath)
        ..createSync()
        ..writeAsBytesSync(mc);
      // await BestafToolkitPlugin.convertDocxToPdf(inputFilePath, outputFilePath);
    } catch (e) {
      // TODO
      print(e);
    }
    return outputFilePath;

    // File('${directory.path}/$nameOfFile.pdf')
    //   ..createSync(recursive: true)
    //   ..writeAsBytesSync(cv);
  }

  _shareWorkSheet(File f) async {
    // await launchUrl(Uri.parse(
    //     "https://mrsholdings.sharepoint.com/BESTAF_TRADING/LM%20Department/Forms/AllItems.aspx?e=5%3A3765496e7be942aea70effbcdb0e8ee9&at=9&CT=1676995817408&OR=OWA%2DNT&CID=547f0f0e%2Dd45f%2Ddff7%2D8428%2D5d41498e8df2&RootFolder=%2FBESTAF%5FTRADING%2FLM%20Department%2F09%2E%20Quality%20Management%20System%2FMeter%20calibration&FolderCTID=0x012000AB36752DF45D784FA7F2700E2D204983"));
    final xf = XFile(f.path);

    await Share.shareXFiles(
      [xf],
    );
  }

  FutureOr<Uint8List> _fetchSomeData(File f) async {
    try {
      const String apiKey =
          '0c5474ba-f52b-4506-99ba-30d4ce683078'; // Replace with your API key
      const String url = 'https://api.cloudmersive.com/convert/docx/to/pdf';

      final formData = dio.FormData.fromMap({
        'inputFile': await dio.MultipartFile.fromFile(f.path),
      });

      final response = await dio.Dio().post(
        url,
        data: formData,
        options: dio.Options(headers: {
          'Content-Type': 'multipart/form-data',
          'Apikey': apiKey,
        }, responseType: dio.ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        Ui.showError("File not saved, please try again later");
        print('Conversion failed with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return f.readAsBytes();
  }

  _printWorkSheet(File f) async {
    final fp = await _saveFinal(f);
    final fpp = await FileSaver.instance.saveFile(
        name: fp.split("/").last, file: File(fp), mimeType: MimeType.pdf);
    // final onedrive = await OneDrive(
    //     clientID: "59c33595-a567-4dc6-b84c-1283f5374a2a",
    //     redirectURL: "bestaftoolkit://mrsholdings.com");
    // linkStream.listen((event) async {
    //   Get.back();
    // });
    // await onedrive.connect(Get.context!);
    // await onedrive.push(f.readAsBytesSync(), "/AppTest");
    Ui.showInfo("Saved to $fpp", duration: 5);

    await launchUrl(Uri.parse(
        "https://mrsholdings.sharepoint.com/BESTAF_TRADING/LM%20Department/Forms/AllItems.aspx?e=5%3A3765496e7be942aea70effbcdb0e8ee9&at=9&CT=1676995817408&OR=OWA%2DNT&CID=547f0f0e%2Dd45f%2Ddff7%2D8428%2D5d41498e8df2&RootFolder=%2FBESTAF%5FTRADING%2FLM%20Department%2F09%2E%20Quality%20Management%20System%2FMeter%20calibration&FolderCTID=0x012000AB36752DF45D784FA7F2700E2D204983"));

    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async => _fetchSomeData(f),
    // );
  }

  List<LaneMeter> getLaneMeters() {
    List<dynamic>? allLaneMeters =
        appService.prefService.get(MyPrefs.mpLanemeters);
    return allLaneMeters!.map((e) => LaneMeter.fromString(e)).toList();
  }

  addLaneMeter(LaneMeter a) async {
    List<dynamic>? allLaneMeters =
        appService.prefService.get(MyPrefs.mpLanemeters) ?? [];

    allLaneMeters.add(a.toSaveAsString());
    _allMeters.value =
        allLaneMeters.map((e) => LaneMeter.fromString(e)).toList();

    await appService.prefService.save(MyPrefs.mpLanemeters, allLaneMeters);
  }

  removeLaneMeter(int a) async {
    List<dynamic>? allLaneMeters =
        appService.prefService.get(MyPrefs.mpLanemeters) ?? [];

    allLaneMeters.removeAt(a);
    _allMeters.value =
        allLaneMeters.map((e) => LaneMeter.fromString(e)).toList();

    await appService.prefService.save(MyPrefs.mpLanemeters, allLaneMeters);
  }

  editLaneMeter(int b, LaneMeter a) async {
    List<dynamic>? allLaneMeters =
        appService.prefService.get(MyPrefs.mpLanemeters) ?? [];

    allLaneMeters[b] = a.toSaveAsString();
    _allMeters.value =
        allLaneMeters.map((e) => LaneMeter.fromString(e)).toList();

    await appService.prefService.save(MyPrefs.mpLanemeters, allLaneMeters);
  }

  //REF INSTRUMENTS
  List<RefInstrument> getRefInstruments() {
    List<dynamic>? allRefs =
        appService.prefService.get(MyPrefs.mpRefInstruments);
    return allRefs!.map((e) => RefInstrument.fromString(e)).toList();
  }

  addRefInstrument(RefInstrument a) async {
    List<dynamic>? allRefs =
        appService.prefService.get(MyPrefs.mpRefInstruments) ?? [];

    allRefs.add(a.toSaveAsString());
    _allRefs.value = allRefs.map((e) => RefInstrument.fromString(e)).toList();

    await appService.prefService.save(MyPrefs.mpRefInstruments, allRefs);
  }

  removeRefInstrument(int a) async {
    List<dynamic>? allRefs =
        appService.prefService.get(MyPrefs.mpRefInstruments) ?? [];

    allRefs.removeAt(a);
    _allRefs.value = allRefs.map((e) => RefInstrument.fromString(e)).toList();

    await appService.prefService.save(MyPrefs.mpRefInstruments, allRefs);
  }

  editRefInstrument(int b, RefInstrument a) async {
    List<dynamic>? allRefs =
        appService.prefService.get(MyPrefs.mpRefInstruments) ?? [];

    allRefs[b] = a.toSaveAsString();
    _allRefs.value = allRefs.map((e) => RefInstrument.fromString(e)).toList();

    await appService.prefService.save(MyPrefs.mpRefInstruments, allRefs);
  }

  static double calcKFactor(double batchVol, double oldKFactor, double ddiff,
      double proverVol, double meterVol, bool isApapa) {
    final diff = proverVol - meterVol;
    final desiredDiff = batchVol + ddiff;
    double nkfactor = oldKFactor;
    if (!isApapa) {
      if (ddiff - diff > 0) {
        nkfactor = (meterVol * oldKFactor) / (desiredDiff);
      } else {
        nkfactor = (desiredDiff * oldKFactor) / (meterVol);
      }
    } else {
      if (ddiff - diff > 0) {
        nkfactor = (desiredDiff * oldKFactor) / (meterVol);
      } else {
        nkfactor = (meterVol * oldKFactor) / (desiredDiff);
      }
    }

    return nkfactor;
  }

  static double calcKFactorAtZero(double batchVol, double oldKFactor,
      double ddiff, double proverVol, double meterVol, bool isApapa) {
    final nkf =
        calcKFactor(batchVol, oldKFactor, ddiff, proverVol, meterVol, isApapa);
    final diff = proverVol - meterVol;

    return ((oldKFactor * ddiff) - (nkf * diff)) / (ddiff - diff);
  }
}
