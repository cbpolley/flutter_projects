import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

    var querySnapshot =
        await fbm.collection('clubs').get().then((snapshot) async {
      snapshot.docs.forEach((item) {
        tempClubList.add(Club(
          adminId: item.get('adminId'),
          bookList: item.get('bookList'),
          clubName: item.get('clubName'),
          members: item.get('members'),
          id: item.id.toString(),
        ));
      });
    });
    _clubList = tempClubList;
    return _clubList;
  }

  // querySnapshot.docs.forEach((doc) {
  //   print(doc.data);
  // });

  // }
  // querySnapshot.forEach((doc) {
  //   print(doc.docs);
  // });

  //   _clubList = querySnapshot.doc.data();
  // .map((doc) => Club(
  //       // adminId: doc['id'],
  //       // bookList: doc['bookList'],
  //       clubName: doc.id.get('clubName'),
  //       // members: doc['members'],
  //       id: doc.get('id'),
  //     ))
  // .toList();
  // });

  // _clubList = querySnapshot.docs
  //     .map((doc) => Club(
  //           // adminId: doc['id'],
  //           // bookList: doc['bookList'],
  //           clubName: doc.id.get('clubName'),
  //           // members: doc['members'],
  //           id: doc.get('id'),
  //         ))
  //     .toList();

  // final fbmClubs = fbm.collection('clubs').get().then((querySnapshot) => {
  //       querySnapshot.forEach((doc) => {print(doc.id)})
  //     });
  // var url =
  //     'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs.json?auth=$authToken';
  // try {
  //   final response = await http.get(url);
  //   // Map<String, dynamic> extractData = new Map<String, dynamic>.from(response.body);
  //   // final extractData = new Map<String, dynamic>.from(response.body);
  //   final extractData = json.decode(response.body) as Map<String, dynamic>;
  //   final List<Club> loadedClubs = [];
  //   if (extractData == null) {
  //     return;
  //   }
  //   extractData.forEach(
  //     (clubId, clubData) {
  //       loadedClubs.add(
  //         Club(
  //           adminId: clubData['adminId'],
  //           bookList: clubData['bookList'],
  //           clubName: clubData['clubName'],
  //           members: clubData['members'],
  //           id: clubId,
  //         ),
  //       );
  //     },
  //   );
  // _clubList = fbmClubs;
  // notifyListeners();
  // } catch (error) {
  //   throw (error);
  // }

  Future<void> addClub(Club club) async {
    // final adminUpload = {
    //   club.adminId: {"memberId": club.adminId, }
    // };
    final url =
        'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs.json?auth=$authToken';
    final response = await http.post(
      url,
      body: json.encode({
        'clubName': club.clubName,
        "members": club.members,
        'adminId': club.adminId,
        'bookList': club.bookList,
        'imageUrl': club.imageUrl,
      }),
    );
    final newClub = Club(
      id: json.decode(response.body)['name'],
      clubName: club.clubName,
      members: club.members,
      adminId: club.adminId,
      bookList: club.bookList,
      imageUrl: club.imageUrl,
    );
    _clubList.add(newClub);
    notifyListeners();
  }
}
