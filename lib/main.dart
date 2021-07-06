import './Page_Route_Transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/Splash_Screen.dart';
import './provider/Auth_Provider.dart';
import './screens/Auth_Screen.dart';
import './provider/Orders_Provider.dart';
import './screens/Cart_Screen.dart';
import './provider/Cart_Provider.dart';
import './provider/Products_Provider.dart';
import './screens/Product_Detail_Screen.dart';
import './screens/Home_Products_Screen.dart';
import './screens/Orders_Screen.dart';
import './screens/User_Products_Screen.dart';
import './screens/Edit_Product_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: null,
          update: (context, authData, previousData) => ProductsProvider(
            authData.token,
            authData.userId,
            previousData == null ? [] : previousData.items,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: null,
          update: (context, authData, previousOrders) => OrdersProvider(
            authData.token,
            authData.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
        ChangeNotifierProxyProvider2<AuthProvider, ProductsProvider,
            CartProvider>(
          create: null,
          update: (context, authData, productsData, previousCartData) =>
              CartProvider(
            authData.token,
            authData.userId,
            productsData,
            previousCartData == null ? {} : previousCartData.items,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Color.fromRGBO(35, 47, 52, 1),
            accentColor: Color.fromRGBO(249, 170, 51, 1),
            bottomAppBarColor: Color.fromRGBO(35, 47, 52, 1),
            // hoverColor: Color.fromRGBO(249, 170, 51, 1),
            // splashColor: Color.fromRGBO(249, 170, 51, 1),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          home: authData.isAuth
              ? HomeProductsScreen()
              : FutureBuilder(
                  future: authData.tryautoLogin(),
                  builder: (context, snap) =>
                      snap.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
