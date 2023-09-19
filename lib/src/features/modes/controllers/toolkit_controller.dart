import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../../src_barrel.dart';
import '../models/lanemeter.dart';
import '../models/toolkitsheet.dart';

class ToolkitController extends GetxController {
  static const List<List<dynamic>> allLanes = [
    [
      1,
      ToolkitLocation.tincan,
      "AGO",
      "A1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      2,
      ToolkitLocation.tincan,
      "AGO",
      "A2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      3,
      ToolkitLocation.tincan,
      "PMS",
      "B1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "P655652965",
      "190-3400",
      1
    ],
    [
      4,
      ToolkitLocation.tincan,
      "PMS",
      "B2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      0
    ],
    [
      5,
      ToolkitLocation.tincan,
      "PMS",
      "C1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      6,
      ToolkitLocation.tincan,
      "PMS",
      "C2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1405E10088",
      "190-3400",
      1
    ],
    [
      7,
      ToolkitLocation.tincan,
      "PMS",
      "D1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "P655652954",
      "190-3400",
      1
    ],
    [
      8,
      ToolkitLocation.tincan,
      "PMS",
      "D2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "P655654715",
      "190-3400",
      1
    ],
    [
      9,
      ToolkitLocation.tincan,
      "PMS",
      "E1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "P655652535",
      "190-3400",
      1
    ],
    [
      10,
      ToolkitLocation.tincan,
      "PMS",
      "E2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      11,
      ToolkitLocation.tincan,
      "PMS",
      "F1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      12,
      ToolkitLocation.tincan,
      "PMS",
      "F2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "P655654718",
      "190-3400",
      1
    ],
    [
      13,
      ToolkitLocation.tincan,
      "SN150",
      "G1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      0
    ],
    [
      14,
      ToolkitLocation.tincan,
      "SN500",
      "G2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      0
    ],
    [
      15,
      ToolkitLocation.tincan,
      "ATK",
      "H1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1405E10088",
      "190-3400",
      1
    ],
    [
      16,
      ToolkitLocation.apapa,
      "PMS",
      "A1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      17,
      ToolkitLocation.apapa,
      "PMS",
      "A2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      18,
      ToolkitLocation.apapa,
      "PMS",
      "B1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      19,
      ToolkitLocation.apapa,
      "PMS",
      "B2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      20,
      ToolkitLocation.apapa,
      "PMS",
      "C1",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ],
    [
      21,
      ToolkitLocation.apapa,
      "PMS",
      "C2",
      30,
      "FMC",
      "PRIME  4-B-1-1-0-0",
      "1323E1 0142",
      "280-2800",
      1
    ]
  ];

  static const String locationKey = "B6";
  static const String productKey = "AC6";
  static const String laneKey = "AC7";
  static const String checksKey = "AC8";
  static const String nextdateKey = "AC9";
  static const String dateKey = "B7";
  static const String meterKey = "R10";
  static const String makeKey = "R6";
  static const String modelKey = "R7";
  static const String serialnoKey = "R8";
  static const String flowrangeKey = "R9";

  //prover meter
  static const String typeKey = "I6";
  static const String proverModelKey = "I7";
  static const String proverSerialKey = "I8";
  static const String proverCapacityKey = "I9";
  static const String proverMakeKey = "I10";

  //checks
  static const String internalCheckKey = "R12";
  static const String externalCalibKey = "X12";
  static const String calibByKey = "E27";
  static const String calibSigKey = "E29";
  static const String checkByKey = "Z27";
  static const String checkSigKey = "Z29";

  static const int sigWidth = 560;
  static const int sigHeight = 40;
  static const int entryStartRow = 15;
  static const int entryEndRow = 26;

  static const String programmedQtyKey = "B";
  static const String meterVolKey = "H";
  static const String referenceVolKey = "K";
  static const String differenceVolKey = "R";
  static const String flowRateKey = "U";
  static const String adjustmentsKey = "Z";
  static const String prevMeterFactorKey = "AA";
  static const String newMeterFactorKey = "AB";
  static const String remarksKey = "AC";

  final _mode = ToolkitModes.internalCheck.obs;
  final _location = ToolkitLocation.tincan.obs;
  final _lane = LaneMeter().obs;
  final _allMeters = <LaneMeter>[].obs;
  final _toolkitSheet = ToolkitSheet(
    laneMeter: LaneMeter(),
    entry: [],
    location: ToolkitLocation.tincan,
    nextdate: "",
    date: "",
  ).obs;

  late Excel excel;

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

  List<LaneMeter> get allMeters => _allMeters;
  Map<String, LaneMeter> get allMetersMap =>
      {for (var e in _allMeters) "${e.location.title} - ${e.lane}": e};

  _initLanes() {
    for (var element in allLanes) {
      _allMeters.add(LaneMeter(
        enabled: element[9],
        location: element[1],
        product: element[2],
        lane: element[3],
        make: element[5],
        model: element[6],
        serialno: element[7],
        flowrange: element[8],
      ));
    }
  }

  initWorkSheet() async {
    _initLanes();
    ByteData data = await rootBundle.load('assets/json/toolkitsheet.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    excel = Excel.decodeBytes(bytes);
  }

  saveToolkitSheet(
      String checkBy, String calibBy, List<List<dynamic>> entries) async {
    _toolkitSheet.value.date = DateFormat("dd/MM/yyyy").format(DateTime.now());
    _toolkitSheet.value.nextdate = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(Duration(days: _toolkitSheet.value.checks)));
    _toolkitSheet.value.calibBy = calibBy;
    _toolkitSheet.value.checkBy = checkBy;
    _toolkitSheet.value.entry = entries;

    await _saveToolkitSheet();
  }

