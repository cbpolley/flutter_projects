import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/member_request_item.dart';

class MemberRequestsList extends StatelessWidget {
  final String clubId;
  final Function addMember;

  MemberRequestsList(this.clubId, this.addMember);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('clubs')
            .doc(clubId)
            .collection('joinRequests')
            .snapshots(),
        builder: (context, memberListSnapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Request List',
                              style: Theme.of(context).textTheme.headline5),
                          memberListSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Text('... Requests')
                              : Text(
                                  '${memberListSnapshot.data.docs.length} pending requests',
                                  style: Theme.of(context).textTheme.headline5),
                        ],
                      ),
                    ),
                  ),
                  if (memberListSnapshot.connectionState !=
                      ConnectionState.waiting)
                    Container(
                      height: 135,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 5,
                            color: Colors.grey[300],
                          ),
                        ),
                        color: Theme.of(context).cardColor,
                      ),
                      // height: 135,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: memberListSnapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MemberRequestItem(
                            id: memberListSnapshot.data.docs[index].id,
                            currentClubId: clubId,
                            approvefn: addMember,
                          );
                        },
                      ),
                    )
                ],
              ),
            ),
          );
        });
  }
}
