import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printer/app/data/product.dart';
import 'package:printer/app/modules/home/controllers/product_controller.dart';
import 'package:printer/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final _productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Management'),
        centerTitle: true,
        actions:  [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() =>  Center(child: Text("Total ${_productController.totalPrice}"))),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Center(
              child: _productController.productList.isNotEmpty
                  ? generateList(context)
                  : const Text("No item present"),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var results = await Get.toNamed(Routes.ADD) as Product;
          debugPrint(results.productName);
        },
      ),
    );
  }

  Widget generateList(BuildContext context) {
    return ListView.builder(
        itemCount: _productController.productList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                _productController
                    .delete(_productController.productList[index]);
              },
              background: Container(
                color: Colors.red,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: cardItemRow(index));
        });
  }

  Widget cardItemRow(int index) {
    Product task = _productController.productList[index];

    return GestureDetector(
      onTap: () async {
        await Get.toNamed(Routes.EDIT,
                arguments: [(task.productName), (task.qty), (task.price)])!
            .then((value) {
          controller.updateItem(index, value as Product);
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(task.productName!),
              Text("${task.price}"),
              Row(
                children: [
                  IconButton(
                      color: Colors.black,
                      onPressed: () {
                        _productController.updateQty(task.id!, task.qty! - 1);
                      },
                      icon: const Icon(Icons.remove)),
                  Text("${task.qty}"),
                  IconButton(
                      color: Colors.black,
                      onPressed: () {
                        _productController.updateQty(task.id!, task.qty! + 1);
                      },
                      icon: const Icon(Icons.add)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
