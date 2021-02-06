import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'club.dart';

class ClubListProvider with ChangeNotifier {
  List<Club> _clubList = [];

  // final String authToken;
  // final String userId;

  // ClubListProvider(this.authToken, this.userId, this._clubList);

  List<Club> get clubList {
    return [..._clubList];
  }

//   Future<List> fetchAndSetClubs() async {
//     final fbm = FirebaseFirestore.instance;

//     // var clubList = [];
//     List<Club> tempClubList = [];

//     // DatabaseReference databaseReference;

//     // databaseReference = FirebaseFirestore.instance;

//     // Map<String, dynamic> mapOfClubs = MAp.
// //
//     await fbm.collection('clubs').get().then((snapshot) async {
//       snapshot.docs.forEach((item) {
//         // clubList.add(item);
//         tempClubList.add(Club(
//           adminId: item.get('adminId'),
//           // bookList: item'bookList').get(),
//           clubName: item.get('clubName'),
//           // members: item.collection('members').get(),
//           id: item.id,
//         ));
//       });
//     });

//     // var bookListOrNot;

//     // clubList.forEach((item) async {
//     //   // try {
//     //   // bookListOrNot = fbm
//     //   //     .collection('clubs')
//     //   //     .doc(item['id'])
//     //   //     .collection('bookList')
//     //   //     .limit(1)
//     //   //     .get()
//     //   //     .then();
//     //   // if (bookListOrNot.empty) {
//     //   //   bookListOrNot = {};
//     //   // }
//     //   try {

//     // } catch (error) {
//     //   print(error);
//     // }

//     // print(bookListOrNot);
//     //   } catch (error) {}
//     // });

//     // bookListOrNot = item.collection('bookList').get();

//     //   });
//     // });

//     _clubList = tempClubList;
//     notifyListeners();
//     // return _clubList;
//   }

  Future<void> addClub(Club club) async {
    final user = FirebaseAuth.instance.currentUser;

    final clubDetails = {
      'clubName': club.clubName,
      'adminId': club.adminId,
      'imageUrl': club.imageUrl,
    };
    final memberDetail = {
      'memberId': club.adminId,
    };
    final bookDetail = {
      'bookTitle': 'Nineteen Eighty Four',
      'imageUrl': 'Nineteen Eighty Four',
      'isCurrentBook': false,
      'pages': 365,
      'author': 'George Orwell',
      'bookDesc':
          'Among the seminal texts of the 20th century, Nineteen Eighty-Four is a rare work that grows more haunting as its futuristic purgatory becomes more real. Published in 1949, the book offers political satirist George Orwell\'s nightmarish vision of a totalitarian, bureaucratic world and one poor stiff\'s attempt to find individuality. The brilliance of the novel is Orwell\'s prescience of modern life—the ubiquity of television, the distortion of the language—and his ability to construct such a thorough version of hell. Required reading for students since it was published, it ranks among the most terrifying novels ever written.',
      'chosenBy': user.uid,
    };
    final adminBookRankings = {
      'bookRating': 0.00,
      'bookProgress': 0.00,
    };

    final sendData = json.encode(clubDetails);

    var clubId;

    final fbm = FirebaseFirestore.instance;

    fbm
        .collection('clubs')
        .add(json.decode(sendData))
        .then((DocumentReference docRef) {
      clubId = docRef.id.toString();
      fbm.collection('clubs').doc(docRef.id.toString()).update({'id': clubId});

      fbm
          .collection('clubs')
          .doc(docRef.id.toString())
          .collection('members')
          .doc(club.adminId)
          .set(memberDetail);
      fbm
          .collection('clubs')
          .doc(docRef.id.toString())
          .collection('bookList')
          .add(bookDetail)
          .then((subDocRef) {
        fbm
            .collection('clubs')
            .doc(docRef.id.toString())
            .collection('bookList')
            .doc(subDocRef.id.toString())
            .collection('bookRankings')
            .doc(user.uid)
            .set(adminBookRankings);
      });
      fbm
          .collection('users')
          .doc(user.uid)
          .collection('clubs')
          .doc(clubId)
          .set({'clubId': clubId});

      fbm.collection('users').doc(user.uid).get().then((userSS) {
        var clubNumber = userSS.data()['clubs'];
        clubNumber = clubNumber + 1;
        fbm.collection('users').doc(user.uid).update({'clubs': clubNumber});
      });
    });
    _clubList.add(club);
    notifyListeners();
  }
}
