import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/Bottom_Drawer.dart';
import '../provider/Products_Provider.dart';
import '../widgets/User_Products_Item_Card.dart';
import './Edit_Product_Screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/UserProductScreen';

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          'My Products',
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomDrawer(),
      floatingActionButton: FloatingCartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: FutureBuilder(
        future: _refreshPage(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.error != null
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
                    : RefreshIndicator(
                        onRefresh: () => _refreshPage(context),
                        child: Consumer<ProductsProvider>(
                          builder: (context, productsData, _) => Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(10),
                                  itemBuilder: (context, index) =>
                                      UserProductsItemCard(
                                    productsData.items[index].id,
                                    productsData.items[index].title,
                                    productsData.items[index].imageUrl,
                                  ),
                                  itemCount: productsData.items.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
