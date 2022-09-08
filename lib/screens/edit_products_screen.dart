import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/add-product';

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _imageURLController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageURL: '',
  );

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      if ((!_imageURLController.text.startsWith('http') &&
              !_imageURLController.text.startsWith('https')) ||
          (!_imageURLController.text.endsWith('png') &&
              !_imageURLController.text.endsWith('jpg') &&
              !_imageURLController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageURL);
    _imageURLController.dispose();
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
              onPressed: _saveForm,
              icon: Icon(
                Icons.save,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  validator: ((value) {
                    if (value.isEmpty) {
                      return 'Please provide a title';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: null,
                        title: value,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageURL: _editedProduct.imageURL);
                  },
                ),
                TextFormField(
                  validator: ((value) {
                    if (value.isEmpty) {
                      return 'Please provide a price value';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please neter a number greater than 0';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: null,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value),
                        imageURL: _editedProduct.imageURL);
                  },
                ),
                TextFormField(
                  validator: ((value) {
                    if (value.isEmpty) {
                      return 'Please provide a description';
                    }
                    if (value.length < 10) {
                      return 'Minimum 10 characters for description';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: null,
                        title: _editedProduct.title,
                        description: value,
                        price: _editedProduct.price,
                        imageURL: _editedProduct.imageURL);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageURLController.text.isEmpty
                          ? Text("Enter a URL")
                          : FittedBox(
                              child: Image.network(_imageURLController.text),
                              fit: BoxFit.contain,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: ((value) {
                          if (value.isEmpty) {
                            return 'Please provide a URL for the image';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (!value.endsWith('png') &&
                              !value.endsWith('jpg') &&
                              !value.endsWith('jpeg')) {
                            return 'Image must be a JPG or PNG';
                          }
                          return null;
                        }),
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageURLController,
                        focusNode: _imageURLFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: null,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageURL: value);
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
