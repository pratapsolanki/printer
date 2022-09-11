import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printer/app/data/product.dart';
import 'package:printer/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Management'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Center(
              child: controller.cartItems.isNotEmpty
                  ? generateList(context)
                  : const Text("No item present"),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var results = await Get.toNamed(Routes.ADD) as Product;
          debugPrint(results.productName);
          controller.addToCart(results);
        },
      ),
    );
  }

  Widget generateList(BuildContext context) {
    return ListView.builder(
        itemCount: controller.cartItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                controller.deleteItem(index);
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

  Widget cardItem(int index) {
    return Card(
      child: ListTile(
          isThreeLine: true,
          leading: Text("Qty ${controller.cartItems[index].qty}"),
          onTap: () {
            debugPrint("$index");
          },
          title: Text(controller.cartItems[index].productName),
          subtitle: Text("${controller.cartItems[index].price}"),
          trailing: IconButton(
              color: Colors.black,
              onPressed: () {
                var product = controller.cartItems[index];
                product.qty = product.qty + 1;
                debugPrint(product.toString());
                controller.updateItem(index, product);
              },
              icon: const Icon(Icons.add))),
    );
  }

  Widget cardItemRow(int index) {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(Routes.EDIT, arguments: [
          (controller.cartItems[index].productName),
          (controller.cartItems[index].qty),
          (controller.cartItems[index].price)
        ])!
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
              Text(controller.cartItems[index].productName),
              Text("${controller.cartItems[index].price}"),
              Row(
                children: [
                  IconButton(
                      color: Colors.black,
                      onPressed: () {
                        var product = controller.cartItems[index];
                        product.qty = product.qty - 1;
                        debugPrint(product.toString());
                        controller.updateItem(index, product);
                      },
                      icon: const Icon(Icons.remove)),
                  Text("${controller.cartItems[index].qty}"),
                  IconButton(
                      color: Colors.black,
                      onPressed: () {
                        var product = controller.cartItems[index];
                        product.qty = product.qty + 1;
                        debugPrint(product.toString());
                        controller.updateItem(index, product);
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
