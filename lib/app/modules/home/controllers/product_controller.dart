import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/product.dart';
import '../../../db/db_helper.dart';

class ProductController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  var productList = <Product>[].obs;

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
  }

  void delete(Product task) {
    DBHelper.delete(task);
    getTasks();
  }

  void updateQty(int id, int qty) async {
    await DBHelper.update(id, qty);
    getTasks();
  }
}
