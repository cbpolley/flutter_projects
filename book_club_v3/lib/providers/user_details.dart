import 'dart:convert';

import 'package:book_club_v3/providers/member.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDetails extends ChangeNotifier {
  Member _userDetails;

  final String authToken;
  final String userId;

  UserDetails(this.authToken, this.userId, this._userDetails);

  Member get userDetails {
    return _userDetails;
  }

  Future<Member> fetchAndSetUserDetails(String userId) async {
    final userIdPass = userId;
    var url =
        'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/users/$userIdPass.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      Member loadedDetails;
      if (extractData == null) {
        return null;
      }
      // extractData.forEach((userId, userData) {
      loadedDetails = Member(
        id: userId,
        memberName: extractData['memberName'],
        imageUrl: extractData['imageUrl'],
        bookCount: extractData['bookCount'],
        clubCount: extractData['clubCount'],
        dateJoined: extractData['dateJoined'],
        // bookProgress: extractData['bookProgress'],
        // isAdmin: extractData['isAdmin'],
        // hasCrown: extractData['hasCrown'],
      );
      // });
      _userDetails = loadedDetails;
      notifyListeners();
      return loadedDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateUserDetails(Member userData) async {
    final userIdPass = userId;
    var url =
        'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/users/$userIdPass.json?auth=$authToken';
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'memberName': userData.memberName,
            'imageUrl': userData.imageUrl,
            'bookCount': userData.bookCount,
            'clubCount': userData.clubCount,
            'dateJoined': userData.dateJoined,
            // 'bookProgress': userData.bookProgress,
            // 'isAdmin': userData.isAdmin,
            // 'hasCrown': userData.hasCrown,
          },
        ),
      );
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      Member loadedDetails;
      if (extractData == null) {
        return;
      }
      // extractData.forEach((userId, userData) {
      loadedDetails = Member(
        id: userId,
        memberName: userData.memberName,
        imageUrl: userData.imageUrl,
        bookCount: userData.bookCount,
        clubCount: userData.clubCount,
        dateJoined: userData.dateJoined,
        // bookProgress: userData.bookProgress,
        // isAdmin: userData.isAdmin,
        // hasCrown: userData.hasCrown,
      );
      // });
      _userDetails = loadedDetails;
      notifyListeners();
      // return loadedDetails;ss
    } catch (error) {
      throw (error);
    }
  }
}
