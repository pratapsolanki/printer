import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printer/app/data/product.dart';
import 'package:printer/app/routes/app_pages.dart';

import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Print Management'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Center(
              child: controller.productList.isNotEmpty
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
                child: Text("Total ${controller.totalPrice}")),
          ),
          ElevatedButton(onPressed: () async {}, child: const Text("Print")),
          ElevatedButton(
              onPressed: () async {
                await Get.toNamed(Routes.ADD)?.then((value) {
                  debugPrint("inserted callback");
                  controller.getTasks();
                });
              },
              child: const Text("Add Product"))
        ],
      ),
    );
  }

  Widget generateList(BuildContext context) {
    return ListView.builder(
        itemCount: controller.productList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                controller.delete(controller.productList[index]);
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
    Product product = controller.productList[index];

    return GestureDetector(
      onTap: () async {
        await Get.toNamed(
          Routes.EDIT,
          arguments: product,
        )?.then((value) => {controller.getTasks()});
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
                          controller.updateQty(product.id!, product.qty! - 1);
                        }
                      },
                      icon: const Icon(Icons.remove)),
                  Text("${product.qty}"),
                  IconButton(
                      color: Colors.black,
                      onPressed: () {
                        if (product.qty! >= 1) {
                          controller.updateQty(product.id!, product.qty! + 1);
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
