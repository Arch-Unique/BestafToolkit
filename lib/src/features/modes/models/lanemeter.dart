import 'package:bestaf_toolkit/src/src_barrel.dart';

class LaneMeter {
  int enabled, checks;
  String product, lane, make, model, serialno, flowrange;
  ToolkitLocation location;

  LaneMeter(
      {this.enabled = 0,
      this.location = ToolkitLocation.tincan,
      this.product = "PMS",
      this.lane = "A1",
      this.checks = 30,
      this.make = "FMC",
      this.model = "",
      this.serialno = "",
      this.flowrange = ""});

  @override
  String toString() {
    return "${location.title} - $lane";
  }

  String toSaveAsString() {
    return "${location.title}*$lane*$product*$make*$model*$serialno*$flowrange*$checks";
  }

  factory LaneMeter.fromString(String a) {
    final s = a.split("*");
    return LaneMeter(
        location: ToolkitLocation.values
            .where((element) => element.title == s[0])
            .toList()[0],
        lane: s[1],
        product: s[2],
        make: s[3],
        model: s[4],
        serialno: s[5],
        flowrange: s[6],
        checks: int.parse(s[7]));
  }
}

class RefInstrument {
  String type, model, serialno, capacity, make;
  ToolkitLocation location;

  RefInstrument(
      {this.type = "",
      this.location = ToolkitLocation.tincan,
      this.make = "SERAPHIN",
      this.model = "",
      this.serialno = "",
      this.capacity = ""});

  @override
  String toString() {
    return "${location.title} - $type";
  }

  String toSaveAsString() {
    return "${location.title}*$type*$make*$model*$serialno*$capacity";
  }

  factory RefInstrument.fromString(String a) {
    final s = a.split("*");
    return RefInstrument(
      location: ToolkitLocation.values
          .where((element) => element.title == s[0])
          .toList()[0],
      type: s[1],
      make: s[2],
      model: s[3],
      serialno: s[4],
      capacity: s[5],
    );
  }
}
