class Product {
  final String title;
  final String? imageUrl;
  final String? onlineStoreUrl;
  final String price;
  final String? compareAtPrice;

  Product({
    required this.title,
    this.imageUrl,
    this.onlineStoreUrl,
    required this.price,
    this.compareAtPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final variants = json["variants"]?["edges"] as List? ?? [];
    final variantNode = variants.isNotEmpty ? variants[0]["node"] : null;

    final images = json["images"]?["edges"] as List? ?? [];
    final imageNode = images.isNotEmpty ? images[0]["node"] : null;

    final handle = json["handle"];

    return Product(
      title: json["title"] ?? "Untitled",
      onlineStoreUrl: json["onlineStoreUrl"] ??
          "https://stikky-dev-assessment.myshopify.com/products/$handle",
      imageUrl: imageNode?["url"],
      price: variantNode != null
          ? "${variantNode["price"]["amount"]} ${variantNode["price"]["currencyCode"]}"
          : "N/A",
      compareAtPrice: variantNode?["compareAtPrice"] != null
          ? "${variantNode["compareAtPrice"]["amount"]} ${variantNode["compareAtPrice"]["currencyCode"]}"
          : null,
    );
  }



}
