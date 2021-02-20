import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeClubName extends StatelessWidget {
  final String clubId;

  ChangeClubName(this.clubId);

  TextEditingController _clubNameController;

  String clubName;

  Future<String> getIsSwitched(clubId) async {
    await FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .get()
        .then((doc) {
      if (doc.data()['clubName'] != null) {
        clubName = doc.data()['clubName'];
      }
    });
    return clubName;
  }

  doUpdateName(clubId, value) {
    clubName = value;
    FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .update({'clubName': clubName});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      // width: double.infinity,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Club Name',
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
                                  : Expanded(
                                      child: TextFormField(
                                        controller: _clubNameController =
                                            TextEditingController(
                                                text: clubName),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            focusColor: Colors.grey,
                                            border: InputBorder.none,
                                            // labelText: 'Club Name:',
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                        style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                      ),
                                    ),
                              Container(
                                width: 100,
                                child: RaisedButton(
                                  child: Text('Update'),
                                  onPressed: () {
                                    doUpdateName(
                                        clubId, _clubNameController.text);
                                  },
                                ),
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
