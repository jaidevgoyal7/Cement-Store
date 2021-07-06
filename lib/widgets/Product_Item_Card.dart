import '../provider/Auth_Provider.dart';

import '../provider/Cart_Provider.dart';
import '../provider/Product_Provider.dart';
import '../screens/Product_Detail_Screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scafflod = Scaffold.of(context);
    final productData = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final cartData = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    final authData = Provider.of<AuthProvider>(
      context,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTile(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ProductDetailScreen.routeName,
                      arguments: productData.id,
                    );
                  },
                  child: Hero(
                    tag: productData.id,
                    child: FadeInImage(
                      placeholder: AssetImage(
                        'images/placeholder-image.jpg',
                      ),
                      image: NetworkImage(
                        productData.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                header: GridTileBar(
                  backgroundColor: Colors.black87,
                  title: Text(
                    productData.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  trailing: Consumer<ProductProvider>(
                    builder: (context, productData, _) => IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        cartData.addItems(
                          productData.id,
                          productData.title,
                          productData.price,
                          productData.imageUrl,
                        );
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added to the Cart !'),
                            duration: Duration(
                              seconds: 2,
                            ),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                try {
                                  cartData.removeSingleItem(productData.id);
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                footer: GridTileBar(
                  backgroundColor: Colors.black87,
                  title: Text(
                    '\u20B9${double.parse((productData.price).toStringAsFixed(2))}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  trailing: Consumer<ProductProvider>(
                    builder: (context, productData, _) => IconButton(
                      icon: Icon(
                        productData.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        productData.toggleFavorite(
                            authData.token, authData.userId);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
