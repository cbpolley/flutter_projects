import '../widgets/book_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_archive.dart';

class BookList extends StatelessWidget {
  final bookListData;
  final clubId;

  BookList(this.bookListData, this.clubId);

  @override
  Widget build(BuildContext context) {
    final bookData = Provider.of<BookArchive>(context);

    final books = bookData.bookList;
    return Container(
      child: books.isEmpty
          ? Center(
              child: Text(
                'Your club currently has no books. Why not add one?',
                style: TextStyle(color: Colors.black),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: books.length,
              itemBuilder: (BuildContext ctx, int index) {
                // String key = bookListData.keys.elementAt(index);
                return new BookItem(
                  imageUrl: books[index].imageUrl,
                  bookTitle: books[index].bookTitle,
                  bookRating: books[index].bookRating,
                  isCurrentBook: books[index].isCurrentBook,
                  id: books[index].id,
                  clubId: clubId,
                );
              },
            ),
    );
  }
}
