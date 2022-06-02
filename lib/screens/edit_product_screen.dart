import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _isInit = false;
  var _isEditMode = false;

  void _updateImageListener() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.toLowerCase().startsWith('http')) return;

      setState(() {}); // Show image when focus is lost
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();

    if (_isEditMode) {
      Provider.of<Products>(context, listen: false).editProduct(_editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isInit = true;
      final _productId = ModalRoute.of(context).settings.arguments as String;
      if (_productId == null) return;

      _editedProduct = Provider.of<Products>(context).getProductById(_productId);
      _imageUrlController.text = _editedProduct.imageUrl;
      _isEditMode = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();

    _imageUrlFocusNode.removeListener(_updateImageListener);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _editedProduct.title,
                decoration: InputDecoration(label: Text('Title')),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) return "Please enter a title";
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _editedProduct.price == 0 ? "" : _editedProduct.price.toString(),
                decoration: InputDecoration(label: Text('Price')),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) return "Please enter a price";
                  if (double.tryParse(value) == null) return "Please enter a valid number";
                  if (double.parse(value) <= 0) "Please enter a number greater than zero";
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _editedProduct.description,
                decoration: InputDecoration(label: Text('Description')),
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) return "Please enter a description";
                  if (value.length < 10) return "Description should be at least 10 characters long";
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 16, right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Center(
                            child: Text(
                            "Enter a URL",
                            style: TextStyle(color: Colors.grey),
                          ))
                        : FittedBox(
                            child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          )),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(label: Text('Image URL')),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onEditingComplete: () => setState(() {}),
                      validator: (value) {
                        if (value.isEmpty) return "Please enter an image URL";
                        if (!value.toLowerCase().startsWith('http')) return "Please enter a valid URL";
                        return null;
                      },
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
