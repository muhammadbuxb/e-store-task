class Product {
  final String name;
  final String image;
  final double rating;
  final double price;

  Product({
    required this.name,
    required this.image,
    required this.rating,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      image: json['image'],
      rating: json['rating'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'rating': rating,
      'price': price,
    };
  }
}
