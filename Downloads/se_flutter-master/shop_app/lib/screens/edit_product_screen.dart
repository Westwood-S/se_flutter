import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_info.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  //globalkey is for accessing items inside a widget
  var _editedProduct = Product(
    description: '',
    id: null,
    imageUrl: '',
    price: 0,
    title: '',
  );

  //ModalRoute.of(context).settings.arguments doesnt work in initState
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  //the whole package is for updating a product
  var _initVal = {
    'description': '',
    'id': '',
    'imageUrl': '',
    'price': '',
    'title': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    //isInit: Because this function will run multiple time and we only want this once
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);

        _initVal = {
          'description': _editedProduct.description,
          'imageUrl': '',
          'price': _editedProduct.price.toString(),
          'title': _editedProduct.title,
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    } else {}
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValidated = _form.currentState.validate();
    if (!isValidated) {
      return;
    }
    _form.currentState.save(); //take all values inside textfields

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct)
          .catchError((err) {})
          .then((_) {
        setState(() {
          _isLoading = true;
          Navigator.of(context).pop();
        });
      });
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((err) {
        return showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Something went wrong. Sorry.'),
                  content: Text(err.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
      //catch err itself can turn a future so the 'then' after it will also be excuted
      //but since we have to wait customer to answer that dialog box, and showdialog also can return a future, so we have to put return before that
    }

    //leave this page after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'title'),
                        textInputAction: TextInputAction.next,
                        initialValue: _initVal['title'],
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Plz fill them all!';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: val,
                            isFaved: _editedProduct.isFaved,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'price'),
                        initialValue: _initVal['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Plz fill them all!';
                          }
                          if (double.tryParse(val) == null) {
                            return 'Solid price okay?';
                          }
                          if (double.parse(val) < 0) {
                            return 'Can\'t give this money to you.';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(val),
                            title: _editedProduct.title,
                            isFaved: _editedProduct.isFaved,
                          );
                        },
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'description'),
                          initialValue: _initVal['description'],
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Plz fill them all!';
                            }
                            if (val.length < 10) {
                              return 'Tell me more about it.';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _editedProduct = Product(
                              description: val,
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              title: _editedProduct.title,
                              isFaved: _editedProduct.isFaved,
                            );
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 10, right: 10),
                            child: _imageController.text.isEmpty
                                ? Text('')
                                : FittedBox(
                                    child: Image.network(_imageController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                                decoration: InputDecoration(labelText: 'pic'),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                //this is for show this picture in the fitted box
                                controller: _imageController,
                                focusNode: _imageFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Plz fill them all!';
                                  }
                                  if (!val.startsWith('http') &&
                                      !val.startsWith('https')) {
                                    return 'Just gimme a URL';
                                  }
                                  if (!val.endsWith('png') &&
                                      !val.endsWith('jpeg') &&
                                      !val.endsWith('jpg') &&
                                      !val.endsWith('gif') &&
                                      !val.endsWith('pdf')) {
                                    return 'Can\'t process this \'image\'';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  _editedProduct = Product(
                                    description: _editedProduct.description,
                                    id: _editedProduct.id,
                                    imageUrl: val,
                                    price: _editedProduct.price,
                                    isFaved: _editedProduct.isFaved,
                                    title: _editedProduct.title,
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
