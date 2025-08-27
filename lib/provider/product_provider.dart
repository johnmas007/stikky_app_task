import 'package:flutter/material.dart';
import '../controller/product_controller.dart';
import '../model/product.dart';

class ProductProvider with ChangeNotifier {
  final ProductController _controller = ProductController();

  List<Product> _products = [];
  List<Product> get products => _products;

  String? _endCursor;
  bool _hasNextPage = true;
  bool get hasNextPage => _hasNextPage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadInitialProducts() async {
    _isLoading = true;
    notifyListeners();

    final response = await _controller.fetchProducts();
    _products = response["products"];
    _endCursor = response["endCursor"];
    _hasNextPage = response["hasNextPage"];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreProducts() async {
    if (!_hasNextPage || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    final response = await _controller.fetchProducts(cursor: _endCursor);
    _products.addAll(response["products"]);
    _endCursor = response["endCursor"];
    _hasNextPage = response["hasNextPage"];

    _isLoading = false;
    notifyListeners();
  }
}
