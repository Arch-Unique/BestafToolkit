import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../utils_barrel.dart';

enum PasswordStrength {
  normal,
  weak,
  okay,
  strong,
}

enum FPL {
  email(TextInputType.emailAddress),
  number(TextInputType.numberWithOptions(decimal: true, signed: true)),
  text(TextInputType.text),
  password(TextInputType.visiblePassword),
  multi(TextInputType.multiline, maxLength: 1000, maxLines: 5),
  phone(TextInputType.phone),
  money(TextInputType.numberWithOptions(decimal: true, signed: true),
      maxLength: 20),

  //card details
  cvv(TextInputType.number, maxLength: 4),
  cardNo(TextInputType.number, maxLength: 20),
  dateExpiry(TextInputType.datetime, maxLength: 5);

  final TextInputType textType;
  final int? maxLength, maxLines;

  const FPL(this.textType, {this.maxLength, this.maxLines = 1});
}

enum CurrencyIcon {
  usd(FontAwesome.dollar_sign),
  ngn(FontAwesome.naira_sign),
  gbp(FontAwesome.sterling_sign),
  eur(FontAwesome.euro_sign),
  jpy(FontAwesome.yen_sign),
  inr(FontAwesome.indian_rupee_sign);

  final FontAwesomeIconDataSolid icon;
  const CurrencyIcon(this.icon);
}

enum ErrorTypes {
  noInternet(Icons.wifi_tethering_off_rounded, "No Internet Connection",
      "Please check your internet connection and try again"),
  noFacility(Assets.errorfacility, "No Facility Found",
      "Sorry, we couldn't find any matching facilities, Please contact support for assistance and alternatives"),
  noPatient(Icons.pregnant_woman_rounded, "No Patient Found",
      "Oops. no patients found. Please contact support for help"),
  noDonation(Iconsax.empty_wallet, "No Donation Found",
      "You haven't made any donations yet. Why not make a difference today? "),
  serverFailure(Icons.power_off_rounded, "Server Failure",
      "Something bad happened. Please try again later");

  final String title, desc;
  final dynamic icon;
  const ErrorTypes(this.icon, this.title, this.desc);
}

enum ToolkitModes {
  poupload("Upload PO"),
  internalCheck("Internal Check"),
  uploadInternal("Upload Internal Check"),
  externalCalibration("External Calibration"),
  uploadExternal("Upload External Check"),
  certupload("Upload Certificate"),
  kFactorCalculation("K-Factor Calculation"),
  settings("Settings");

  final String title;
  const ToolkitModes(this.title);
}

enum SettingsModes {
  lanemeter("Lane Meters", "Create, edit and delete lanemeters"),
  reference(
      "Reference Instrument", "Create,edit and delete reference instruments"),
  history("History", "View history of all your toolkit sheets"),
  edituom("Unit Of Measurement",
      "Change unit of measurement (default(true): Litre)");

  final String title, description;
  const SettingsModes(this.title, this.description);
}

enum ToolkitLocation {
  tincan("TINCAN"),
  apapa("APAPA");

  final String title;
  const ToolkitLocation(this.title);
}
