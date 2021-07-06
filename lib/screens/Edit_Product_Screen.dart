import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Product_Provider.dart';
import '../provider/Products_Provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var urlPattern =
      r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?\.(jpg|jpeg|png|gif)";
  final _priceFocus = FocusNode();
  final _titleFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = ProductProvider(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _isInitial = true;
  var _initialValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInitial) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initialValue = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    }
    _isInitial = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocus.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      try {
        await Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).updateProduct(_editedProduct.id, _editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'An error occurred!',
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
            content: Text(
              'Something went wrong.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Okay',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'An error occurred!',
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
            content: Text(
              'Something went wrong.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Okay',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Widget editDialog() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return null;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Are you completed with editing ?',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          'Before clicking on the save button please check the details carefully.',
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
              _saveForm();
              Navigator.of(context).pop(false);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusNode _currentFocus = FocusScope.of(context);
        if (!_currentFocus.hasPrimaryFocus) {
          _currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            'Edit Product',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                editDialog();
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _initialValue['title'],
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a title.';
                            } else if (value.startsWith('0') ||
                                value.startsWith('1') ||
                                value.startsWith('2') ||
                                value.startsWith('3') ||
                                value.startsWith('4') ||
                                value.startsWith('5') ||
                                value.startsWith('6') ||
                                value.startsWith('7') ||
                                value.startsWith('8') ||
                                value.startsWith('9')) {
                              return 'Should not start with numbers.';
                            } else if (value.startsWith('.') ||
                                value.startsWith('_') ||
                                value.startsWith('*') ||
                                value.startsWith('!') ||
                                value.startsWith('@') ||
                                value.startsWith('#') ||
                                value.startsWith('\$') ||
                                value.startsWith('%') ||
                                value.startsWith('^') ||
                                value.startsWith('&') ||
                                value.startsWith('(') ||
                                value.startsWith(')') ||
                                value.startsWith('-') ||
                                value.startsWith('=') ||
                                value.startsWith('+') ||
                                value.startsWith('/') ||
                                value.startsWith('<') ||
                                value.startsWith('>') ||
                                value.startsWith(';') ||
                                value.startsWith(':') ||
                                value.startsWith(',') ||
                                value.startsWith('"') ||
                                value.startsWith('\'') ||
                                value.startsWith('?') ||
                                value.startsWith('|') ||
                                value.startsWith('[') ||
                                value.startsWith(']') ||
                                value.startsWith('{') ||
                                value.startsWith('}') ||
                                value.startsWith('`') ||
                                value.startsWith('~')) {
                              return 'Should not start with special characters.';
                            } else if (value.startsWith(' ')) {
                              return 'Should not start with white space.';
                            }
                            return null;
                          },
                          focusNode: _titleFocus,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_priceFocus);
                          },
                          onSaved: (value) {
                            _editedProduct = ProductProvider(
                                id: _editedProduct.id,
                                title: value,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                price: _editedProduct.price,
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                        TextFormField(
                          initialValue: _initialValue['price'],
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a price.';
                            } else if (double.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            } else if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero.';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: 20),
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocus);
                          },
                          onSaved: (value) {
                            _editedProduct = ProductProvider(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                price: double.parse(value),
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                        TextFormField(
                          initialValue: _initialValue['description'],
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a description.';
                            } else if (value.length < 20) {
                              return 'Should be at least 20 characters long.';
                            } else if (value.startsWith(' ')) {
                              return 'Should not start with white space.';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: 20),
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocus,
                          onSaved: (value) {
                            _editedProduct = ProductProvider(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: value,
                                imageUrl: _editedProduct.imageUrl,
                                price: _editedProduct.price,
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 150,
                              height: 150,
                              margin: EdgeInsets.only(
                                top: 20,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: _imageController.text.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Enter a Url',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    )
                                  : FittedBox(
                                      child: Image.network(
                                        _imageController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                // initialValue: _imageController.text,
                                validator: (value) {
                                  var result = new RegExp(urlPattern,
                                          caseSensitive: false)
                                      .firstMatch(value);
                                  if (value.isEmpty) {
                                    return 'Please enter a imageUrl.';
                                  } else if (result == null) {
                                    return 'Please enter a valid imageUrl.';
                                  }
                                  return null;
                                },
                                style: TextStyle(fontSize: 20),
                                cursorColor: Theme.of(context).accentColor,
                                decoration: InputDecoration(
                                  labelText: 'ImageUrl',
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                controller: _imageController,
                                onEditingComplete: () {
                                  var result = new RegExp(urlPattern,
                                          caseSensitive: false)
                                      .firstMatch(_imageController.text);
                                  if (result == null) {
                                    return;
                                  }
                                  setState(() {});
                                },
                                onFieldSubmitted: (_) {
                                  editDialog();
                                },
                                onSaved: (value) {
                                  _editedProduct = ProductProvider(
                                      id: _editedProduct.id,
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      imageUrl: value,
                                      price: _editedProduct.price,
                                      isFavorite: _editedProduct.isFavorite);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
