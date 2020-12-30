import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/current_book.dart';
import '../widgets/progress_bar.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Club'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == FilterOptions.Favourites) {
                    // productsContainer.showFavouritesOnly();
                    _showOnlyFavourites = true;
                  } else {
                    // productsContainer.showAll();
                    _showOnlyFavourites = false;
                  }
                },
              );
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
              color: null,
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:
          // Container(
          //   width: double.infinity,
          // child: Column(
          //   children: [
          // Row(
          //   children: [
          //     Expanded(child: Text('Something')),
          //   ],
          // ),
          // Row(
          //   children: [
          Column(
        children: [
          Container(
            height: 200,
            child: CurrentBook(),
          ),
          Container(
            color: Colors.blue,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('CHOSEN BY: Nicola'),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  child: ProgressBar(
                    'Nicola',
                    0.5,
                  ),
                ),
              ],
            ),
          ),
          Text('Club members'),
          Container(
            child: ProductsGrid(_showOnlyFavourites),
            height: 300,
          ),
        ],
      ),
      // Text('some text'),
      // ],
      // )
      // ],
      // ),
      // ),
    );
  }
}
