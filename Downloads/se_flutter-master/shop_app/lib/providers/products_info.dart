import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  //mixins is like extend with existing class, emerge some property while do not return that class as an instance
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  //In order to call notifylisteners, we cannot modify the _items directly but have to use a getter to get a copy of that
  //Because _items is reference to its pointer, we in order to notify listeners we have to make changes inside the class
  //while changes in _items is in memory
  bool _showFavedOnly = false;
  final String authToken;
  final String userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> get favedItems {
    return _items.where((element) => element.isFaved).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void showFavedOnly() {
    _showFavedOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavedOnly = false;
    notifyListeners();
  }

  Future<void> fetchProduct() {
    var url = 'https://se-flut.firebaseio.com/Products.json?auth=$authToken';
    return http.get(url).then((res) {
      final fetchedData = json.decode(res.body) as Map<String, dynamic>;
      if (fetchedData == null) {
        return;
      }
      url =
          'https://se-flut.firebaseio.com/UserFavorites/$userId.json?auth=$authToken';
      http.get(url).then((res) {
        final fetchedFavData = json.decode(res.body);
        final List<Product> fetchedProducts = [];
        fetchedData.forEach((prodId, prodData) {
          fetchedProducts.add(Product(
            description: prodData['description'],
            id: prodId,
            imageUrl: prodData['imageUrl'],
            price: double.parse(prodData['price'].toString()),
            title: prodData['title'],
            isFaved: fetchedFavData == null
                ? false
                : fetchedFavData[prodId] == null
                    ? false
                    : fetchedFavData[prodId],
          ));
        });
        _items = fetchedProducts;
        notifyListeners();
      });
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> addProduct(Product prod) {
    //don't put all those heavy logic in the widget, but a provider
    var url = 'https://se-flut.firebaseio.com/Products.json?auth=$authToken';
    return http
        .post(url,
            body: json.encode({
              'description': prod.description,
              'imageUrl': prod.imageUrl,
              'price': prod.price,
              'title': prod.title,
            }))
        .then((res) {
      final newProduct = Product(
        description: prod.description,
        id: json.decode(res.body)['name'],
        imageUrl: prod.imageUrl,
        price: prod.price,
        title: prod.title,
      );
      //add it at the top of the list so that new item can be loaded first
      _items.insert(0, newProduct);

      notifyListeners();
    }).catchError((err) {
      throw err;
    });
    //we should work with the same id in backend and frontend
  }

  Future<void> updateProduct(String id, Product newProd) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final url =
          'https://se-flut.firebaseio.com/Products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'description': newProd.description,
            'imageUrl': newProd.imageUrl,
            'price': newProd.price,
            'title': newProd.title,
          }));
      _items[index] = newProd;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://se-flut.firebaseio.com/Products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete this product. Try again later');
    }
    existingProduct = null;
  }
}
