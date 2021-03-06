import 'package:book_club_v3/screens/club_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'club.dart';

class ClubItem extends StatelessWidget {
  final String id;
  final String clubName;
  final String currentUser;
  // final members;
  final String adminId;
  // final Map bookList;
  final String imageUrl;
  // final userDetails;

  ClubItem({
    this.id,
    this.clubName,
    this.adminId,
    this.currentUser,
    // this.members,
    this.imageUrl,
    // this.bookList,
    // this.userDetails,
  });

  @override
  Widget build(BuildContext context) {
    // final clubData = Provider.of<ClubListProvider>(context);

    // final authData = Provider.of<Auth>(context, listen: false);
    final instance = FirebaseFirestore.instance;

    return Container(
      margin: const EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10.0)],
        border: Border.all(
            style: BorderStyle.solid,
            width: 6,
            color: Theme.of(context).cardColor),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      child: (imageUrl == 'assets/images/bookClub_bc.svg')
                          ? SvgPicture.asset(
                              'assets/images/bookClub_bc.svg',
                              semanticsLabel: 'Bookclub Logo',
                              height: 200,
                            )
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(style: BorderStyle.none),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(style: BorderStyle.none),
                              color: Theme.of(context).cardColor,
                            ),
                            height: 40,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(clubName,
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (currentUser == adminId)
                                Expanded(
                                  flex: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 40,
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                'Admin',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: instance
                                                  .collection('clubs')
                                                  .doc(id)
                                                  .collection('joinRequests')
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                return Expanded(
                                                  child: Container(
                                                    height: 40,
                                                    child: (snapshot.connectionState ==
                                                                ConnectionState
                                                                    .waiting ||
                                                            snapshot.data.docs
                                                                    .length ==
                                                                0)
                                                        ? null
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Icon(Icons.people,
                                                                  color: Colors
                                                                      .greenAccent),
                                                              Text(
                                                                  snapshot
                                                                      .data
                                                                      .docs
                                                                      .length
                                                                      .toString(),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6
                                                                      .copyWith(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.greenAccent)),
                                                            ],
                                                          ),
                                                  ),
                                                );
                                              }),
                                        ]),
                                  ),
                                ),
                              Container(
                                height: 40,
                                width: 125,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: RaisedButton(
                                    color: Colors.amber,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('go to club'),
                                        Icon(Icons.arrow_right),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ClubScreen(
                                              clubId: id,
                                              clubName: clubName,
                                              adminId: adminId,
                                              imageUrl: imageUrl,
                                            ),
                                            // ClubScreen.routeName,
                                            // arguments: {
                                            //   'clubName': clubName,
                                            //   'clubId': id,
                                            //   'adminId': adminId,
                                            //   // 'members': members,
                                            //   'imageUrl': imageUrl,
                                            //   // 'bookList': bookList,
                                            //   'currentUser': authData.userId,
                                            // },
                                          ));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(style: BorderStyle.none),
                        color: Theme.of(context).cardColor,
                      ),
                      // width: 40,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(style: BorderStyle.none),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                  stream: instance
                                      .collection('clubs')
                                      .doc(id)
                                      .collection('members')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.people,
                                            color: Theme.of(context)
                                                .primaryTextTheme
                                                .headline6
                                                .color),
                                        (snapshot.connectionState ==
                                                    ConnectionState.waiting ||
                                                snapshot.data.docs.length == 0)
                                            ? Text('0',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16,
                                                    ))
                                            : Text(
                                                snapshot.data.docs.length
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16,
                                                    )),
                                      ],
                                    );
                                  }),
                              StreamBuilder<QuerySnapshot>(
                                  stream: instance
                                      .collection('clubs')
                                      .doc(id)
                                      .collection('bookList')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.book,
                                            color: Theme.of(context)
                                                .primaryTextTheme
                                                .headline6
                                                .color),
                                        (snapshot.connectionState ==
                                                    ConnectionState.waiting ||
                                                snapshot.data.docs.length == 0)
                                            ? Text('0',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16,
                                                    ))
                                            : Text(
                                                snapshot.data.docs.length
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16),
                                              ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
