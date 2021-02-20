import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/book_item.dart';

String apiKey = "AIzaSyDpYtHmeaA2KgBeP9BlTRbXNc8Or0iLXa8";

class LibrarySearch with ChangeNotifier {
  List<BookItem> _returnedBooks = [];

  List<BookItem> get returnedBooks {
    return _returnedBooks;
  }

  Future<List> searchForTerm(searchTerm, clubId) async {
    var user = FirebaseAuth.instance.currentUser.uid;
    searchTerm = searchTerm.toString().trim().replaceAll(' ', '+');
    var url = 'https://www.googleapis.com/books/v1/volumes?q=$searchTerm';

    try {
      final response = await http.get(url);
      final extractResponse =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractResponse == null) {
        return [];
      }
      final List<BookItem> returnedBooks = [];
      final List extractedDocMap = extractResponse['items'];

      // extractedDocMap.forEach((book)
      for (var i = 0; i < extractedDocMap.length; i++) {
        returnedBooks.add(BookItem(
          author: extractedDocMap[i]['volumeInfo'].containsKey('authors')
              ? extractedDocMap[i]['volumeInfo']['authors']
              : [""],
          bookTitle: extractedDocMap[i]['volumeInfo'].containsKey('title')
              ? extractedDocMap[i]['volumeInfo']['title']
              : "",
          bookDesc: extractedDocMap[i]['volumeInfo'].containsKey('description')
              ? extractedDocMap[i]['volumeInfo']['description']
              : extractedDocMap[i]['volumeInfo'].containsKey('subtitle')
                  ? extractedDocMap[i]['volumeInfo']['subtitle']
                  : "",
          pages: extractedDocMap[i]['volumeInfo'].containsKey('pageCount')
              ? extractedDocMap[i]['volumeInfo']['pageCount']
              : 0,
          imageUrl: extractedDocMap[i]['volumeInfo'].containsKey('imageLinks')
              ? extractedDocMap[i]['volumeInfo']['imageLinks']['smallThumbnail']
              : "",
          isFromSearch: true,
          isVoting: false,
          userUID: user,
          clubId: clubId[0],
        ));
      }

      _returnedBooks = returnedBooks;
    } catch (error) {
      print(error);
    }
  }
}
