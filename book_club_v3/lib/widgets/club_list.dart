import 'package:book_club_v3/providers/club_list_provider.dart';

import '../widgets/club_item.dart';
import '../providers/club.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClubList extends StatelessWidget with ChangeNotifier {
  var _isInit = true;
  // var _isLoading = false;
  var item;

  var _clubs;

  Future<List<Club>> getClubs(context) async {
    List<Club> clubListReturn =
        await Provider.of<ClubListProvider>(context).fetchAndSetClubs();
    return clubListReturn;
  }

  @override
  Widget build(BuildContext context) {
    // if (_isInit) {
    //   Provider.of<ClubListProvider>(context).fetchAndSetClubs();
    //   _isInit = !_isInit;
    // }

    _clubs = getClubs(context);

    return FutureBuilder(
        future: _clubs,
        builder: (ctx, clubsSnapshot) {
          return Container(
            child: clubsSnapshot.data == null || clubsSnapshot.data.isEmpty
                ? Center(
                    child: Text(
                        'You aren\'t in any clubs yet. Why not start one?'),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: clubsSnapshot.data.length,
                    itemBuilder: (ctx, index) => ClubItem(
                          id: clubsSnapshot.data[index].id,
                          clubName: clubsSnapshot.data[index].clubName,
                          members: clubsSnapshot.data[index].members,
                          adminId: clubsSnapshot.data[index].adminId,
                          bookList: clubsSnapshot.data[index].bookList,
                          imageUrl: 'assets/images/bookClub_bc.svg',
                        )),
          );
        });
  }
}
