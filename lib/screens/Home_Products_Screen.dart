import 'package:flutter/material.dart';
import '../widgets/Bottom_Drawer.dart';
import '../widgets/Home_Products_Grid.dart';
import 'package:provider/provider.dart';
import '../provider/Products_Provider.dart';

enum FilterPopUpOptions {
  Favorites,
  All,
}

class HomeProductsScreen extends StatefulWidget {
  @override
  _HomeProductsScreenState createState() => _HomeProductsScreenState();
}

class _HomeProductsScreenState extends State<HomeProductsScreen> {
  var _showOnlyFavorite = false;
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
        await Provider.of<ProductsProvider>(context)
            .fetchAndSetProducts()
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
    String x = 'Favorite Products';
    String y = 'All Products';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          'Cement Store - ${_showOnlyFavorite ? x : y}',
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            color: Theme.of(context).primaryColor,
            onSelected: (FilterPopUpOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterPopUpOptions.Favorites) {
                  _showOnlyFavorite = true;
                } else {
                  _showOnlyFavorite = false;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_bag,
                      color: _showOnlyFavorite
                          ? Colors.white
                          : Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Show All',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _showOnlyFavorite
                            ? Colors.white
                            : Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
                value: FilterPopUpOptions.All,
              ),
              PopupMenuItem(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: _showOnlyFavorite
                          ? Theme.of(context).accentColor
                          : Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Favorites',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _showOnlyFavorite
                            ? Theme.of(context).accentColor
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                value: FilterPopUpOptions.Favorites,
              ),
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomDrawer(),
      floatingActionButton: FloatingCartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: HomeProductsGrid(_showOnlyFavorite),
                      ),
                    ),
                  ],
                ),
    );
  }
}
