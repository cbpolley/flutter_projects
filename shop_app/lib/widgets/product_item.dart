import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Consumer<Product>(
      builder: (ctx, product, child) => Container(
        decoration: BoxDecoration(
          // border: Border.all(
          //     color: Colors.green, style: BorderStyle.solid, width: 5),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(
                0.0,
                0.0,
              ),
            ),
          ],
        ),
        child: Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id,
                );
              },
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavouriteStatus(
                      authData.token, authData.userId);
                },
              ),
              title: Text(product.title,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
              trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Item added to cart!',
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
