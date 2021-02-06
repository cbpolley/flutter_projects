import 'package:book_club_v3/providers/club_list_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/search_club_item.dart';
import '../providers/club.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchClubList extends StatelessWidget {
  // static const routeName = '/search-club-screen';

  final searchTerm;

  SearchClubList(this.searchTerm);

  // var _isInit = true;
  // var _isLoading = false;
  var item;

  // Map<String, String> _userSubscribedClubs;
  List clubsList;

  // Future<List> getSubcribedClubs() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userDetails.data.uid)
  //       .collection('clubs')
  //       .get()
  //       .then((item) {
  //     item.docs.forEach((doc) {
  //       if (_userSubscribedClubs == null) {
  //         _userSubscribedClubs = {doc.id: doc.data()['clubName']};
  //       } else {
  //         _userSubscribedClubs.putIfAbsent(
  //             doc.id.toString(), () => doc.data()['clubName'].toString());
  //       }
  //       // var tempMap =
  //     });
  //   });
  //   clubsList = _userSubscribedClubs.keys.toList();
  //   return clubsList;
  // }

  // Future<List<Club>> getClubs(context) async {
  //   // List<Club> clubListReturn =
  //   await Provider.of<ClubListProvider>(context).fetchAndSetClubs();
  //   return Provider.of<ClubListProvider>(context, listen: false).clubList;
  //   // return clubListReturn;
  // }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final instance = FirebaseFirestore.instance.collection('clubs');
    // if (_isInit) {
    //   Provider.of<ClubListProvider>(context).fetchAndSetClubs();
    //   _isInit = !_isInit;
    // }

    // _clubs = getClubs(context);

    return StreamBuilder<QuerySnapshot>(
        stream: instance.where("clubName", isEqualTo: searchTerm).snapshots(),
        builder: (ctx, clubsSnapshot) {
          if (clubsSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('loading...',
                  style: Theme.of(context).textTheme.headline4),
            );
          }
          return Expanded(
            flex: 10,
            child: Container(
                // height: 300,
                child: ListView(
              scrollDirection: Axis.vertical,
              children: clubsSnapshot.data.docs.map((DocumentSnapshot ds) {
                var proceedWithBuild = true;
                instance.doc(ds.id).collection('members').get().then((doc) {
                  var docList = doc;
                  for (int i = 0; i < docList.docs.length; i++) {
                    if (user.uid == docList.docs[i]) {
                      proceedWithBuild = false;
                    }
                  }
                });
                if (proceedWithBuild)
                  return new SearchClubItem(
                    id: ds.id.toString(),
                    clubName: ds.data()['clubName'].toString(),
                    adminId: ds.data()['adminId'].toString(),
                    imageUrl: 'assets/images/bookClub_bc.svg',
                    currentUserId: user.uid,
                    currentUserName: user.displayName,
                    // userDetails: userDetails,
                  );
              }).toList(),
            )),
          );
        });
  }
}
