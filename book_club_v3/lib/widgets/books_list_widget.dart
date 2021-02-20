import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/booklist_screen.dart';
import '../widgets/book_list_item.dart';

class BookListWidget extends StatelessWidget {
  final String clubId;

  BookListWidget(
    this.clubId,
  );

  Future checkIfCurrentBook() async {
    var booksCheck = await FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .collection('bookList')
        .where('isCurrentBook', isEqualTo: true)
        .get();

    var finalbooksCheck = (booksCheck.docs.length > 1)
        ? booksCheck.docs.sort((a, b) => a
            .data()['completedDate']
            .toDate()
            .compareTo(b.data()['completedDate'].toDate()))
        : booksCheck;

    return finalbooksCheck;
  }

  Future checkIfCompletedBooks() async {
    var booksCheck = await FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .collection('bookList')
        .where('completed', isEqualTo: true)
        .get();

    var finalbooksCheck = (booksCheck.docs.length > 1)
        ? booksCheck.docs.sort((a, b) => a
            .data()['completedDate']
            .toDate()
            .compareTo(b.data()['completedDate'].toDate()))
        : booksCheck;

    return finalbooksCheck;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
          padding: EdgeInsets.only(top: 8.0),
          decoration: BoxDecoration(
            // border: Border(
            //   top: BorderSide(
            //     width: 2,
            //     color: Colors.grey,
            //   ),
            //   bottom: BorderSide(
            //     width: 2,
            //     color: Colors.grey,
            //   ),
            // ),
            color: Colors.transparent,
          ),
          height: 135,
          child: Row(
            children: [
              FutureBuilder(
                  future: checkIfCompletedBooks(),
                  builder: (BuildContext ctx, bookListSnapshot) {
                    if (bookListSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (bookListSnapshot.hasData == true) {
                      return Expanded(
                        child: Container(
                          child: ListView.builder(
                            reverse: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: bookListSnapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return BookListItem(
                                imageUrl: bookListSnapshot.data.docs[index]
                                    .data()['imageUrl'],
                                title: bookListSnapshot.data.docs[index]
                                    .data()['bookTitle'],
                                bookRating: bookListSnapshot.data.docs[index]
                                    .data()['bookRating'],
                                completedDate: (bookListSnapshot
                                            .data.docs[index]
                                            .data()['completed'] ==
                                        true)
                                    ? bookListSnapshot.data.docs[index]
                                        .data()['completedDate']
                                    : null,
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return Container(height: 0, width: 0);
                  }),

              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('clubs')
                      .doc(clubId)
                      .collection('bookList')
                      .where('isCurrentBook', isEqualTo: true)
                      .snapshots(),
                  builder: (cx, currentBookSnapshot) {
                    return Row(children: [
                      (currentBookSnapshot.connectionState ==
                              ConnectionState.waiting)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : (currentBookSnapshot.data.docs.isNotEmpty)
                              ? BookListItem(
                                  imageUrl: currentBookSnapshot.data.docs.single
                                      .data()['imageUrl'],
                                  title: currentBookSnapshot.data.docs.single
                                      .data()['bookTitle'],
                                  bookRating: currentBookSnapshot
                                      .data.docs.single
                                      .data()['bookRating'],
                                  completedDate: 'Current',
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: Container(
                                      // width: 100,
                                      height: 50,
                                      child: RaisedButton(
                                        child: Text(
                                          'Choose the next book!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              BookListScreen.routeName,
                                              arguments: {
                                                'clubId': clubId,
                                                'choosing': true,
                                                'voting': false,
                                                // 'bookList': _clubName['bookList'],
                                              });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                      if (currentBookSnapshot.connectionState !=
                          ConnectionState.waiting)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            left: 16.0,
                            right: 8.0,
                            top: 0.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                (currentBookSnapshot.data.docs.isNotEmpty)
                                    ? 'Next book \n vote'
                                    : 'Votes',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Material(
                                color: Colors.transparent,
                                child: Expanded(
                                  child: Container(
                                    width: 75,
                                    height: 55,
                                    // decoration: BoxDecoration(
                                    //     borderRadius:
                                    //         BorderRadius.all(Radius.circular(8)),
                                    //     border: Border.all(
                                    //         color: Theme.of(context)
                                    //             .textTheme
                                    //             .bodyText1
                                    //             .color,
                                    //         style: BorderStyle.solid,
                                    //         width: 5)),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      // splashColor: Colors.white60,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.how_to_vote,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
                                            ),
                                            StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('clubs')
                                                  .doc(clubId)
                                                  .collection('nextBookVote')
                                                  .snapshots(),
                                              builder: (ctx, voteSnapshot) {
                                                return (voteSnapshot
                                                            .connectionState ==
                                                        ConnectionState.waiting)
                                                    ? Container(
                                                        height: 0, width: 0)
                                                    : Container(
                                                        child: Text(
                                                            voteSnapshot.data
                                                                .docs.length
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5),
                                                      );
                                              },
                                            )
                                          ]),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            BookListScreen.routeName,
                                            arguments: {
                                              'clubId': clubId,
                                              'voting': true,
                                              // 'bookList': _clubName['bookList'],
                                            });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ]);
                  }),
              // Spacer(),
            ],
          )),
    );
  }
}
