import '../widgets/book_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_archive.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class BookList extends StatelessWidget {
  final bookListData;
  final clubId;

  BookList(this.bookListData, this.clubId);

  getBookRating(location) {
    FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .collection('bookList')
        .doc(location.id)
        .collection('bookRating')
        .get()
        .then((item) {
      item.docs.forEach((doc) {
        print(doc.data());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookData = Provider.of<BookArchive>(context);

    final books = bookData.bookList;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('clubs')
            .doc(clubId)
            .collection('bookList')
            .snapshots(),
        builder: (context, bookListSnapshot) {
          return Container(
            child: bookListSnapshot.hasData == false ||
                    bookListSnapshot.data.docs.length < 1
                ? Center(
                    child: Text(
                      'Your club currently has no books. Why not add one?',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: bookListSnapshot.data.docs.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      // String key = bookListData.keys.elementAt(index);
                      return new BookItem(
                        imageUrl: bookListSnapshot.data.docs[index]
                            .get(FieldPath(['imageUrl'])),
                        bookTitle: bookListSnapshot.data.docs[index]
                            .get(FieldPath(['bookTitle'])),
                        bookRating:
                            getBookRating(bookListSnapshot.data.docs[index]),
                        isCurrentBook: bookListSnapshot.data.docs[index]
                            .get(FieldPath(['isCurrentBook'])),
                        id: bookListSnapshot.data.docs[index].id,
                        clubId: clubId,
                      );
                    },
                  ),
          );
        });
  }
}
