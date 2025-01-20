import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}

// Forma Global
  // bool _showOnlyFavorites = false;

  // List<Product> get items {
  //   if (_showOnlyFavorites) {
  //     return _items.where((product) => product.isFavorite).toList();
  //   } else {
  //     return [..._items];
  //   }
  // }

  // void showOnlyFavorites() {
  //   _showOnlyFavorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showOnlyFavorites = false;
  //   notifyListeners();
  // }
