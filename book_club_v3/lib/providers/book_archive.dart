import 'dart:convert';
// import 'dart:html';
import 'package:provider/provider.dart';

import '../models/current_book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'book.dart';

// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'club.dart';

class BookArchive with ChangeNotifier {
  List<Book> _bookList;

  String _currentBookID;
  String _currentBookTitle;

  // final String authToken;
  // final String userId;

  // BookArchive(this._bookList, this._currentBookID);

  List<Book> get bookList {
    return [..._bookList];
  }

  String get currentBookID {
    return _currentBookID;
  }

  String get currentBookTitle {
    return _currentBookTitle;
  }

  set currentBookID(value) => _currentBookID = value;

  Book findByid(String id) {
    return _bookList.firstWhere((book) => book.id == id);
  }

  // Future<void> fetchAndSetBooks(String clubId) async {
  //   final clubIdPass = clubId;
  //   var url =
  //       'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$clubIdPass/bookList.json?auth=$authToken';
  //   try {
  //     final response = await http.get(url);
  //     final extractData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Book> loadedBooks = [];
  //     if (extractData == null) {
  //       return;
  //     }
  //     extractData.forEach(
  //       (bookId, bookData) {
  //         loadedBooks.add(
  //           Book(
  //             id: bookId,
  //             bookTitle: bookData['bookTitle'],
  //             author: bookData['author'],
  //             bookDesc: bookData['bookDesc'],
  //             bookRating: bookData['bookRating'],
  //             imageUrl: bookData['imageUrl'],
  //             pages: bookData['pages'],
  //             chosenBy: bookData['chosenBy'],
  //             isCurrentBook: bookData['isCurrentBook'],
  //           ),
  //         );
  //       },
  //     );
  //     _bookList = loadedBooks;
  //     notifyListeners();
  //     return loadedBooks;
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  Future<Map> getCurrentBookId(String clubId) async {
    CollectionReference clubInstance = FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .collection('bookList');

    try {
      await clubInstance
          .where("isCurrentBook", isEqualTo: true)
          .get()
          .then((document) {
        if (document.docs.length > 0) {
          _currentBookID = document.docs.single.id;
        }
        clubInstance.doc(_currentBookID).get().then((item) {
          _currentBookTitle = item.data()['bookTitle'];
        });
      });
    } catch (error) {
      print(error);
    }
// notifyListeners();
    return {
      'currentBookID': _currentBookID,
      'currentBookTitle': _currentBookTitle
    };
  }

  // }

  Future<void> addBook(Book newBook, Map clubDetails) async {
    final addBook = {
          'bookTitle': newBook.bookTitle,
          'bookDesc': newBook.bookDesc,
          'author': newBook.author,
          'chosenBy': newBook.chosenBy,
          'imageUrl': newBook.imageUrl,
          'pages': newBook.pages,
          'isCurrentBook': newBook.isCurrentBook,
        },
        sendData = json.encode(addBook);

    final clubInstance = FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubDetails['clubId'])
        .collection('bookList');

    final bookRating = {
      newBook.chosenBy: 0.00,
    };
    clubInstance.add(json.decode(sendData)).then((DocumentReference docRef) {
      clubInstance
          .doc(docRef.id.toString())
          .collection('bookRating')
          .add(bookRating);
    });
    if (newBook.isCurrentBook == true) {
      setAsCurrentBook(newBook.id, clubDetails['clubId']);
    }
    // notifyListeners();
  }

  Future<void> setAsCurrentBook(String id, String clubId) async {
    CollectionReference clubInstance = FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .collection('bookList');

    clubInstance.where("isCurrentBook", isEqualTo: true).get().then((document) {
      clubInstance
          .doc(document.docs.single.id)
          .update({'isCurrentBook': false});
    });

    clubInstance.doc(id).update({'isCurrentBook': true});
    _currentBookID = id;
    CurrentBookModel().currentBookId = id;
    // notifyListeners();
  }

  Future<void> updateBookRating(String clubId, double rating) async {
    final user = FirebaseAuth.instance.currentUser;

    CollectionReference clubInstance = FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .collection('bookList');

    clubInstance.where("isCurrentBook", isEqualTo: true).get().then((document) {
      clubInstance
          .doc(document.docs.single.id)
          .collection('bookRankings')
          .doc(user.uid)
          .update({'bookRating': rating});
    });
    // notifyListeners();
  }
}
