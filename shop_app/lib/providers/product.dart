import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  //extends is inherite while with is mixin
  //this is for notify when the product is faved
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFaved;

  Product({
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    this.isFaved = false,
    @required this.price,
    @required this.title,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFaved;
    isFaved = !isFaved;
    notifyListeners();

    final url =
        'https://se-flut.firebaseio.com/UserFavorites/$userId/$id.json?auth=$token';
    await http
        .put(url,
            body: json.encode(
              isFaved,
            ))
        .then((res) {
      if (res.statusCode >= 400) {
        isFaved = oldStatus;
        notifyListeners();
      }
    }).catchError((err) {
      isFaved = oldStatus;
      notifyListeners();
      //without notifylistener this can't be updated
    });
  }
  //for patch, delete, it won't throw error
}
