import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.amount,
    @required this.dateTime,
    @required this.id,
    @required this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;

  Order(this.authToken, this._orders, this.userId);

  Future<void> fetchOrders() {
    var url =
        'https://se-flut.firebaseio.com/Orders/$userId.json?auth=$authToken';
    return http.get(url).then((res) {
      final List<OrderItem> fetchedOrders = [];
      final fetchedData = json.decode(res.body) as Map<String, dynamic>;
      if (fetchedData == null) {
        return;
      }
      fetchedData.forEach((orderId, orderData) {
        fetchedOrders.add(OrderItem(
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          id: orderId,
          products: (orderData['products'] as List<dynamic>)
              .map(
                (val) => CartItem(
                  id: val['id'],
                  price: val['price'],
                  quantity: val['quantity'],
                  title: val['title'],
                  imageUrl: val['imageUrl'],
                ),
              )
              .toList(),
        ));
      });
      _orders = fetchedOrders.reversed.toList();
      notifyListeners();
    }).catchError((err) {
      print(err);
    });
  }
  //PAY ATTETION! this .map((val) => CartItem() format got me debug for so long
  //this format is different from calling a function

  Future<void> addOrder(List<CartItem> cartProducts, double total) {
    var url =
        'https://se-flut.firebaseio.com/Orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    return http
        .post(url,
            body: json.encode({
              'amount': total,
              'dateTime': timeStamp.toIso8601String(),
              'products': cartProducts
                  .map((val) => {
                        'id': val.id,
                        'title': val.title,
                        'quantity': val.quantity,
                        'imageUrl': val.imageUrl,
                        'price': val.price,
                      })
                  .toList(),
            }))
        .then((res) {
      _orders.insert(
        0,
        OrderItem(
          amount: total,
          dateTime: timeStamp,
          id: json.decode(res.body)['name'],
          products: cartProducts,
        ),
      );
      notifyListeners();
    }).catchError((err) {
      throw err;
    });
  }
}
