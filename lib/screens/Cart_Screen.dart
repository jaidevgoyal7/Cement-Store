import '../provider/Orders_Provider.dart';
import '../widgets/Cart_Item_Card.dart';
import '../provider/Cart_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isInitial = true;
  var _isLoading = false;
  var _isError = false;

  @override
  void didChangeDependencies() async {
    if (_isInitial) {
      setState(() {
        _isLoading = true;
        _isError = false;
      });
      try {
        await Provider.of<CartProvider>(context)
            .fetchAndSetCart(context)
            .then((_) {
          setState(() {
            _isLoading = false;
            _isError = false;
          });
        });
      } catch (error) {
        setState(() {
          _isError = true;
        });
      }
    }
    _isInitial = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      body: (_isLoading && !_isError)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isError
              ? Center(
                  child: Text(
                    'Something went wrong!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Column(
                  children: <Widget>[
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(15),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Chip(
                              label: Text(
                                '\u20B9${double.parse((cartData.totalAmount).toStringAsFixed(2))}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                softWrap: true,
                              ),
                              backgroundColor: Theme.of(context).accentColor,
                            ),
                            OrderButton(cartData: cartData),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) =>
                            ChangeNotifierProvider.value(
                          value: cartData,
                          child: CartItemCard(index),
                        ),
                        itemCount: cartData.itemCount,
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final CartProvider cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartData.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrdersProvider>(
                context,
                listen: false,
              ).addOrder(
                widget.cartData.items.values.toList(),
                double.parse(
                  (widget.cartData.totalAmount).toStringAsFixed(2),
                ),
              );
              setState(() {
                _isLoading = false;
              });
              widget.cartData.clear();
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Place Order',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
      color: Theme.of(context).accentColor,
      // splashColor: Theme.of(context).primaryColor,
    );
  }
}
