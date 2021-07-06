import '../provider/Products_Provider.dart';
import '../models/Http_Exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItems {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItems({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
    @required this.imageUrl,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItems> _items = {};

  Map<String, CartItems> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  String authToken;
  String userId;
  ProductsProvider loadedData;

  CartProvider(this.authToken, this.userId, this.loadedData, this._items);

  Future<void> fetchAndSetCart(BuildContext context) async {
    final url = Uri.parse(
      'https://cement-store-acfd9-default-rtdb.firebaseio.com/usersCart/$userId.json?auth=$authToken',
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print(extractedData);
      Map<String, CartItems> localentry = {};
      if (extractedData == null) {
        // _items = {};
        return;
      } else {
        _items = {};
        extractedData.forEach((key, value) {
          final loadedProduct = loadedData.findById(key);
          localentry[key] = CartItems(
            id: DateTime.now().toString(),
            price: loadedProduct.price,
            quantity: value,
            title: loadedProduct.title,
            imageUrl: loadedProduct.imageUrl,
          );
        });
        _items.addAll(localentry);
        notifyListeners();
      }
      localentry = {};
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItems(
      String productId, String title, double price, String imageUrl) async {
    final url = Uri.parse(
      'https://cement-store-acfd9-default-rtdb.firebaseio.com/usersCart/$userId/$productId.json?auth=$authToken',
    );
    try {
      final res = await http.get(url);
      final oldQuantity = json.decode(res.body);
      final response = await http.put(
        url,
        body: json.encode(
          oldQuantity == null ? 1 : (oldQuantity + 1),
        ),
      );
      if (_items.containsKey(productId)) {
        // change quantity...
        _items.update(
          productId,
          (value) => CartItems(
            id: value.id,
            price: value.price,
            quantity: json.decode(response.body),
            title: value.title,
            imageUrl: value.imageUrl,
          ),
        );
      } else {
        _items.putIfAbsent(
          productId,
          () => CartItems(
            id: DateTime.now().toString(),
            price: price,
            quantity: json.decode(response.body),
            title: title,
            imageUrl: imageUrl,
          ),
        );
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeSingleItem(String productId) async {
    final url = Uri.parse(
      'https://cement-store-acfd9-default-rtdb.firebaseio.com/usersCart/$userId/$productId.json?auth=$authToken',
    );

    final oldres = await http.get(url);
    final oldData = json.decode(oldres.body);
    if (oldData == 1) {
      final response = await http.delete(url);
      _items.remove(productId);
      notifyListeners();
    } else if (oldData > 1) {
      final response = await http.put(
        url,
        body: json.encode(oldData - 1),
      );
      _items.update(
        productId,
        (value) => CartItems(
          id: value.id,
          price: value.price,
          quantity: oldData - 1,
          title: value.title,
          imageUrl: value.imageUrl,
        ),
      );
      notifyListeners();
    }
  }

  Future<void> removeItem(String productId) async {
    final url = Uri.parse(
      'https://cement-store-acfd9-default-rtdb.firebaseio.com/usersCart/$userId/$productId.json?auth=$authToken',
    );
    Map<String, CartItems> localEntry = {};
    _items.forEach((key, value) {
      if (productId == key) {
        localEntry[key] = CartItems(
          id: value.id,
          price: value.price,
          quantity: value.quantity,
          title: value.title,
          imageUrl: value.imageUrl,
        );
      }
    });
    _items.remove(productId);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.addAll(localEntry);
      notifyListeners();
      throw HttpException('Could not delete this item');
    }
    localEntry = {};
  }

  Future<void> clear() async {
    final url = Uri.parse(
      'https://cement-store-acfd9-default-rtdb.firebaseio.com/usersCart/$userId.json?auth=$authToken',
    );
    final response = await http.delete(url);
    _items = {};
    notifyListeners();
  }
}
