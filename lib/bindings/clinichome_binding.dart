import 'package:aldente/modules/clinichome/clinichome_controller.dart';
import 'package:get/get.dart';


class ClinicHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicHomeController>(
      () => ClinicHomeController(),
    );
  }
}
