import '../widgets/visibility_switch.dart';
import '../widgets/change_club_name.dart';

import '../widgets/member_requests_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/club_members.dart';
import '../widgets/find_user.dart';

class ScreenArguments {
  final String clubId;
  final requestsSnapshot;

  ScreenArguments(this.clubId, this.requestsSnapshot);
}

class ClubSettingsScreen extends StatelessWidget {
  static const routeName = '/add-member-screen';

  bool isSwitched = true;

  Future<void> _requestMemberToClub(
      context, String clubId, String userId) async {
    Map<String, dynamic> memberMap;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((doc) {
      memberMap = {
        "memberName": doc.data()['userName'],
        "imageUrl": doc.data()['imageUrl'],
        "isAdmin": false,
        "hasCrown": false,
        "confirmedMember": false,
      };
      Provider.of<ClubMembers>(context, listen: false)
          .addMember(context, userId, clubId, memberMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments memberDetails =
        ModalRoute.of(context).settings.arguments;
    var clubId = memberDetails.clubId;
    var memberLength = memberDetails.requestsSnapshot.data.docs.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Club Settings'),
      ),
      body: ListView(
        children: [
          ChangeClubName(clubId),
          VisibilitySwitch(clubId),
          MemberRequestsList(clubId, _requestMemberToClub),
          FindUser(clubId, _requestMemberToClub),
        ],
      ),
    );
  }
}
