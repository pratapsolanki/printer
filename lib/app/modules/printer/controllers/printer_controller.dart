import 'package:flutter/cupertino.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:get/get.dart';

class PrinterController extends GetxController {
  var devices = <Map<String, dynamic>>[].obs;
  final connected = false.obs;

  @override
  void onInit() {
    super.onInit();
    getDeviceList();
  }

  getDeviceList() async {
    List<Map<String, dynamic>> results = [];
    results = await FlutterUsbPrinter.getUSBDeviceList();

    debugPrint(" length: ${results.length}");
    devices.value = results;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
