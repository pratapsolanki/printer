import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printer/app/modules/product/controllers/product_controller.dart';

import '../../../data/product.dart';
import '../controllers/edit_controller.dart';

class EditView extends GetView<EditController> {
  EditView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _productName = TextEditingController();
  final _qty = TextEditingController();
  final _price = TextEditingController();

  final product = Get.arguments as Product;

  final _productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    debugPrint(product.toString());
    _productName.text = product.productName!;
    _qty.text = product.qty!.toString();
    _price.text = product.price!.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _productName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Product name',
                    labelText: 'Enter product name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: _qty,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Qty',
                            labelText: 'Enter Qty'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter qty';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Price',
                            labelText: 'Enter Price'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Price';
                          }
                          return null;
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    product.productName = _productName.text.trim();
                    product.productDescription = _productName.text.trim();
                    product.productImage = _productName.text.trim();
                    product.price = double.parse(_price.text.trim());
                    product.qty = int.parse(_qty.text.trim());
                    product.date = DateTime.now().toString();

                    debugPrint(product.toString());
                    await _productController
                        .updateProduct(product)
                        .then((value) => {Get.back(result: "updated")});
                  }
                },
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
