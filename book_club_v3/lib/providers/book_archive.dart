import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'book.dart';

class BookArchive extends ChangeNotifier {
  List<Book> _bookList = [];

  final String authToken;
  final String userId;

  BookArchive(this.authToken, this.userId, this._bookList);

  List<Book> get bookList {
    return [..._bookList];
  }

  Book findByid(String id) {
    return _bookList.firstWhere((book) => book.id == id);
  }

  Future<void> fetchAndSetBooks(String clubId) async {
    final clubIdPass = clubId;
    var url =
        'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$clubIdPass/bookList.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Book> loadedBooks = [];
      if (extractData == null) {
        return;
      }
      extractData.forEach(
        (bookId, bookData) {
          loadedBooks.add(
            Book(
              id: bookId,
              bookTitle: bookData['bookTitle'],
              author: bookData['author'],
              bookDesc: bookData['bookDesc'],
              bookRating: bookData['bookRating'],
              imageUrl: bookData['imageUrl'],
              pages: bookData['pages'],
              chosenBy: bookData['chosenBy'],
              isCurrentBook: bookData['isCurrentBook'],
            ),
          );
        },
      );
      _bookList = loadedBooks;
      notifyListeners();
      return loadedBooks;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addBook(Book book, String clubId) async {
    final url =
        'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$clubId/bookList.json?auth=$authToken';
    final response = await http.post(
      url,
      body: json.encode({
        'author': book.author,
        'bookTitle': book.bookTitle,
        'bookDesc': book.bookDesc,
        'imageUrl': book.imageUrl,
        'pages': book.pages,
        'bookRating': book.bookRating,
        'chosenBy': book.chosenBy,
        'isCurrentBook': book.isCurrentBook,
      }),
    );
    final newBook = Book(
      id: json.decode(response.body)['name'],
      author: book.author,
      bookTitle: book.bookTitle,
      bookDesc: book.bookDesc,
      bookRating: book.bookRating,
      imageUrl: book.imageUrl,
      pages: book.pages,
      chosenBy: book.chosenBy,
      isCurrentBook: book.isCurrentBook,
    );
    if (newBook.isCurrentBook == true) {
      setAsCurrentBook(newBook.id, clubId);
    }
    _bookList.add(newBook);
    print(_bookList);
    notifyListeners();
  }

  Future<void> setAsCurrentBook(String id, String clubId) async {
    var passBookId = id;
    var passClubId = clubId;

    final url =
        'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$passClubId/bookList.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Book> loadedBooks = [];
      if (extractData == null) {
        return;
      }
      extractData.forEach(
        (bookId, bookData) {
          loadedBooks.add(
            Book(
              id: bookId,
              bookTitle: bookData['bookTitle'],
              author: bookData['author'],
              bookDesc: bookData['bookDesc'],
              bookRating: bookData['bookRating'],
              imageUrl: bookData['imageUrl'],
              pages: bookData['pages'],
              chosenBy: bookData['chosenBy'],
              isCurrentBook: bookData['isCurrentBook'],
            ),
          );
        },
      );
      _bookList = loadedBooks;
    } catch (error) {
      throw (error);
    }
    _bookList.forEach(
      (book) {
        (book.id == passBookId)
            ? book.isCurrentBook = true
            : book.isCurrentBook = false;
        final returnUrl =
            'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$passClubId/bookList/${book.id}.json?auth=$authToken';
        try {
          final response = http.patch(
            returnUrl,
            body: json.encode({
              'isCurrentBook': book.isCurrentBook,
            }),
          );
          print(response);
        } catch (error) {}
      },
    );
    notifyListeners();
  }

  Future<void> updateBookRating(clubId, listBooks, double rating) async {
    var passClubId = clubId;
    String currentBook = '';
    for (var i = 0; i < listBooks.length; i++) {
      if (listBooks[i].isCurrentBook == true) {
        currentBook = listBooks[i].id.toString();
      }
    }
    final returnUrl =
        'https://book-club-e9ef5-default-rtdb.europe-west1.firebasedatabase.app/clubs/$passClubId/bookList/$currentBook.json?auth=$authToken';
    try {
      http.patch(
        returnUrl,
        body: json.encode({
          'bookRating': rating,
        }),
      );
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }
}
