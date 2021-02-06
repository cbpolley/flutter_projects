import 'dart:async';

import 'package:book_club_v3/screens/add_member_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/club.dart';
import '../providers/club_list_provider.dart';

class AddClubScreen extends StatefulWidget {
  static const routeName = '/add-club-screen';
  @override
  _AddClubScreenState createState() => _AddClubScreenState();
}

class _AddClubScreenState extends State<AddClubScreen> {
  final _clubTitleController = TextEditingController();
  final _clubAdminController = TextEditingController();

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {}

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _clubTitleController.dispose();
    _clubAdminController.dispose();
    super.dispose();
  }

  Future<void> _addClubToClubList(Map clubMap) {
    final convertedClub = new Club.fromJson(clubMap);
    Provider.of<ClubListProvider>(context, listen: false)
        .addClub(convertedClub);
    Navigator.pop(context);
  }

  BuildContext get newMethod => context;

  @override
  Widget build(BuildContext context) {
    // final authData = Provider.of<Auth>(context, listen: false);

    final List userDetails = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a club', style: Theme.of(context).textTheme.headline6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: _clubTitleController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Club Name:',
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.green,
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Text('Submit'),
                          splashColor: Colors.amber,
                          onTap: () {
                            Map clubMap = {
                              'clubName': _clubTitleController.text,
                              'members': {
                                userDetails[0]: {
                                  "memberId": userDetails[0],
                                  "memberEmail": userDetails[1],
                                  "imageUrl": "default",
                                  "isAdmin": "true",
                                  "hasCrown": "false",
                                }
                              },
                              'adminId': userDetails[0],
                              'imageUrl': '',
                            };
                            _addClubToClubList(clubMap);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
