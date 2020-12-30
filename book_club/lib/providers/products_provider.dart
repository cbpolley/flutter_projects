import 'package:flutter/material.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Nicola',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://www.mnsu.edu/leadercast/images/wleaders/person.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Roger',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://www.healthcare-online.org/images/1HT14163/image024.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Barry',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://news.cornell.edu/sites/chronicle.cornell/files/Eisenman_1.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Angela',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://gmoanswers.com/sites/default/files/styles/large/public/person.png',
    ),
  ];

  // var _showFavouritesOnly = false;

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findByid(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct); insert at start of list.

    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
