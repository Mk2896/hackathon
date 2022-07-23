class Cart {
  const Cart({
    required this.productId,
    required this.name,
    required this.userName,
    required this.photoURL,
    required this.price,
  });

  Cart.fromJson(Map<String, Object?> json)
      : this(
          productId: json['productId'] as String,
          name: json['name'] as String,
          userName: json['userName'] as String,
          photoURL: json['photoURL'] as String,
          price: json['price'] as String,
        );

  final String productId;
  final String name;
  final String userName;
  final String photoURL;
  final String price;

  Map<String, Object?> toJson() {
    return {
      'productId': productId,
      'name': name,
      'userName': userName,
      'photoURL': photoURL,
      'price': price,
    };
  }
}
