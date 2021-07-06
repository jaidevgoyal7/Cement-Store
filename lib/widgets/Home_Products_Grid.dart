import '../provider/Products_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/Product_Item_Card.dart';

class HomeProductsGrid extends StatelessWidget {
  final bool showOnlyFavorite;
  HomeProductsGrid(this.showOnlyFavorite);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        showOnlyFavorite ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItemCard(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
