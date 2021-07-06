import '../provider/Cart_Provider.dart';
import '../provider/Products_Provider.dart';
import '../provider/Auth_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final authData = Provider.of<AuthProvider>(
      context,
    );
    final productDetail = Provider.of<ProductsProvider>(
      context,
      listen:
          false, // It is set to false because we don't want to re-built this page whenever new product is added.
    ).findById(productId);
    final cartData = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      // appBar: AppBar(
      //   iconTheme: IconThemeData(
      //     color: Theme.of(context).accentColor,
      //   ),
      //   title: Text(
      //     productDetail.title,
      //     textAlign: TextAlign.center,
      //     style: TextStyle(
      //       color: Theme.of(context).accentColor,
      //     ),
      //   ),
      // ),

      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                productDetail.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              background: Hero(
                tag: productDetail.id,
                child: Image.network(
                  productDetail.imageUrl,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  // height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: Center(
                          child: Text(
                            productDetail.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: 50,
                          decoration: BoxDecoration(
                            color: productDetail.isFavorite
                                ? Colors.orange.shade100
                                : Color(0xFFF5F6F9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              productDetail.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_sharp,
                              size: 30,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              setState(() {
                                productDetail.toggleFavorite(
                                    authData.token, authData.userId);
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                        ),
                        child: Text(
                          productDetail.description,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Consumer<ProductsProvider>(
                          builder: (context, productsData, _) =>
                              FloatingActionButton.extended(
                            onPressed: () {
                              cartData.addItems(
                                productDetail.id,
                                productDetail.title,
                                productDetail.price,
                                productDetail.imageUrl,
                              );
                            },
                            label: Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            backgroundColor: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        // child: Column(
        //   children: <Widget>[
        //     SizedBox(
        //       width: double.infinity,
        //       child: AspectRatio(
        //         aspectRatio: 1,
        //         child:
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
