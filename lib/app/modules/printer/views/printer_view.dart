import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';

import 'package:get/get.dart';

import '../controllers/printer_controller.dart';

class PrinterView extends GetView<PrinterController> {
  PrinterView({Key? key}) : super(key: key);

  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('USB PRINTER'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.getDeviceList()),
            controller.connected.value == true
                ? IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () {
                      Get.defaultDialog(
                          title: "Print selection",
                          content: ListView(
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                  title: const Text("write"),
                                  onTap: () {
                                    _print(0);
                                  }),
                              ListTile(
                                  title: const Text("printRawData"),
                                  onTap: () {
                                    _print(1);
                                  }),
                              ListTile(
                                  title: const Text("printText"),
                                  onTap: () {
                                    _print(2);
                                  })
                            ],
                          ));
                    })
                : Container(),
          ],
        ),
        body: controller.devices.isNotEmpty
            ? ListView(
                scrollDirection: Axis.vertical,
                children: _buildList(controller.devices),
              )
            : const Text("Searching.."),
      ),
    );
  }

  _print(int selection) async {
    try {
      if (selection == 0) {
        var data =
            Uint8List.fromList(utf8.encode("Write Testing ESC POS printer..."));
        await flutterUsbPrinter.write(data).then((value) {
          // _dialog();
        });
      } else if (selection == 1) {
        await flutterUsbPrinter
            .printRawText("Raw Testing ESC POS printer...")
            .then((value) {});
      } else if (selection == 2) {
        await flutterUsbPrinter
            .printText("Text Testing ESC POS printer...")
            .then((value) {});
      }
    } on PlatformException {
      debugPrint("Failed to get platform version.");
    }
  }

  void _dialog() {
    Get.defaultDialog(
        title: "Printed Successfully",
        content: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("OK"))
          ],
        ));
  }

  _connect(int vendorId, int productId) async {
    bool? returned = false;
    try {
      returned = await flutterUsbPrinter.connect(vendorId, productId);
    } on PlatformException {
      debugPrint("Failed to get platform version.");
    }
    if (returned!) {
      controller.connected.value = true;
    }
  }

  List<Widget> _buildList(List<Map<String, dynamic>> devices) {
    return devices
        .map((device) => ListTile(
              onTap: () {
                _connect(int.parse(device['vendorId']),
                    int.parse(device['productId']));
              },
              leading: const Icon(Icons.usb),
              title: Text(device['manufacturer'] + " " + device['productName']),
              subtitle: Text(device['vendorId'] + " " + device['productId']),
            ))
        .toList();
  }
}
