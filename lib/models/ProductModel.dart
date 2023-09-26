// ignore_for_file: file_names

class ProductModel {
  String model;
  String description;
  String category;
  bool used;
  double? price;
  int? quantity;
  String? image;
  String? abbreviation;
  Set? compatibility;
  String? note;

  ProductModel({
    required this.model,
    required this.description,
    required this.category,
    required this.used,
    this.price,
    this.quantity,
    this.image,
    this.abbreviation,
    this.compatibility,
    this.note,
  });

  factory ProductModel.fromFireStoreDB(dynamic data) {
    return ProductModel(
      model: data['model'],
      description: data['description'],
      category: data['category'],
      used: data['used'],
      price: data['price'],
      quantity: data['quantity'],
      image: data['image'],
      abbreviation: data['abbreviation'],
      compatibility: data['compatibility'] == null ? null : data['compatibility'].toSet(),
      note: data['note'],
    );
  }
}
