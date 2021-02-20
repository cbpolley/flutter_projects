import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/book_archive.dart';

class BookSearchItem extends StatelessWidget {
  final String id;
  final String author;
  final String bookTitle;
  final String bookDesc;
  final double bookRating;
  final String imageUrl;
  final int pages;
  final bool isCurrentBook;
  final String clubId;

  BookSearchItem({
    this.id,
    this.author,
    this.bookTitle,
    this.bookDesc,
    this.bookRating,
    this.imageUrl,
    this.pages,
    this.isCurrentBook,
    this.clubId,
  });

  ValueNotifier<bool> _isCurrentBook = ValueNotifier(false);

  setAsCurrentBook(context, String bookId, String clubId) {
    if (_isCurrentBook.value == false) {
      Provider.of<BookArchive>(context).setAsCurrentBook(bookId, clubId);
    }
  }

  var sumRating = 0.00;
  getSumRating(ratingSnapshot) {
    if (ratingSnapshot.connectionState != ConnectionState.waiting) {
      List ratings = ratingSnapshot.data.docs.toList();
      ratings.forEach((item) => {
            sumRating = sumRating +
                double.parse(item.get(FieldPath(['bookRating'])).toString())
          });
      sumRating = sumRating / ratings.length;
      if (sumRating.isNaN) {
        sumRating = 0.00;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final bookData = Provider.of<BookArchive>(context);

    return Card(
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
                color: (isCurrentBook == true)
                    ? Theme.of(context).accentColor
                    : Theme.of(context).cardColor,
                width: 6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                        child:
                            // imageUrl == 'assets/images/bookClub_bc.svg'
                            SvgPicture.asset('assets/images/bookClub_bc.svg')
                        // : Image(
                        //     image: NetworkImage(imageUrl),
                        //   )
                        // decoration: new BoxDecoration(
                        //   image: new DecorationImage(
                        //     image: NetworkImage(imageUrl),
                        //     fit: BoxFit.fitHeight,
                        //   ),
                        // ),
                        ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  bookTitle,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .color),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _isCurrentBook,
                          builder: (BuildContext context, bool hasError,
                              Widget child) {
                            return Expanded(
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                child: (isCurrentBook)
                                    ? Container(
                                        width: 100,
                                        color: Theme.of(context).accentColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            ('Current Book'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : FlatButton(
                                        color: Theme.of(context).canvasColor,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Make this the current book',
                                          ),
                                        ),
                                        onPressed: () {
                                          Provider.of<BookArchive>(context,
                                                  listen: false)
                                              .setAsCurrentBook(id, clubId);
                                          // bookData.setAsCurrentBook(id, clubId);
                                        },
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          width: 50, child: Text(bookRating.toString()))),
                ]),
          ),
        ),
      ),
    );
  }
}
