import 'package:get/get.dart';

import '../controllers/pengajuan_controller.dart';

class PengajuanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengajuanController>(
      () => PengajuanController(),
    );
  }
}
