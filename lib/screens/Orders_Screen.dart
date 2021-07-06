import '../provider/Orders_Provider.dart';
import 'package:flutter/material.dart';
import '../widgets/Bottom_Drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/Order_Item_Card.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/ordersScreen';

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          'My Orders',
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      bottomNavigationBar: BottomDrawer(),
      floatingActionButton: FloatingCartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: FutureBuilder(
        future: Provider.of<OrdersProvider>(
          context,
          listen: false,
        ).fetchAndSetOrders(),
        builder: (context, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapShot.error != null) {
              return Center(
                child: Text(
                  'Something went wrong!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return Consumer<OrdersProvider>(
                builder: (context, ordersData, child) => ListView.builder(
                  itemBuilder: (context, index) => OrderItemCard(
                    ordersData.orders[index],
                  ),
                  itemCount: ordersData.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
