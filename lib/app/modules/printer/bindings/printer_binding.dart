import 'package:get/get.dart';

import '../controllers/printer_controller.dart';

class PrinterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrinterController>(
      () => PrinterController(),
    );
  }
}
