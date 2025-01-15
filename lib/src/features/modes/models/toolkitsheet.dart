import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bestaf_toolkit/src/features/modes/models/lanemeter.dart';
import 'package:bestaf_toolkit/src/src_barrel.dart';

class ToolkitSheet {
  LaneMeter laneMeter;
  ToolkitLocation location;
  RefInstrument ref;
  String nextdate, date, internalCheck, externalCalib, calibBy, checkBy;
  Uint8List? calibSig, checkSig;
  List<List<dynamic>> entry;
  //[5000,5000,4999,-1,2700,n,52.895,53.985,""]

  ToolkitSheet({
    required this.laneMeter,
    required this.entry,
    required this.location,
    required this.ref,
    required this.nextdate,
    required this.date,
    this.internalCheck = "",
    this.externalCalib = "",
    this.calibBy = "",
    this.checkBy = "",
    this.calibSig,
    this.checkSig,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "${laneMeter.toSaveAsString()}---${ref.toSaveAsString()}---${location.title}---${_entrySave()}---$date";
  }

  factory ToolkitSheet.fromString(String s) {
    final split = s.split("---");
    final laneMeter = LaneMeter.fromString(split[0]);
    final ref = RefInstrument.fromString(split[1]);
    final location = ToolkitLocation.values
        .firstWhere((element) => element.title == split[2]);
    print(split[3]);
    final entry = split[3].split("#,#").map((e) => e.split("-,-")).toList();
    print(entry..removeLast());
    final date = split[4];
    return ToolkitSheet(
        laneMeter: laneMeter,
        entry: entry,
        location: location,
        ref: ref,
        nextdate: "",
        date: date);
  }

  String _entrySave() {
    String es = "";
    for (var i = 0; i < entry.length; i++) {
      es += entry[i].join("-,-");
      es += "#,#";
    }
    return es;
  }
}
