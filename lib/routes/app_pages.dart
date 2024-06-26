import 'package:aldente/bindings/bottomnavbar_binding.dart';
import 'package:aldente/bindings/clinichome_binding.dart';
import 'package:aldente/bindings/doctorhome_binding.dart';
import 'package:aldente/bottom_nav_bar.dart';
import 'package:aldente/pages/clinic_home.dart';
import 'package:aldente/pages/doctor_home.dart';
import 'package:aldente/pages/explore_page.dart';
import 'package:get/get.dart';

import '../bindings/chatdashboard_binding.dart';
import '../bindings/login_binding.dart';
import '../bindings/chatting_binding.dart';
import '../modules/chatting/chatting_view.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/login/login_view.dart';
import '../pages/x_rays_camera/explore_page_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOMNAVBAR,
      page: () => const BottomNavBar(),
      binding: BottomNavBarBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const ChatPage(),
      binding: ChatDashboardBinding(),
    ),
    GetPage(
      name: _Paths.CHATTING,
      page: () => const ChattingView(),
      binding: ChattingBinding(),
    ),
    GetPage(
      name: _Paths.DOCTORHOME,
      page: () => const DoctorHome(),
      binding: DoctorHomeBinding(),
    ),
    GetPage(
      name: _Paths.CLINICHOME,
      page: () => const ClinicHome(),
      binding: ClinicHomeBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => const ExplorePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ExplorePageController());
      }),
    ),

  ];
}
