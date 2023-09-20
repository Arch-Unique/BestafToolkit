import 'package:get/get.dart';

import '../../features/onboarding_screen.dart';
import '../../src_barrel.dart';
// import '../../utils/constants/routes/middleware/auth_middleware.dart';

class AppPages {
  static List<GetPage> getPages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const OnboardingScreen(),
      // middlewares: [AuthMiddleWare()]
    ),
    // GetPage(name: AppRoutes.auth, page: () => AuthScreen()),
    // GetPage(name: AppRoutes.dashboard, page: () => DashboardScreen()),
  ];
}
