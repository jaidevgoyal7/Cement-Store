import '../models/Order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItemCard extends StatefulWidget {
  final OrderModel orders;
  OrderItemCard(this.orders);

  @override
  _OrderItemCardState createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 300,
      ),
      height: _expanded
          ? min(widget.orders.products.length * 20.0 + 110, 200)
          : 100,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    'Total - ',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Chip(
                      label: Text(
                        '\u20B9${widget.orders.amount}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy - ')
                    .add_jm()
                    .format(widget.orders.dateTime),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).accentColor,
                  size: 35,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            // AnimatedContainer(
            //   duration: Duration(
            //     milliseconds: 300,
            //   ),
            //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            //   height: _expanded
            //       ? min(widget.orders.products.length * 20.0 + 10, 100)
            //       : 0,
            //   child: Column(
            //     children: <Widget>[
            //       Divider(),
            AnimatedContainer(
              duration: Duration(
                milliseconds: 300,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              height: _expanded
                  ? min(widget.orders.products.length * 20.0 + 10, 100)
                  : 0,
              child: ListView(
                children: widget.orders.products
                    .map(
                      (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            e.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            '${e.quantity}x \u20B9${e.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      //     ],
      //   ),
      // ),
    );
  }
}
