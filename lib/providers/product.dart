import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String productId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.productId,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite(String token, String userId) {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        "https://fnd-shop-app-default-rtdb.firebaseio.com/userFavorites/${userId}/${productId}.json?auth=$token");
    http
        .put(
      url,
      body: json.encode(
        isFavorite,
      ),
    )
        .then((response) {
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    }).catchError((error) {
      isFavorite = oldStatus;
      notifyListeners();
    });
  }
}
