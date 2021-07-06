import 'package:flutter/foundation.dart';
import '../models/Order_model.dart';
import './Cart_Provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  List<OrderModel> get orders {
    return [..._orders];
  }

  String authToken;
  String userId;

  OrdersProvider(this.authToken, this.userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://cement-store-acfd9-default-rtdb.firebaseio.com/usersOrders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<OrderModel> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.insert(
          0,
          OrderModel(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (e) => CartItems(
                    id: e['id'],
                    price: e['price'],
                    quantity: e['quantity'],
                    title: e['title'],
                    imageUrl: e['imageUrl'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItems> cartProduct, double total) async {
    final url = Uri.parse(
        'https://cement-store-acfd9-default-rtdb.firebaseio.com/usersOrders/$userId.json?auth=$authToken');
    try {
      final dateTimeStamp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': dateTimeStamp.toIso8601String(),
          'products': cartProduct
              .map((cartValue) => {
                    'id': cartValue.id,
                    'title': cartValue.title,
                    'price': cartValue.price,
                    'imageUrl': cartValue.imageUrl,
                    'quantity': cartValue.quantity,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderModel(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProduct,
          dateTime: dateTimeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
