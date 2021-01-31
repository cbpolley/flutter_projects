import 'package:book_club_v3/providers/club_list_provider.dart';
import 'package:book_club_v3/providers/user_details.dart';
import 'package:book_club_v3/screens/add_club_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/club_list.dart';
import '../screens/book_club_drawer.dart';

class ClubOverviewScreen extends StatefulWidget {
  static const routeName = '/club-overview-screen';

  final userDetails;

  ClubOverviewScreen(this.userDetails);

  @override
  _ClubOverviewScreenState createState() => _ClubOverviewScreenState();
}

class _ClubOverviewScreenState extends State<ClubOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ClubListProvider>(context).fetchAndSetClubs();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final clubList = Provider.of<ClubList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your clubs',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add a club',
            onPressed: () {
              Navigator.of(context).pushNamed(AddClubScreen.routeName,
                  arguments: [
                    widget.userDetails.data.uid,
                    widget.userDetails.data.email
                  ]);
            },
          )
        ],
      ),
      drawer: BookClubDrawer(widget.userDetails),
      body: ClubList(),
    );
  }
}
