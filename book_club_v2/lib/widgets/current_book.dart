import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class CurrentBook extends StatefulWidget {
  static const routeName = '/current-book';
  @override
  _CurrentBookState createState() => _CurrentBookState();
}

class _CurrentBookState extends State<CurrentBook> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  // var _initValues = {
  //   'title': '',
  //   'description': '',
  //   'price': '',
  //   'imageUrl': '',
  // };
  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findByid(productId);
        // _initValues = {
        //   'title': _editedProduct.title,
        //   'description': _editedProduct.description,
        //   'price': _editedProduct.price.toString(),
        //   'imageUrl': '',
        // };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https') ||
          !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.gif')) {
        return;
      }
      setState(() {});
    }
  }

  // void _saveForm() {
  //   final isValid = _form.currentState.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   _form.currentState.save();
  //   if (_editedProduct.id != null) {
  //     Provider.of<Products>(context, listen: false)
  //         .updateProduct(_editedProduct.id, _editedProduct);
  //   } else {
  //     Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
  //   }

  //   Navigator.of(context).pop();
  // }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).primaryColor,
                height: 40,
                child: Center(
                  child: Text(
                    'Current Book',
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Fantastic Mr Fox'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('A brief description of the book.'),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: FittedBox(
                            child: Image.network(
                              'https://covers.openlibrary.org/b/id/240726-S.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
