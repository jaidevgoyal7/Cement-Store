import '../provider/Cart_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final int index;
  CartItemCard(this.index);
  @override
  Widget build(BuildContext context) {
    final scafflod = Scaffold.of(context);
    final cartData = Provider.of<CartProvider>(context);
    return Dismissible(
      key: ValueKey(cartData.items.values.toList()[index].id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure ?',
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'Do you want to remove the item from the cart ?',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        try {
          cartData.removeItem(cartData.items.keys.toList()[index]);
        } catch (error) {
          scafflod.showSnackBar(
            SnackBar(
              duration: Duration(
                seconds: 1,
              ),
              content: Text(
                'Deleting failed!',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Container(
              width: 60,
              child: Image.network(
                cartData.items.values.toList()[index].imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              '${cartData.items.values.toList()[index].title} - \u20B9${double.parse((cartData.items.values.toList()[index].price).toStringAsFixed(2))}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              ),
              softWrap: true,
            ),
            subtitle: Container(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(
                  'Total - \u20B9${double.parse((cartData.items.values.toList()[index].price * cartData.items.values.toList()[index].quantity).toStringAsFixed(2))}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
                backgroundColor: Theme.of(context).accentColor,
              ),
            ),
            trailing: Text(
              'x ${cartData.items.values.toList()[index].quantity}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              ),
              // textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
