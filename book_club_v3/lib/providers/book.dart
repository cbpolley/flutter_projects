import 'package:flutter/Material.dart';

class Book with ChangeNotifier {
  String id;
  String author;
  String bookTitle;
  String bookDesc;
  double bookRating;
  String imageUrl;
  int pages;
  String chosenBy;
  bool isCurrentBook;
  Map memberProgress = {};
  String isAdmin;

  Book({
    @required this.id,
    this.author,
    @required this.bookTitle,
    this.imageUrl,
    this.bookDesc,
    this.bookRating = 0,
    this.pages,
    this.chosenBy,
    this.isCurrentBook,
    this.memberProgress,
    this.isAdmin,
  });

  Book.fromJson(Map json) {
    this.id = json['id'];
    this.author = json['author'];
    this.bookTitle = json['bookTitle'];
    this.bookDesc = json['bookDesc'];
    this.bookRating = json['bookRating'];
    this.imageUrl = json['imageUrl'];
    this.pages = json['pages'];
    this.chosenBy = json['chosenBy'];
    this.isCurrentBook = json['isCurrentBook'];
    this.memberProgress = json['memberProgress'];
    this.isAdmin = json['isAdmin'];
  }
}
