import 'package:book_club_v3/screens/find_club_screen.dart';
import 'package:book_club_v3/widgets/search_club_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_club_v3/screens/add_club_screen.dart';

import '../widgets/club_list.dart';
import '../providers/club_list_provider.dart';
import '../screens/book_club_drawer.dart';

class ClubOverviewScreen extends StatefulWidget {
  // static const routeName = '/club-overview-screen';

  final userDetails;

  ClubOverviewScreen(this.userDetails);

  @override
  _ClubOverviewScreenState createState() => _ClubOverviewScreenState();
}

class _ClubOverviewScreenState extends State<ClubOverviewScreen> {
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ClubListProvider>(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your clubs',
          style: Theme.of(context).textTheme.headline6,
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     tooltip: 'Add a club',
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(AddClubScreen.routeName,
        //           arguments: [
        //             widget.userDetails.data.uid,
        //             widget.userDetails.data.email
        //           ]);
        //     },
        //   )
        // ],
      ),
      drawer: BookClubDrawer(widget.userDetails),
      body: Column(
        children: [
          ClubList(widget.userDetails),
          Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                backgroundBlendMode: BlendMode.multiply),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Find a club'),
                          Icon(Icons.search),
                        ],
                      ),
                    ),
                    splashColor: Theme.of(context).accentColor,
                    highlightColor: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed(FindClubScreen.routeName,
                          arguments: [
                            widget.userDetails.data.uid,
                            widget.userDetails.data.email
                          ]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: VerticalDivider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Add a new club'),
                            Icon(Icons.add),
                          ]),
                    ),
                    splashColor: Theme.of(context).accentColor,
                    highlightColor: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AddClubScreen.routeName, arguments: [
                        widget.userDetails.data.uid,
                        widget.userDetails.data.email,
                      ]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
