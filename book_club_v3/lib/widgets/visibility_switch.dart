import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisibilitySwitch extends StatelessWidget {
  final String clubId;

  VisibilitySwitch(this.clubId);

  bool isSwitched;

  Future<bool> getIsSwitched(clubId) async {
    await FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .get()
        .then((doc) {
      if (doc.data()['publicGroup'] != null) {
        isSwitched = doc.data()['publicGroup'];
      }
    });
    return isSwitched;
  }

  doSwitch(clubId, value) {
    isSwitched = value;
    FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .update({'publicGroup': isSwitched});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Public Visibility',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          FutureBuilder(
              future: getIsSwitched(clubId),
              builder: (ctx, futureClub) {
                return (futureClub.connectionState == ConnectionState.waiting)
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('clubs')
                            .doc(clubId)
                            .snapshots(),
                        builder: (ctx, snapshotClub) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (snapshotClub.connectionState ==
                                      ConnectionState.waiting)
                                  ? Container(
                                      height: 0,
                                      width: 0,
                                    )
                                  : Text(
                                      (isSwitched)
                                          ? 'Your group is publicly visible.'
                                          : 'Your group is private.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 16),
                                    ),
                              Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  doSwitch(clubId, value);
                                },
                              )
                            ],
                          );
                        });
              }),
          Divider(
            color: Theme.of(context).cardColor,
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
