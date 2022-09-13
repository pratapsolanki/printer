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
      appBar: AppBar(title: const Text('Print Management'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Center(
              child: _productController.productList.isNotEmpty
                  ? generateList(context)
                  : const Text("No product present"),
            )),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Obx(
            () => ElevatedButton(
                onPressed: () async {
                  var results = await Get.toNamed(Routes.ADD) as Product;
                  debugPrint(results.productName);
                },
                child: Text("Total ${_productController.totalPrice}")),
          ),
          ElevatedButton(onPressed: () async {}, child: const Text("Print")),
          ElevatedButton(
              onPressed: () async {
                var results = await Get.toNamed(Routes.ADD) as Product;
                debugPrint(results.productName);
              },
              child: const Text("Add Product"))
        ],
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
    Product product = _productController.productList[index];

    return GestureDetector(
      onTap: () async {
        await Get.toNamed(Routes.EDIT, arguments: [
          (product.productName),
          (product.qty),
          (product.price)
        ])!
            .then((value) {
          // controller.updateItem(index, value as Product);
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(product.productName!),
              Text("${product.price}"),
              Row(
                children: [
                  IconButton(
                      color: Colors.black,
                      onPressed: () {
                        if (product.qty! > 1) {
                          _productController.updateQty(
                              product.id!, product.qty! - 1);
                        }
                      },
                      icon: const Icon(Icons.remove)),
                  Text("${product.qty}"),
                  IconButton(
                      color: Colors.black,
                      onPressed: () {
                        if (product.qty! >= 1) {
                          _productController.updateQty(
                              product.id!, product.qty! + 1);
                        }
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
