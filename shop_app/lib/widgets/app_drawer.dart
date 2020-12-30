import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Alright Chum'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              title: Text('Shop'),
              leading: Icon(Icons.shop),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          ListTile(
              title: Text('Orders'),
              leading: Icon(Icons.payment),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  CustomRoute(
                    builder: (ctx) => OrdersScreen(),
                  ),
                );
              }),
          Divider(),
          ListTile(
              title: Text('Manage Products'),
              leading: Icon(Icons.edit),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              }),
          Divider(),
          ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }
}
