import 'dart:ui' as ui;

import 'package:bestaf_toolkit/src/features/modes/models/lanemeter.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';

class ToolkitSheet {
  LaneMeter laneMeter;
  ToolkitLocation location;
  int checks;
  String nextdate, date, internalCheck, externalCalib, calibBy, checkBy;
  ui.Image? calibSig, checkSig;
  List<List<dynamic>> entry;
  //[5000,5000,4999,-1,2700,n,52.895,53.985,""]

  ToolkitSheet({
    required this.laneMeter,
    required this.entry,
    required this.location,
    this.checks = 30,
    required this.nextdate,
    required this.date,
    this.internalCheck = "",
    this.externalCalib = "",
    this.calibBy = "",
    this.checkBy = "",
    this.calibSig,
    this.checkSig,
  });
}