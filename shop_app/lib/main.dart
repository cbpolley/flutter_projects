import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
            create: null,
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders),
            create: null,
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
                primarySwatch: Colors.green,
                accentColor: Colors.amber,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                })),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
