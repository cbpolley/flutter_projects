import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book.dart';

import '../providers/book_archive.dart';

class AddBookScreen extends StatelessWidget {
  static const routeName = '/add-book-screen';

  final _bookTitleController = TextEditingController();
  final _bookAuthorController = TextEditingController();
  final _bookPagesController = TextEditingController();
  final _bookDescriptionController = TextEditingController();
  final _bookImageController = TextEditingController();

  void dispose() {
    _bookTitleController.dispose();
    _bookAuthorController.dispose();
    _bookPagesController.dispose();
    _bookDescriptionController.dispose();
    _bookImageController.dispose();
  }

  Future<void> _addBookToArchive(context, Map bookMap, Map clubDetails) async {
    Book convertedBook = new Book.fromJson(bookMap);
    await Provider.of<BookArchive>(context, listen: false)
        .addBook(convertedBook, clubDetails);
    Navigator.pop(context);
  }

  var _isCurrentBook = false;

  @override
  Widget build(BuildContext context) {
    final clubDetails = ModalRoute.of(context).settings.arguments;
    // final authData = Provider.of<Auth>(context, listen: false);
    // final clubId = ModalRoute.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: _bookTitleController,
                    decoration: InputDecoration(
                      labelText: 'Book Title:',
                      labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                  ),
                  TextField(
                    controller: _bookAuthorController,
                    decoration: InputDecoration(
                      labelText: 'Book Author:',
                    ),
                  ),
                  TextField(
                    controller: _bookDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Book Description:',
                    ),
                  ),
                  TextField(
                    controller: _bookPagesController,
                    decoration: InputDecoration(
                      labelText: 'Total Pages:',
                    ),
                  ),
                  TextField(
                    controller: _bookImageController,
                    decoration: InputDecoration(
                      labelText: 'Image:',
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: _isCurrentBook ? Colors.green : Colors.grey,
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _isCurrentBook
                                      ? Icon(Icons.book)
                                      : Icon(Icons.not_interested),
                                  Switch(
                                    value: _isCurrentBook,
                                    onChanged: (_) {
                                      // setState(() {
                                      _isCurrentBook = !_isCurrentBook;
                                      // });
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _isCurrentBook
                                  ? Text('The current book')
                                  : Text('Not the current book'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.green,
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Text('Submit'),
                          splashColor: Colors.amber,
                          onTap: () {
                            Map bookMap = {
                              // 'id': "b${BookArchive().bookList.length}",
                              'bookTitle': _bookTitleController.text,
                              'author': _bookAuthorController.text,
                              'bookDesc': _bookDescriptionController.text,
                              'bookRating': 0.00,
                              'pages': int.parse(_bookPagesController.text),
                              'imageUrl': "assets/images/bookClub_bc.svg",
                              'isCurrentBook': _isCurrentBook,
                              'chosenBy': 'The current User',
                            };
                            _addBookToArchive(context, bookMap, clubDetails);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
