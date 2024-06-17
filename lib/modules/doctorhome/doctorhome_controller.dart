import 'package:aldente/routes/app_pages.dart';
import 'package:aldente/services/pocketbase/pocketbase_service.dart';
import 'package:get/get.dart';

class DoctorHomeController extends GetxController {
  void onLogoutTap() {
    try {
      PocketbaseService.to.logout();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.log(e.toString());
    }
  }
}
