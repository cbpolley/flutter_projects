import 'package:book_club_v3/providers/user_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/auth.dart';
import '../screens/user_details_screen.dart';

class BookClubDrawer extends StatelessWidget {
  var _isInit = true;
  final AsyncSnapshot<User> userDetails;

  BookClubDrawer(this.userDetails);

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
    if (_isInit) {
      // Provider.of<UserDetails>(context).fetchAndSetUserDetails(userDetails);
      _isInit = !_isInit;
    }
    return Drawer(
      child: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            AppBar(
              title: Text('Book Club',
                  style: Theme.of(context).textTheme.headline6),
              automaticallyImplyLeading: false,
            ),
            ListTile(
                selectedTileColor: Theme.of(context).accentColor,
                tileColor: Theme.of(context).cardColor,
                title: Text('Your account',
                    style: Theme.of(context).textTheme.headline5),
                leading: Icon(Icons.person,
                    color: Theme.of(context).textTheme.headline5.color),
                onTap: () {
                  Navigator.of(context).pushNamed(UserDetailsScreen.routeName,
                      arguments: userDetails);
                }),
            Divider(
              color: Theme.of(context).accentColor,
              thickness: 1,
            ),
            ListTile(
                selectedTileColor: Theme.of(context).accentColor,
                tileColor: Theme.of(context).cardColor,
                title: Text('Log Out',
                    style: Theme.of(context).textTheme.headline5),
                leading: Icon(Icons.exit_to_app,
                    color: Theme.of(context).textTheme.headline5.color),
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigator.of(context).pushReplacementNamed('/');
                  FirebaseAuth.instance.signOut();
                  // Provider.of<Auth>(context, listen: false).logout();
                }),
          ],
        ),
      ),
    );
  }
}
