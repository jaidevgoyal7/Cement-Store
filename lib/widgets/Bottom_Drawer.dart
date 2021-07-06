import 'package:Cement_Store/Page_Route_Transition.dart';
import 'package:flutter/material.dart';
import '../models/Bottom_Data_model.dart';
import 'package:provider/provider.dart';
import '../provider/Cart_Provider.dart';
import './Badge.dart';
import '../screens/Cart_Screen.dart';
import 'package:provider/provider.dart';
import '../provider/Auth_Provider.dart';

class BottomDrawer extends StatefulWidget {
  @override
  _BottomDrawerState createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      for (int i = 0; i < modalItems.length; i++) {
        if (ModalRoute.of(context).settings.name == modalItems[i]['route']) {
          modalItems[i]['active'] = true;
        } else
          modalItems[i]['active'] = false;
      }
    });
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: showMenu,
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  showMenu() {
    ShowMenu(context);
  }
}

class FloatingCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, cartData, ch) => Badge(
        child: ch,
        value: cartData.itemCount.toString(),
      ),
      child: FloatingActionButton(
        child: Icon(
          Icons.shopping_cart_sharp,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(CartScreen.routeName);
          // Navigator.of(context).push(
          //   CustomRoute(
          //     builder: (context) => CartScreen(),
          //   ),
          // );
        },
      ),
    );
  }
}

Widget ShowMenu(BuildContext context) {
  showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 36,
              ),
              SizedBox(
                height: (modalItems.length) * 80.toDouble(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: Color.fromRGBO(52, 73, 85, 1),
                  ),
                  child: Stack(
                    alignment: Alignment(0, 0),
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        top: -36,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 10,
                            ),
                          ),
                          child: Center(
                            child: ClipOval(
                              child: Image.network(
                                "https://st2.depositphotos.com/2931363/6819/i/600/depositphotos_68197553-stock-photo-handsome-young-man-making-selfie.jpg",
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        child: Text(
                          'Hello Jaidev!',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Positioned(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 75),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => ListTile(
                            title: Text(
                              modalItems[index]['name'],
                              style: TextStyle(
                                color: modalItems[index]['active']
                                    ? Theme.of(context).accentColor
                                    : Colors.white,
                                fontWeight: modalItems[index]['active']
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            leading: Icon(
                              modalItems[index]['icon'],
                              color: modalItems[index]['active']
                                  ? Theme.of(context).accentColor
                                  : Colors.white,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              modalItems[index]['route'] == ''
                                  ? Provider.of<AuthProvider>(
                                      context,
                                      listen: false,
                                    ).signOut()
                                  : Navigator.pushReplacementNamed(
                                      context,
                                      modalItems[index]['route'],
                                    );
                            },
                          ),
                          itemCount: modalItems.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                height: 48,
              ),
            ],
          ),
        );
      });
}
