import '../widgets/darkmode_switch.dart';
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

class GlobalSettingsScreen extends StatelessWidget {
  static const routeName = '/global-settings-screen';

//   @override
//   _AddMemberScreenState createState() => _AddMemberScreenState();
// }

// class _AddMemberScreenState extends State<AddMemberScreen> {
//   final _memberImageUrlController = TextEditingController();

  bool isSwitched = true;

  // @override
  // void initState() {
  //   super.initState();
  // }

  // void dispose() {
  //   _memberImageUrlController.dispose();
  // }

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
    final ScreenArguments userDetails =
        ModalRoute.of(context).settings.arguments;
    // var clubId = memberDetails.clubId;
    // var memberLength = userDetails.requestsSnapshot.data.docs.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          DarkModeSwitch(),
          // ChangeClubName(clubId),
          // VisibilitySwitch(clubId),
          // MemberRequestsList(clubId, _requestMemberToClub),
          // FindUser(clubId, _requestMemberToClub),
        ],
      ),
    );

    // Align(
    //   alignment: Alignment.bottomCenter,
    //   child: Container(
    //     height: 70,
    //     child: Expanded(
    //       child: Container(
    //         color: Colors.green,
    //         alignment: Alignment.center,
    //         child: InkWell(
    //           child: Text('Submit'),
    //           splashColor: Colors.amber,
    //           onTap: () {
    //             Map memberMap = {};
    //             _addMemberToClub(
    //                 context, memberMap, memberDetails.clubId);
    //           },
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
  }
}
