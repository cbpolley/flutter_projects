import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../providers/book_archive.dart';
import '../providers/book.dart';
import '../widgets/chosen_by.dart';

class CurrentBook extends StatefulWidget with ChangeNotifier {
  final String clubId;
  final List bookList;
  CurrentBook(this.clubId, this.bookList);

  @override
  _CurrentBookState createState() => _CurrentBookState();
}

class _CurrentBookState extends State<CurrentBook> {
  // String clubId;
  // _CurrentBookState(this.clubId);

  @override
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {}
    _isInit = false;
    super.didChangeDependencies();
  }

  // Future<void> getBookList() async {
  //   final bookData =
  //   return bookData;
  // }

  @override
  Widget build(BuildContext context) {
    Book currentBook;

    final List bookData = (widget.bookList == null) ? [] : widget.bookList;

    if (bookData.length > 0) {
      for (var item in bookData) {
        if (item.isCurrentBook == true) {
          currentBook = Book(
            author: item.author,
            bookDesc: item.bookDesc,
            bookRating: item.bookRating,
            bookTitle: item.bookTitle,
            chosenBy: item.chosenBy,
            id: item.id,
            imageUrl: item.imageUrl,
            isCurrentBook: item.isCurrentBook,
            pages: item.pages,
          );
        }
      }
    }

    return Consumer<BookArchive>(
      builder: (cx, bookData, child) => Container(
        // color: Colors.grey,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10.0)],
          border: Border.all(
              style: BorderStyle.solid,
              width: 6,
              color: Theme.of(context).cardColor),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Theme.of(context).cardColor,
        ),

        margin: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: currentBook == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('No current book'),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              margin: EdgeInsets.only(right: 16.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                      // color: Theme.of(context).cardColor,
                                      width: double.infinity,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          currentBook.bookTitle,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        currentBook.bookDesc,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            width: 1.5,
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                      width: double.infinity,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          currentBook.author,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ChosenBy(currentBook.chosenBy),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              child: Container(
                                color: Colors.white,
                                child: Stack(
                                  overflow: Overflow.clip,
                                  fit: StackFit.expand,
                                  alignment: Alignment.topCenter,
                                  children: [
                                    (currentBook.imageUrl ==
                                            'assets/images/bookClub_bc.svg')
                                        ? SvgPicture.asset(
                                            'assets/images/bookClub_bc.svg')
                                        : Image.network(currentBook.imageUrl,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0),
                                          color: Colors.black87,
                                        ),
                                        height: 40,
                                        width: double.infinity,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: (currentBook.bookRating ==
                                                  null)
                                              ? Text(
                                                  'No Rating yet!',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .color),
                                                )
                                              : Text(
                                                  currentBook.bookRating
                                                      .toString(),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
