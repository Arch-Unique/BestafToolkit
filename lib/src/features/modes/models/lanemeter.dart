import 'package:bestaf_toolkit/src/src_barrel.dart';

class LaneMeter {
  int enabled;
  String product, lane, make, model, serialno, flowrange;
  ToolkitLocation location;

  LaneMeter(
      {this.enabled = 0,
      this.location = ToolkitLocation.tincan,
      this.product = "PMS",
      this.lane = "A1",
      this.make = "FMC",
      this.model = "",
      this.serialno = "",
      this.flowrange = ""});
}
