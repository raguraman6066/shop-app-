import 'package:flutter/material.dart';
import 'package:myshop_udemy/provider/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shop-app-d63df-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((key, value) {
      loadedOrders.add(OrderItem(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map((e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price']))
              .toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });
    _orders = loadedOrders.reversed.toList();
  }

  Future<void> addOrder(
      {required double total, required List<CartItem> cartProducts}) async {
    final url =
        'https://shop-app-d63df-default-rtdb.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ));
    notifyListeners();
  }
}
