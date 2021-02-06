import 'package:book_club_v3/providers/club_list_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/club_item.dart';
import '../providers/club.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClubList extends StatelessWidget {
  final userDetails;

  ClubList(this.userDetails);

  // var _isInit = true;
  // var _isLoading = false;
  var item;

  Map<String, String> _userSubscribedClubs;
  List clubsList;

  Future<List> getSubcribedClubs() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.data.uid)
        .collection('clubs')
        .get()
        .then((item) {
      item.docs.forEach((doc) {
        if (_userSubscribedClubs == null) {
          _userSubscribedClubs = {doc.id: doc.data()['clubId']};
        } else {
          _userSubscribedClubs.putIfAbsent(
              doc.id.toString(), () => doc.data()['clubId'].toString());
        }
        // var tempMap =
      });
    });
    if (_userSubscribedClubs != null) {
      clubsList = _userSubscribedClubs.keys.toList();
    }
    return clubsList;
  }

  // Future<List<Club>> getClubs(context) async {
  //   // List<Club> clubListReturn =
  //   await Provider.of<ClubListProvider>(context).fetchAndSetClubs();
  //   return Provider.of<ClubListProvider>(context, listen: false).clubList;
  //   // return clubListReturn;
  // }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // if (_isInit) {
    //   Provider.of<ClubListProvider>(context).fetchAndSetClubs();
    //   _isInit = !_isInit;
    // }

    // _clubs = getClubs(context);

    return FutureBuilder(
      future: getSubcribedClubs(),
      builder: (ctx, futureSnapShot) => StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('clubs')
              .where("id", whereIn: futureSnapShot.data)
              .snapshots(),
          builder: (ctx, clubsSnapshot) {
            if (clubsSnapshot.connectionState == ConnectionState.waiting) {
              return Expanded(
                flex: 10,
                child: Center(
                  child: Text('loading...',
                      style: Theme.of(context).textTheme.headline4),
                ),
              );
            }
            return (_userSubscribedClubs == null)
                ? Expanded(
                    flex: 10,
                    child: Center(
                      child: Text(
                          'You aren\'t in any clubs yet. Why not start one?',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                  )
                : Expanded(
                    flex: 10,
                    child: Container(
                        // height: 300,
                        child: clubsSnapshot.hasData == false ||
                                clubsSnapshot.data.docs.length < 1
                            ? Center(
                                child: Text(
                                  'You aren\'t in any clubs yet. Why not start one?',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              )
                            : ListView(
                                scrollDirection: Axis.vertical,
                                children: clubsSnapshot.data.docs
                                    .map((DocumentSnapshot ds) {
                                  return new ClubItem(
                                    id: ds.id.toString(),
                                    clubName: ds.data()['clubName'].toString(),
                                    adminId: ds.data()['adminId'].toString(),
                                    imageUrl: 'assets/images/bookClub_bc.svg',
                                    currentUser: user.uid,
                                    // userDetails: userDetails,
                                  );
                                }).toList(),
                              )),
                  );
          }),
    );
  }
}
