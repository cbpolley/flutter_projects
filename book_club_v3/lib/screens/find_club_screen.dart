import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:book_club_v3/screens/add_club_screen.dart';

import '../widgets/search_club_list.dart';
import '../providers/club_list_provider.dart';
import '../screens/book_club_drawer.dart';

class FindClubScreen extends StatefulWidget {
  static const routeName = '/find-club-screen';

  @override
  _ClubOverviewScreenState createState() => _ClubOverviewScreenState();
}

class _ClubOverviewScreenState extends State<FindClubScreen> {
  var _isInit = true;
  var searchTerm;

  final _clubSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  updateSearchTerm() {
    setState(() {
      searchTerm = _clubSearchController.text.toString().trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find a club',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      // drawer: BookClubDrawer(widget.userDetails),
      body: Column(
        children: [
          SearchClubList(searchTerm),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      backgroundBlendMode: BlendMode.multiply),
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyText1,
                      controller: _clubSearchController,
                      decoration: InputDecoration(
                        labelText: 'Search for a club name:',
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Go!'),
                          Icon(Icons.search),
                        ]),
                  ),
                  splashColor: Theme.of(context).accentColor,
                  highlightColor: Theme.of(context).accentColor,
                  onPressed: () {
                    updateSearchTerm();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
