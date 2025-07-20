enum Gender { men, women, unisex }

class Product {
  final String id;
  final String title;
  final double price;
  final String imageAsset;
  final Gender gender;
  final String name;
  final String imagePath;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageAsset,
    required this.gender,
    required this.name,
    required this.imagePath,
  });
}
