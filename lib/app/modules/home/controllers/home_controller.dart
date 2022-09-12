import 'package:get/get.dart';

import '../../../data/product.dart';

class HomeController extends GetxController {
  var cartItems = [
    Product(
        id: 1,
        price: 30,
        productDescription: 'some description about product',
        productImage: 'abd',
        productName: 'FirstProd',
        qty: 1),
    Product(
        id: 2,
        price: 40,
        productDescription: 'some description about product',
        productImage: 'abd',
        productName: 'SecProd',
        qty: 1),
    Product(
        id: 3,
        price: 49.5,
        productDescription: 'some description about product',
        productImage: 'abd',
        productName: 'ThirdProd',
        qty: 1),
  ].obs;

  int get count => cartItems.length;

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price! * item.qty!));

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  addToCart(Product product) {
    cartItems.add(product);
  }

  void deleteItem(int pos) {
    cartItems.removeAt(pos);
  }

  void updateItem(int pos, Product product) {
    cartItems[pos] = product;
  }

  void clearAll() {
    cartItems.clear();
  }
}