  _saveToolkitSheet() async {
    excel.updateCell("Sheet1", CellIndex.indexByString(locationKey),
        _toolkitSheet.value.location.title);
    excel.updateCell("Sheet1", CellIndex.indexByString(dateKey),
        DateFormat("dd/MM/yyyy").format(DateTime.now()));
    excel.updateCell("Sheet1", CellIndex.indexByString(typeKey),
        _toolkitSheet.value.location.proverType);
    excel.updateCell("Sheet1", CellIndex.indexByString(proverModelKey),
        _toolkitSheet.value.location.proverModel);
    excel.updateCell("Sheet1", CellIndex.indexByString(proverSerialKey),
        _toolkitSheet.value.location.proverSerialno);
    excel.updateCell("Sheet1", CellIndex.indexByString(proverCapacityKey),
        _toolkitSheet.value.location.proverCapacity);
    excel.updateCell("Sheet1", CellIndex.indexByString(proverMakeKey),
        _toolkitSheet.value.location.proverMake);
    excel.updateCell("Sheet1", CellIndex.indexByString(makeKey),
        _toolkitSheet.value.laneMeter.make);
    excel.updateCell("Sheet1", CellIndex.indexByString(modelKey),
        _toolkitSheet.value.laneMeter.model);
    excel.updateCell("Sheet1", CellIndex.indexByString(serialnoKey),
        _toolkitSheet.value.laneMeter.serialno);
    excel.updateCell("Sheet1", CellIndex.indexByString(flowrangeKey),
        _toolkitSheet.value.laneMeter.flowrange);
    excel.updateCell("Sheet1", CellIndex.indexByString(meterKey),
        _toolkitSheet.value.laneMeter.lane);
    excel.updateCell("Sheet1", CellIndex.indexByString(productKey),
        _toolkitSheet.value.laneMeter.product);
    excel.updateCell("Sheet1", CellIndex.indexByString(laneKey),
        _toolkitSheet.value.laneMeter.lane);
    excel.updateCell("Sheet1", CellIndex.indexByString(checksKey),
        _toolkitSheet.value.checks);
    excel.updateCell("Sheet1", CellIndex.indexByString(internalCheckKey),
        _toolkitSheet.value.internalCheck);
    excel.updateCell("Sheet1", CellIndex.indexByString(externalCalibKey),
        _toolkitSheet.value.externalCalib);
    excel.updateCell("Sheet1", CellIndex.indexByString(checkByKey),
        _toolkitSheet.value.checkBy);
    excel.updateCell("Sheet1", CellIndex.indexByString(calibByKey),
        _toolkitSheet.value.calibBy);
    excel.updateCell("Sheet1", CellIndex.indexByString(checkSigKey),
        _toolkitSheet.value.checkSig);
    excel.updateCell("Sheet1", CellIndex.indexByString(calibSigKey),
        _toolkitSheet.value.calibSig);

    for (var i = 0; i < _toolkitSheet.value.entry.length; i++) {
      excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("$programmedQtyKey${entryStartRow + i}"),
          _toolkitSheet.value.entry[i][0]);
      excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("$meterVolKey${entryStartRow + i}"),
          _toolkitSheet.value.entry[i][1]);
      excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("$referenceVolKey${entryStartRow + i}"),
          _toolkitSheet.value.entry[i][2]);
      excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("$differenceVolKey${entryStartRow + i}"),
          _toolkitSheet.value.entry[i][3]);
      excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("$flowRateKey${entryStartRow + i}"),
          _toolkitSheet.value.entry[i][4]);
      excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("$adjustmentsKey${entryStartRow + i}"),
          _toolkitSheet.value.entry[i][5]);
      excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("$prevMeterFactorKey${entryStartRow + i}"),
          _toolkitSheet.value.entry[i][6]);
      excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("$newMeterFactorKey${entryStartRow + i}"),
          _toolkitSheet.value.entry[i][7]);
      excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("$remarksKey${entryStartRow + i}"),
          _toolkitSheet.value.entry[i][8]);
    }

    var fileBytes = excel.save()!;
    var directory = await getTemporaryDirectory();
    var nameOfFile =
        "toolkitsheet-${DateTime.now().millisecondsSinceEpoch}.xlsx";

    final f = File('${directory.path}/$nameOfFile.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    final xf = XFile(f.path);

    await Share.shareXFiles(
      [xf],
    );
  }

  static double calcKFactor(double batchVol, double oldKFactor, double ddiff,
      double proverVol, double meterVol, bool isApapa) {
    final diff = proverVol - meterVol;
    final desiredDiff = batchVol + ddiff;
    double nkfactor = oldKFactor;
    if (isApapa) {
      if (desiredDiff - diff > 0) {
        nkfactor = (meterVol * oldKFactor) / (desiredDiff);
      } else {
        nkfactor = (desiredDiff * oldKFactor) / (meterVol);
      }
    } else {
      if (desiredDiff - diff > 0) {
        nkfactor = (desiredDiff * oldKFactor) / (meterVol);
      } else {
        nkfactor = (meterVol * oldKFactor) / (desiredDiff);
      }
    }

    return nkfactor;
  }
}
