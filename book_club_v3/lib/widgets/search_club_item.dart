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

class SearchClubItem extends StatefulWidget {
  final String id;
  final String clubName;
  // final members;
  final String adminId;
  // final Map bookList;
  final String imageUrl;
  final String currentUserId;
  final String currentUserName;
  // final userDetails;

  SearchClubItem({
    this.id,
    this.clubName,
    this.adminId,
    this.currentUserId,
    this.currentUserName,
    // this.members,
    this.imageUrl,
    // this.bookList,
    // this.userDetails,
  });

  @override
  _SearchClubItemState createState() => _SearchClubItemState();
}

var joinRequested = false;

class _SearchClubItemState extends State<SearchClubItem> {
  @override
  void initState() {
    super.initState();
  }

// @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  sendJoinRequest(instance) {
    joinRequested = true;
    instance
        .collection('clubs')
        .doc(widget.id)
        .collection('joinRequests')
        .doc(widget.currentUserId)
        .set({
      'userId': widget.currentUserId,
      'userName': widget.currentUserName,
      'requestedDate': DateTime.now()
    });
  }

  // updateSearchTerm() {
  //   setState(() {
  //     searchTerm = _clubSearchController.text.toString().trim();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final clubData = Provider.of<ClubListProvider>(context);

    // final authData = Provider.of<Auth>(context, listen: false);
    final instance = FirebaseFirestore.instance;
    // final user = FirebaseAuth.instance.currentUser;

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
                      child:
                          (widget.imageUrl == 'assets/images/bookClub_bc.svg')
                              ? SvgPicture.asset(
                                  'assets/images/bookClub_bc.svg',
                                  semanticsLabel: 'Bookclub Logo',
                                  height: 200,
                                )
                              : Image.network(
                                  widget.imageUrl,
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
                                child: Text(widget.clubName,
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  height: 40,
                                  child: (widget.currentUserId ==
                                          widget.adminId)
                                      ? Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            'Admin',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 105,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: joinRequested
                                      ? RaisedButton(
                                          color: Colors.grey,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'requested',
                                              ),
                                            ],
                                          ),
                                          onPressed: () {},
                                        )
                                      : RaisedButton(
                                          color: Colors.amber,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Join'),
                                              Icon(Icons.arrow_right),
                                            ],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              sendJoinRequest(instance);
                                            });
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
                                      .doc(widget.id)
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
                                      .doc(widget.id)
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
