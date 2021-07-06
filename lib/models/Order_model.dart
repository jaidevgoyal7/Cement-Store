import 'package:flutter/foundation.dart';
import '../provider/Cart_Provider.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartItems> products;
  final DateTime dateTime;

  OrderModel({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
