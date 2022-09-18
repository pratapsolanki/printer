import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/product.dart';
import '../../../db/db_helper.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;

  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  Future<void> addTask({Product? product}) async {
    debugPrint("product");
    debugPrint(product.toString());
    debugPrint(product?.toJson().toString());
    await DBHelper.insert(product);
    getTasks();
  }

  double get totalPrice =>
      productList.fold(0, (sum, item) => sum + (item.price! * item.qty!));

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    if (tasks.isNotEmpty) {
      productList
          .assignAll(tasks.map((data) => Product.fromJson(data)).toList());
    } else {
      debugPrint("empty");
      productList.value = [];
    }

    // debugPrint(createBill());
/*
    var data = Uint8List.fromList(utf8.encode(createBill()));

    debugPrint(data.toString());
    debugPrint(data.toList().toString());

    debugPrint("convert");
    debugPrint(convertUint8ListToString(data));
    debugPrint("convert ended");*/
  }

  String convertUint8ListToString(Uint8List uint8list) {
    return String.fromCharCodes(uint8list);
  }

  void delete(Product product) {
    DBHelper.delete(product);
    getTasks();
  }

  void updateQty(int id, int qty) async {
    await DBHelper.updateQty(id, qty);
    getTasks();
  }

  Future<void> updateProduct(Product product) async {
    DBHelper.updateProduct(product);
    getTasks();
  }

  String createBill() {
    String bill = "\n";
    bill += "JBSOLUTIONS PVT LTD\n";
    bill += "304,  Shukan Business Center\n";
    bill += "Swastik Cross Road, C G Road\n";
    bill += "Ahmedabad 380009\n";
    bill += "Tel: +91 79 26422134'\n";
    bill += "Web: www.jbsolutions.com\n\n";
    bill += "================================\n";
    bill += "Name        Qty            Price\n";
    bill += "================================\n";
    for (int i = 0; i < productList.length; i++) {
      bill +=
          "${productList.value[i].productName!}      ${productList.value[i].qty!}            ${productList.value[i].price!.toStringAsFixed(2)}\n";
    }
    bill += "================================\n";
    bill += "Total: $totalPrice\n\n";
    bill += "PayMode: Online\n";
    bill += "Thank you for shopping!\n";

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bill += "$timestamp\n";

    return bill;
  }
}
