import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length == null ? 0 : _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String id, String title, double price, String url) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (alreadyAddedItem) => CartItem(
          id: alreadyAddedItem.id,
          price: alreadyAddedItem.price,
          quantity: alreadyAddedItem.quantity + 1,
          title: alreadyAddedItem.title,
          imageUrl: alreadyAddedItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
          imageUrl: url,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productOrderId) {
    _items.remove(productOrderId);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (prod) => CartItem(
          id: prod.id,
          price: prod.price,
          quantity: prod.quantity - 1,
          title: prod.title,
          imageUrl: prod.imageUrl,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void placeOrder() {
    _items = {};
    notifyListeners();
  }
}
