import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/errors/http_exception.dart';

class Product with ChangeNotifier {
  final _baseUrl = 'https://shop-udemy-4285f-default-rtdb.firebaseio.com';

  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.patch(
      Uri.parse('$_baseUrl/products/$id.json'),
      body: jsonEncode({
        "name": name,
        "description": description,
        "price": price,
        "imageUrl": imageUrl,
        "isFavorite": isFavorite,
      }),
    );

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();

      throw HttpException(
          msg: 'Não foi possível salvar como favorito :(',
          statusCode: response.statusCode);
    }
  }
}
