class Product {
  int? id;
  String? productName;
  String? productImage;
  double? price;
  String? productDescription;
  int? qty;
  String? date;

  Product(
      {this.id,
      this.productName,
      this.productImage,
      this.price,
      this.date,
      this.productDescription,
      this.qty});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    productImage = json['productImage'];
    price = json['price'];
    date = json['date'];
    productDescription = json['productDescription'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productName'] = productName;
    data['productImage'] = productImage;
    data['price'] = price;
    data['date'] = date;
    data['productDescription'] = productDescription;
    data['qty'] = qty;
    return data;
  }
}
