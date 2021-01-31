import 'package:flutter/Material.dart';

class Member with ChangeNotifier {
  String id;
  String memberName;
  String imageUrl;
  Map memberBookList;
  double bookProgress;
  bool isAdmin;
  bool hasCrown;
  DateTime dateJoined;
  double bookCount;
  double clubCount;
  Map currentBook;

  Member({
    this.id,
    this.memberName,
    this.imageUrl,
    this.memberBookList,
    this.bookProgress,
    this.isAdmin = false,
    this.hasCrown = false,
    this.bookCount,
    this.clubCount,
    this.dateJoined,
    this.currentBook,
  });

  Member.fromJson(Map json) {
    this.id = json['id'];
    this.memberName = json['memberName'];
    this.imageUrl = json['imageUrl'];
    this.memberBookList = json['memeberBookList'];
    this.hasCrown = json['hasCrown'];
    this.isAdmin = json['isAdmin'];
    this.bookCount = json['bookCount'];
    this.clubCount = json['clubCount'];
    this.dateJoined = json['dateJoined'];
    this.currentBook = json['currentBook'];
    this.bookProgress = json['bookProgress'];
  }
}
