import 'dart:async';

import 'package:get/get.dart';

import '../../features/modes/models/lanemeter.dart';
import '../../plugin/jwt.dart';
import '../../src_barrel.dart';
import '../../utils/constants/prefs/prefs.dart';
import '../model/barrel.dart';
import 'barrel.dart';

class AppService extends GetxService {
  Rx<User> currentUser = User().obs;
  RxBool hasOpenedOnboarding = false.obs;
  RxBool isLoggedIn = false.obs;
  final apiService = Get.find<DioApiService>();
  final prefService = Get.find<MyPrefService>();

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

  static const List<List<dynamic>> allRefInstruments = [
    [
      ToolkitLocation.tincan,
      "SERAPHIN",
      "SERIES J",
      "16-58519-01",
      "OPEN PROVER TANK",
      "5000"
    ],
    [
      ToolkitLocation.apapa,
      "SERAPHIN",
      "SERIES J",
      "16-58519-01",
      "OPEN PROVER TANK",
      "5000"
    ]
  ];

  initUserConfig() async {
    await _hasOpened();

    await _initLaneMeters();
    await _initRefInstrument();
    await _setLoginStatus();
    if (isLoggedIn.value) {
      await _setCurrentUser();
    }
  }

  loginUser(String jwt, String refreshJwt) async {
    await _saveJWT(jwt, refreshJwt);
    await _setCurrentUser();
  }

  logout() async {
    await apiService.post(AppUrls.logout);
    await _logout();
  }

  _hasOpened() async {
    bool a = prefService.get(MyPrefs.hasOpenedOnboarding) ?? false;
    if (a == false) {
      await prefService.save(MyPrefs.hasOpenedOnboarding, true);
    }
    hasOpenedOnboarding.value = a;
  }

  _logout() async {
    final b = prefService.get(MyPrefs.mpLogin3rdParty) ?? false;
    if (b) {
      // final c = await GoogleSignIn().isSignedIn();
      // if (c) {
      //   await GoogleSignIn().disconnect();
      // }
    }
    await prefService.eraseAllExcept(MyPrefs.hasOpenedOnboarding);
  }

  _saveJWT(String jwt, String refreshJwt) async {
    final msg = Jwt.parseJwt(jwt);
    await prefService.saveAll({
      MyPrefs.mpLoginExpiry: msg["exp"],
      MyPrefs.mpUserJWT: jwt,
      MyPrefs.mpIsLoggedIn: true,
      MyPrefs.mpUserRefreshJWT: refreshJwt,
    });
  }

  _refreshToken() async {
    final res = await apiService.post(AppUrls.changePassword,
        data: {"refresh_token": prefService.get(MyPrefs.mpUserRefreshJWT)});
    await _saveJWT(res.data["access_token"], res.data["refresh_token"]);
  }

  _setCurrentUser() async {
    final res = await apiService.post(AppUrls.getUser);
    currentUser.value = User.fromJson(res.data);
    _listenToRefreshTokenExpiry();
  }

  _setLoginStatus() async {
    final e = prefService.get(MyPrefs.mpLoginExpiry) ?? 0;
    if (e != 0 && DateTime.now().millisecondsSinceEpoch > e * 1000) {
      await _refreshToken();
      isLoggedIn.value = true;
    }
    isLoggedIn.value = prefService.get(MyPrefs.mpIsLoggedIn) ?? false;
  }

  _listenToRefreshTokenExpiry() {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      final e = prefService.get(MyPrefs.mpLoginExpiry) ?? 0;
      if (e == 0) {
        timer.cancel();
      } else if (DateTime.now().millisecondsSinceEpoch - (e * 1000) > 100000) {
        await _refreshToken();
      }
    });
  }

  //LANEMETER
  _initLaneMeters() async {
    if (hasOpenedOnboarding.value == true) {
      return;
    }

    print("start initing lanes");

    for (var i = 0; i < allLanes.length; i++) {
      await _addLaneMeter(LaneMeter(
        enabled: allLanes[i][9],
        location: allLanes[i][1],
        product: allLanes[i][2],
        lane: allLanes[i][3],
        make: allLanes[i][5],
        checks: allLanes[i][4],
        model: allLanes[i][6],
        serialno: allLanes[i][7],
        flowrange: allLanes[i][8],
      ));
    }
    print("done initing lanes");
  }

  _addLaneMeter(LaneMeter a) async {
    List<dynamic>? allLaneMeters = prefService.get(MyPrefs.mpLanemeters) ?? [];

    allLaneMeters.add(a.toSaveAsString());
    await prefService.save(MyPrefs.mpLanemeters, allLaneMeters);
  }

  //LANEMETER
  _initRefInstrument() async {
    if (hasOpenedOnboarding.value == true) {
      return;
    }

    for (var i = 0; i < allRefInstruments.length; i++) {
      await _addRefInstrument(RefInstrument(
        location: allRefInstruments[i][0],
        capacity: allRefInstruments[i][5],
        make: allRefInstruments[i][1],
        model: allRefInstruments[i][2],
        serialno: allRefInstruments[i][3],
        type: allRefInstruments[i][4],
      ));
    }
  }

  _addRefInstrument(RefInstrument a) async {
    List<dynamic>? allRefs = prefService.get(MyPrefs.mpRefInstruments) ?? [];

    allRefs.add(a.toSaveAsString());
    await prefService.save(MyPrefs.mpRefInstruments, allRefs);
  }

  changeServerAddress({String url = "192.168.0.136"}) async {
    await prefService.save(MyPrefs.mpServer, url);
  }

  String getServerAddress() {
    final f = prefService.get(MyPrefs.mpServer) ?? "192.168.0.136";
    return f;
  }
}
