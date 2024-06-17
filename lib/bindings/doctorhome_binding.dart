import 'package:aldente/modules/doctorhome/doctorhome_controller.dart';
import 'package:get/get.dart';


class DoctorHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorHomeController>(
      () => DoctorHomeController(),
    );
  }
}
