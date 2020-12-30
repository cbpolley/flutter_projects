import 'package:flutter/material.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

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
            title: Text('Librarian'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              title: Text('Summary Page'),
              leading: Icon(Icons.book),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          ListTile(
              title: Text('Orders'),
              leading: Icon(Icons.payment),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              }),
          Divider(),
          ListTile(
              title: Text('Members'),
              leading: Icon(Icons.people),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              }),
        ],
      ),
    );
  }
}
