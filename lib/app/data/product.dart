class Product {
  int id;
  String productName;
  String productImage;
  String productDescription;
  double price;
  int qty;

  Product(
      {required this.id,
      required this.productName,
      required this.productImage,
      required this.productDescription,
      required this.price,
      required this.qty});

  @override
  String toString() {
    return 'Product{id: $id, productName: $productName, productImage: $productImage, productDescription: $productDescription, price: $price, qty: $qty}';
  }
}
