import 'package:aldente/modules/bottomnavbar/bottomnavbar_controller.dart';
import 'package:get/get.dart';


class BottomNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavBarController>(
      () => BottomNavBarController(),
    );
  }
}
