import '../widgets/book_item.dart';
import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  final bookListData;
  final clubId;

  BookList(this.bookListData, this.clubId);

  // void printLog() {
  //   bookListData.forEach((key) {
  //     print(bookListData[key]);
  //   });
  // }

  getKeyID() {
    return (bookListData == null) ? [] : bookListData.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<BookArchive>(context);
    // final bookData = Provider.of<BookArchive>(context);
    // final books = bookData.bookList;
    // getKeyID();
    var keys = getKeyID();
    return Container(
      child: keys.length == 0
          ? Center(
              child: Text('Your club currently has no books.'),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: bookListData.length,
              itemBuilder: (BuildContext ctx, int index) {
                String key = bookListData.keys.elementAt(index);
                return new BookItem(
                  imageUrl: bookListData[key]['imageUrl'],
                  bookTitle: bookListData[key]['bookTitle'],
                  bookRating: bookListData[key]['bookRating'],
                  isCurrentBook: bookListData[key]['isCurrentBook'],
                  id: key,
                  clubId: clubId,
                );
              },
            ),
    );
  }
}
