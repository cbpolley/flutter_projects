import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberRequestItem extends StatelessWidget {
  final String id;
  final String currentClubId;
  final currentBookId;
  final String imageUrl;
  final Map currentBook;
  final bool isAdmin;
  final bool hasCrown;
  final Function approvefn;

  MemberRequestItem({
    this.id,
    this.currentClubId,
    this.currentBookId,
    // this.memberName,
    this.imageUrl,
    this.currentBook,
    this.isAdmin,
    this.hasCrown,
    this.approvefn,
  });

//   @override
//   _MemberItemState createState() => _MemberItemState();
// }

// class _MemberItemState extends State<MemberItem> {
  var memberName;
  final instance = FirebaseFirestore.instance;

  // @override
  // initState() {
  //   super.initState();
  //   // instance
  // }

  var progressAmount = 0.00;
  var _isApproved;

  // Stream<QueryDocumentSnapshot> ratingStream() {
  //   return
  // }

  getImage(userSnapshot) {
    return userSnapshot.data.data()['imageUrl'];
  }

  @override
  Widget build(BuildContext context) {
    // var userString = await currentBookId();

    // getChosenByUserName();
    return Container(
      width: 200,
      color: Theme.of(context).cardTheme.color,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Container(
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(id)
                    .snapshots(),
                builder: (cx, userSnapshot) {
                  return Column(
                    children: [
                      if (userSnapshot.connectionState ==
                              ConnectionState.active &&
                          userSnapshot.data.exists)
                        Container(
                            height: 20,
                            child: Text(
                              userSnapshot.data.data()['userName'],
                              overflow: TextOverflow.ellipsis,
                            )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: (imageUrl == "default" ||
                                    imageUrl == "" ||
                                    imageUrl == null)
                                ? Icon(Icons.person)
                                : NetworkImage(imageUrl),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
        if (approvefn != null)
          Container(
            // margin: EdgeInsets.all(5),
            color: Theme.of(context).accentColor,
            height: 25,
            child: FlatButton(
              child: Text('Approve?'),
              onPressed: () {
                approvefn(context, currentClubId, id);
              },
            ),
          ),
      ]),
    );
  }
}
