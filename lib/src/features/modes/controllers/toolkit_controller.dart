import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bestaf_toolkit/src/global/services/barrel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:docx_template/docx_template.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../../../src_barrel.dart';
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
    date: "",
  ).obs;

  // late Excel excel;
  late DocxTemplate doc;

  ToolkitLocation get location => _location.value;
  set location(ToolkitLocation value) {
    _location.value = value;
    _toolkitSheet.value.location = value;
  }

  ToolkitModes get mode => _mode.value;
  set mode(ToolkitModes value) {
    _mode.value = value;
    if (value == ToolkitModes.internalCheck) {
      _toolkitSheet.value.internalCheck = "✓";
      _toolkitSheet.value.externalCalib = "";
    } else {
      _toolkitSheet.value.internalCheck = "";
      _toolkitSheet.value.externalCalib = "✓";
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
    _allMeters.value = appService.getLaneMeters();
    _allRefs.value = appService.getRefInstruments();
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
    ByteData data = await rootBundle.load('assets/json/toolkitsheet.docx');
    var bytes = data.buffer.asUint8List();
    doc = await DocxTemplate.fromBytes(bytes);
  }

  shareToolkitSheet(
      String checkBy, String calibBy, List<List<dynamic>> entries) async {
    _toolkitSheet.value.date = DateFormat("dd/MM/yyyy").format(DateTime.now());
    _toolkitSheet.value.nextdate = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(Duration(days: _toolkitSheet.value.checks)));
    _toolkitSheet.value.calibBy = calibBy;
    _toolkitSheet.value.checkBy = checkBy;
    _toolkitSheet.value.entry = entries;

    final c = await _saveToolkitSheet();
    _shareWorkSheet(c);
  }

  printToolkitSheet(
      String checkBy, String calibBy, List<List<dynamic>> entries) async {
    _toolkitSheet.value.date = DateFormat("dd/MM/yyyy").format(DateTime.now());
    _toolkitSheet.value.nextdate = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(Duration(days: _toolkitSheet.value.checks)));
    _toolkitSheet.value.calibBy = calibBy;
    _toolkitSheet.value.checkBy = checkBy;
    _toolkitSheet.value.entry = entries;

    final c = await _saveToolkitSheet();
    _printWorkSheet(c);
  }

  Future<File> _saveToolkitSheet() async {
    Content c = Content();

    c
      ..add(TextContent(locationKey, _toolkitSheet.value.location.title))
      ..add(
          TextContent(dateKey, DateFormat("dd/MM/yyyy").format(DateTime.now())))
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

    // excel.updateCell("Sheet1", CellIndex.indexByString(locationKey),
    //     _toolkitSheet.value.location.title);
    // excel.updateCell("Sheet1", CellIndex.indexByString(dateKey),
    //     DateFormat("dd/MM/yyyy").format(DateTime.now()));
    // excel.updateCell("Sheet1", CellIndex.indexByString(typeKey),
    //     _toolkitSheet.value.location.proverType);
    // excel.updateCell("Sheet1", CellIndex.indexByString(proverModelKey),
    //     _toolkitSheet.value.location.proverModel);
    // excel.updateCell("Sheet1", CellIndex.indexByString(proverSerialKey),
    //     _toolkitSheet.value.location.proverSerialno);
    // excel.updateCell("Sheet1", CellIndex.indexByString(proverCapacityKey),
    //     _toolkitSheet.value.location.proverCapacity);
    // excel.updateCell("Sheet1", CellIndex.indexByString(proverMakeKey),
    //     _toolkitSheet.value.location.proverMake);
    // excel.updateCell("Sheet1", CellIndex.indexByString(makeKey),
    //     _toolkitSheet.value.laneMeter.make);
    // excel.updateCell("Sheet1", CellIndex.indexByString(modelKey),
    // _toolkitSheet.value.laneMeter.model);
    // excel.updateCell("Sheet1", CellIndex.indexByString(serialnoKey),
    //     _toolkitSheet.value.laneMeter.serialno);
    // excel.updateCell("Sheet1", CellIndex.indexByString(flowrangeKey),
    //     _toolkitSheet.value.laneMeter.flowrange);
    // excel.updateCell("Sheet1", CellIndex.indexByString(meterKey),
    //     _toolkitSheet.value.laneMeter.lane);
    // excel.updateCell("Sheet1", CellIndex.indexByString(productKey),
    //     _toolkitSheet.value.laneMeter.product);
    // excel.updateCell("Sheet1", CellIndex.indexByString(laneKey),
    // _toolkitSheet.value.laneMeter.lane);
    // excel.updateCell("Sheet1", CellIndex.indexByString(checksKey),
    //     _toolkitSheet.value.checks);
    // excel.updateCell("Sheet1", CellIndex.indexByString(internalCheckKey),
    //     _toolkitSheet.value.internalCheck);
    // excel.updateCell("Sheet1", CellIndex.indexByString(externalCalibKey),
    //     _toolkitSheet.value.externalCalib);
    // excel.updateCell("Sheet1", CellIndex.indexByString(nextdateKey),
    //     _toolkitSheet.value.nextdate);
    // excel.updateCell("Sheet1", CellIndex.indexByString(checkByKey),
    //     _toolkitSheet.value.checkBy);
    // excel.updateCell("Sheet1", CellIndex.indexByString(calibByKey),
    //     _toolkitSheet.value.calibBy);
    // excel.updateCell("Sheet1", CellIndex.indexByString(checkSigKey),
    //     _toolkitSheet.value.checkSig);
    // excel.updateCell("Sheet1", CellIndex.indexByString(calibSigKey),
    //     _toolkitSheet.value.calibSig);

    print(_toolkitSheet.value.entry.length);

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

    // for (var i = 0; i < _toolkitSheet.value.entry.length; i++) {
    //   excel.updateCell(
    //       "Sheet1",
    //       CellIndex.indexByString("$programmedQtyKey${entryStartRow + i}"),
    //       _toolkitSheet.value.entry[i][0]);
    //   excel.updateCell(
    //       "Sheet1",
    //       CellIndex.indexByString("$meterVolKey${entryStartRow + i}"),
    //       _toolkitSheet.value.entry[i][1]);
    //   excel.updateCell(
    //       "Sheet1",
    //       CellIndex.indexByString("$referenceVolKey${entryStartRow + i}"),
    //       _toolkitSheet.value.entry[i][2]);
    //   excel.updateCell(
    //       "Sheet1",
    //       CellIndex.indexByString("$differenceVolKey${entryStartRow + i}"),
    //       _toolkitSheet.value.entry[i][3]);
    //   excel.updateCell(
    //       "Sheet1",
    //       CellIndex.indexByString("$flowRateKey${entryStartRow + i}"),
    //       _toolkitSheet.value.entry[i][4]);
    //   excel.updateCell(
    //       "Sheet1",
    //       CellIndex.indexByString("$adjustmentsKey${entryStartRow + i}"),
    //       _toolkitSheet.value.entry[i][5]);
    //   excel.updateCell(
    //       "Sheet1",
    //       CellIndex.indexByString("$meterFactorKey${entryStartRow + i}"),
    //       _toolkitSheet.value.entry[i][6]);

    //   excel.updateCell(
    //       "Sheet1",
    //       CellIndex.indexByString("$remarksKey${entryStartRow + i}"),
    //       _toolkitSheet.value.entry[i][7]);
    // }

    // a3:k29
    // excel.sheets["Sheet1"].

    // var fileBytes = excel.save()!;
    final f = await _saveDocx(c);
    return f;
  }

  Future<File> _saveDocx(Content c) async {
    var fileBytes = await doc.generate(c);
    var directory = await getTemporaryDirectory();
    var nameOfFile = "toolkitsheet-${DateTime.now().millisecondsSinceEpoch}";

    final f = File('${directory.path}/$nameOfFile.docx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    return f;
  }

  _shareWorkSheet(File f) async {
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
        // print(response.data);

        final pdfBytes = Uint8List.fromList(response.data);
        // print(pdfBytes);
        // f = File('${directory.path}/$nameOfFile.pdf')
        //   ..createSync(recursive: true)
        //   ..writeAsBytesSync(pdfBytes);
        // print(f.path);
        return pdfBytes;
      } else {
        print('Conversion failed with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return f.readAsBytes();
  }

  _printWorkSheet(File f) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => _fetchSomeData(f),
    );
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
