import 'package:flutter/material.dart';
import 'package:myshop_udemy/models/product.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrl = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImgUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrl.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImgUrl);
    super.initState();
  }

  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrl.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void updateImgUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrl.text.isEmpty ||
          !_imageUrl.text.startsWith('http') &&
              !_imageUrl.text.startsWith('https')) {
        return;
      }

      setState(() {});
    }
  }

  _saveForm() async {
    print('onsave start');
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id.isEmpty) {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((err) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Okey'))
            ],
          ),
        );
      }).then((_) {
        Navigator.of(context).pop();
      });
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });

    //   Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            id: _editedProduct.id,
                            title: value!,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value!),
                            imageUrl: _editedProduct.imageUrl);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      // textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrl.text.isEmpty
                              ? Text(
                                  'Enter a URL',
                                )
                              : FittedBox(
                                  child: Image.network(_imageUrl.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _imageUrlFocusNode,
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrl,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  isFavorite: _editedProduct.isFavorite,
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value!);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL';
                              }

                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter valid URL';
                              }

                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
