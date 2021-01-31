import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'club.dart';

class ClubListProvider with ChangeNotifier {
  List<Club> _clubList = [];

  final String authToken;
  final String userId;

  ClubListProvider(this.authToken, this.userId, this._clubList);

  List<Club> get clubList {
    return [..._clubList];
  }

  Future<List> fetchAndSetClubs() async {
    final fbm = FirebaseFirestore.instance;

    List<Club> tempClubList = [];

    await fbm.collection('clubs').get().then((snapshot) async {
      snapshot.docs.forEach((item) {
        var bookListOrNot = {};
        try {
          bookListOrNot = item.get('bookList');
        } catch (error) {
          bookListOrNot = {};
        }

        tempClubList.add(Club(
          adminId: item.get('adminId'),
          bookList: bookListOrNot,
          clubName: item.get('clubName'),
          members: item.get('members'),
          id: item.id.toString(),
        ));
      });
    });

    _clubList = tempClubList;
    return _clubList;
  }

  Future<void> addClub(Club club) async {
    final clubMembers = {
      'clubName': club.clubName,
      'members': {
        club.adminId: {
          "memberId": club.adminId,
          "isAdmin": true,
        },
      },
      'adminId': club.adminId,
      'imageUrl': club.imageUrl,
    };
    final sendData = json.encode(clubMembers);

    final fbm = FirebaseFirestore.instance;

    fbm.collection('clubs').add(json.decode(sendData));

    _clubList.add(club);
    notifyListeners();
  }
}
