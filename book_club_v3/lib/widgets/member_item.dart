import 'dart:async';

import 'package:book_club_v3/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberItem extends StatelessWidget {
  final String id;
  final String currentClubId;
  final currentBookId;
  final String imageUrl;
  final Map currentBook;
  final bool isAdmin;
  final bool hasCrown;

  MemberItem({
    this.id,
    this.currentClubId,
    this.currentBookId,
    // this.memberName,
    this.imageUrl,
    this.currentBook,
    this.isAdmin,
    this.hasCrown,
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

  // Stream<QueryDocumentSnapshot> ratingStream() {
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    // var userString = await currentBookId();

    // getChosenByUserName();
    return Container(
      width: 100,
      color: Theme.of(context).cardTheme.color,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Container(
            height: 15,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(id)
                      .snapshots(),
                  builder: (cx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                            ConnectionState.active &&
                        userSnapshot.data.exists) {
                      return Text(userSnapshot.data.data()['userName']);
                    } else {
                      return Text('Bob');
                    }
                  }),
            ),
          ),
        ),
        (currentBookId != null)
            ? StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('clubs')
                    .doc(currentClubId)
                    .collection('bookList')
                    .doc(currentBookId)
                    .collection('bookRankings')
                    .doc(id)
                    .snapshots(),
                builder: (ctx, rankingSnapshot) {
                  if (rankingSnapshot.hasData)
                    progressAmount =
                        rankingSnapshot.data.data()['bookProgress'].toDouble();
                  return (rankingSnapshot.connectionState ==
                          ConnectionState.waiting)
                      ? Container(
                          height: 80, child: Center(child: Icon(Icons.book)))
                      : Column(children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  height: 60,
                                  child: (currentBookId == null)
                                      ? ProgressBar(
                                          (isAdmin == null) ? false : isAdmin,
                                          0.0,
                                        )
                                      : ProgressBar(
                                          (isAdmin == null) ? false : isAdmin,
                                          progressAmount),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: isAdmin == null
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                                  radius: 30,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).cardColor,
                                    // minRadius: 1,
                                    maxRadius: 25,
                                    child: (imageUrl == "default" ||
                                            imageUrl == "" ||
                                            imageUrl == null)
                                        ? Icon(Icons.person)
                                        : NetworkImage(imageUrl),
                                  ),
                                ),
                              ),
                              if (hasCrown != null)
                                if (hasCrown == true)
                                  Positioned(
                                    top: 0.0,
                                    child: Image.asset(
                                      'assets/images/crown.png',
                                      height: 20,
                                    ),
                                  ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              child: (Text(
                                "${progressAmount.toStringAsFixed(0)}%",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ]);
                })
            : Container(height: 80, child: Center(child: Icon(Icons.book))),
      ]),
    );
  }
}
