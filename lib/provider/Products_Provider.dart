import 'dart:io';

import '../models/Http_Exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Product_Provider.dart';
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _items = []; //DummyProducts().dummyProducts

  String authToken;
  String userID;

  ProductsProvider(this.authToken, this.userID, this._items);

  List<ProductProvider> get items {
    return [..._items]; // A copy of items
  }

  ProductProvider findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<ProductProvider> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userID"' : '';
    var url = Uri.parse(
      'https://cement-store-acfd9-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString',
    );
    // print(authToken);
    try {
      final response = await http.get(
        url,
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
        'https://cement-store-acfd9-default-rtdb.firebaseio.com/usersFavorite/$userID.json?auth=$authToken',
      );
      final favoriteResponse = await http.get(
        url,
      );
      final favoriteData = json.decode(favoriteResponse.body);
      final List<ProductProvider> loadedProductsData = [];
      extractedData.forEach((productId, productData) {
        loadedProductsData.add(
          ProductProvider(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[productId] ?? false,
          ),
        );
      });
      _items = loadedProductsData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(ProductProvider product) async {
    final url = Uri.parse(
      'https://cement-store-acfd9-default-rtdb.firebaseio.com/products.json?auth=$authToken',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'userId': userID,
            // 'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProduct = ProductProvider(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, ProductProvider newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
        'https://cement-store-acfd9-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken',
      );
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> delteProduct(String id) async {
    final url = Uri.parse(
      'https://cement-store-acfd9-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken',
    );
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
