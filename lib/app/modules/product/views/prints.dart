import 'dart:convert';

import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:printer/app/modules/product/controllers/product_controller.dart';

class Print extends StatefulWidget {
  @override
  _PrintState createState() => new _PrintState();
}

class _PrintState extends State<Print> {
  List<Map<String, dynamic>> devices = [];
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  bool connected = false;

  final _productController = Get.put(ProductController());


  @override
  initState() {
    super.initState();
    _getDeviceList();
  }

  _getDeviceList() async {
    List<Map<String, dynamic>> results = [];
    results = await FlutterUsbPrinter.getUSBDeviceList();

    debugPrint(" length: ${results.length}");
    setState(() {
      devices = results;
    });
  }

  _connect(int vendorId, int productId) async {
    bool? returned = false;
    try {
      returned = await flutterUsbPrinter.connect(vendorId, productId);
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
    if (returned!) {
      setState(() {
        connected = true;
      });
    }
  }

  ///print message with help of flutter usb printer package.
  Future<void> doPrint() async {
    List<int> list = await generateTicket();


    try {

      var data =
      Uint8List.fromList(list);

      await flutterUsbPrinter.write(data).then((value) {
        debugPrint("printed");
      });
    } catch (e) {
      debugPrint('catch $e');
    }
  }

  Future<List<int>> generateTicket() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød',
        styles: const PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'QTY',
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'Item',
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'Price',
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: '1',
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'ONION',
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'PIZZA',
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'TOTAL',
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: '',
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: '\$00',
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    bytes += generator.feed(2);
    bytes += generator.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += generator.text(timestamp,
        styles: const PosStyles(align: PosAlign.center), linesAfter: 2);

    bytes += generator.feed(1);
    bytes += generator.cut();

    return bytes;
  }

  _print(int selection) async {
    try {
      if (selection == 0) {
        var data =
            Uint8List.fromList(utf8.encode(_productController.createBill()));
        await flutterUsbPrinter.write(data).then((value) {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USB PRINTER'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _getDeviceList()),
          connected == true
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
                                }),
                            ListTile(
                                title: const Text("Sample 1"),
                                onTap: () {
                                  doPrint();
                                }),
                            ListTile(
                                title: const Text("Sample 2"), onTap: () {})
                          ],
                        ));
                  })
              : Container(),
        ],
      ),
      body: devices.isNotEmpty
          ? ListView(
              scrollDirection: Axis.vertical,
              children: _buildList(devices),
            )
          : null,
    );
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
