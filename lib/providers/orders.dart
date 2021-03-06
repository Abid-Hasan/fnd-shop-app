import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        "https://fnd-shop-app-default-rtdb.firebaseio.com/orders/${userId}.json?auth=$token");

    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    List<OrderItem> loadedOrders = [];
    if (extractedData != null) {
      extractedData.forEach((key, value) {
        loadedOrders.add(
          OrderItem(
            id: key,
            amount: value["amount"],
            dateTime: DateTime.parse(value["dateTime"]),
            products: (value["products"] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item["id"],
                    title: item["title"],
                    quantity: item["quantity"],
                    price: item["price"],
                  ),
                )
                .toList(),
          ),
        );
      });
    }
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://fnd-shop-app-default-rtdb.firebaseio.com/orders/${userId}.json?auth=$token");
    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quantity": cp.quantity,
                    "price": cp.price,
                  })
              .toList()
        }));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)["name"],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );

    notifyListeners();
  }
}
