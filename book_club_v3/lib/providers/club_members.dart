import 'package:firebase_auth/firebase_auth.dart';

import 'member.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/club_list_provider.dart';

class ClubMembers with ChangeNotifier {
  List<Member> _memberList = [];

  // final String authToken;
  // final String clubId;

  // // var memberIdList = [];

  // ClubMembers(this.authToken, this.clubId, this._memberList);

  List<Member> get memberList {
    return [..._memberList];
  }

  Future<void> getAllClubMembers(String clubId) async {
    final fbm = FirebaseFirestore.instance;

    var clubList = [];
    List<Member> tempMemberList = [];

    await fbm
        .collection('clubs')
        .doc(clubId)
        .collection('members')
        .get()
        .then((snapshot) async {
      snapshot.docs.forEach((item) {
        tempMemberList.add(Member(id: item.get('memberId')));
      });
    });

    _memberList = tempMemberList;
    notifyListeners();
  }

  Future<void> updateUserProgress(String clubId, double progressValue) async {
    final user = await FirebaseAuth.instance.currentUser;

    final clubInstance =
        FirebaseFirestore.instance.collection('clubs').doc(clubId);

    clubInstance
        .collection('bookList')
        .where("isCurrentBook", isEqualTo: true)
        .get()
        .then((docRef) {
      clubInstance
          .collection('bookList')
          .doc(docRef.docs.single.id.toString())
          .collection('bookRankings')
          .doc(user.uid)
          .update({'bookProgress': progressValue});
    });
    notifyListeners();
  }
}
// var clubList = [];
// List<Member> tempMemberList = [];

// await clubInstance
//     .collection('members')
//     .doc(user.uid)
//     .update(currentBook.)
//     .then((snapshot) async {
//   snapshot.docs.forEach((item) {
//     tempMemberList.add(Member(id: item.get('memberId')));
//   });
// });

// _memberList = tempMemberList;

//   final clubIdPass = clubId;
//   var url =
//       'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$clubIdPass/members.json?auth=$authToken';
//   try {
//     final response = await http.get(url);
//     final extractData = json.decode(response.body);

//     if (extractData == null) {
//       return;
//     }
//     final List<Member> loadedMemberDetails = [];
//     extractData.forEach(
//       (item, itemData) {
//         // memberIdList.add(itemData['memberId']);
//         loadedMemberDetails.add(
//           Member(
//               id: item,
//               memberName: itemData['memberName'],
//               imageUrl: itemData['imageUrl'],
//               memberBookList: itemData['memberBookList'],
//               currentBook: itemData['currentBook']
//               // bookCount: userData['bookCount'],
//               // clubCount: userData['clubCount'],
//               // dateJoined: userData['dateJoined'],
//               // bookProgress: extractData['bookProgress'],
//               // isAdmin: extractData['isAdmin'],
//               // hasCrown: extractData['hasCrown'],
//               ),
//         );
//       },
//     );
//     // getIndividualClubMember()
//     _memberList = loadedMemberDetails;
//     notifyListeners();
//   } catch (error) {
//     throw (error);
//   }
// }

// Future<void> addMember(context, String clubId, Member member) async {
//   final bookListMap = {};
//   final clubIdPass = clubId;
//   // final memberId = member.id;
//   final url =
//       'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$clubIdPass/members.json?auth=$authToken';
//   final response = await http.post(
//     url,
//     body: json.encode({
//       'memberName': member.memberName,
//       'hasCrown': false,
//       'isAdmin': false,
//       'imageUrl': member.imageUrl,
//     }),
//   );
//   final newMember = Member(
//     id: json.decode(response.body)['name'],
//     memberName: member.memberName,
//     hasCrown: false,
//     isAdmin: false,
//     imageUrl: member.imageUrl,
//     memberBookList: bookListMap,
//   );
//   _memberList.add(newMember);
//   notifyListeners();
//   Provider.of<ClubListProvider>(context, listen: false).fetchAndSetClubs();
// }

// Future<void> updateUserProgress(userId, clubId, listBooks, progress) async {
//   var passClubId = clubId;
//   var passUserId = userId;
//   String currentBook = '';
//   for (var i = 0; i < listBooks.length; i++) {
//     if (listBooks[i].isCurrentBook == true) {
//       currentBook = listBooks[i].id.toString();
//     }
//   }
//   final returnListUrl =
//       'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$passClubId/members/$passUserId/memberBookList/$currentBook.json?auth=$authToken';
//   try {
//     http.patch(
//       returnListUrl,
//       body: json.encode({
//         'bookProgress': progress,
//       }),
//     );
//   } catch (error) {
//     print(error);
//   }
//   final returnCurrentBookUrl =
//       'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$passClubId/members/$passUserId/currentBook.json?auth=$authToken';
//   try {
//     http.patch(
//       returnCurrentBookUrl,
//       body: json.encode({
//         'bookName': currentBook,
//         'progress': progress,
//       }),
//     );
//   } catch (error) {
//     print(error);
//   }
//   notifyListeners();
// }
