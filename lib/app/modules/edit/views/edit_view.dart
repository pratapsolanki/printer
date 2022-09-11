import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/product.dart';
import '../controllers/edit_controller.dart';

class EditView extends GetView<EditController> {
  EditView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _productName = TextEditingController();
  final _qty = TextEditingController();
  final _price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _productName.text = Get.arguments[0];
    _qty.text = Get.arguments[1].toString();
    _price.text = Get.arguments[2].toString();
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Get.back(
                        result: Product(
                            id: 1,
                            productName: _productName.text.trim(),
                            productImage: _productName.text.trim(),
                            productDescription: "productDescription",
                            price: double.parse(_price.text.trim()),
                            qty: int.parse(_qty.text.trim())));
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
