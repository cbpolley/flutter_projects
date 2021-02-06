import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../widgets/chosen_by.dart';
import '../widgets/rate_book_widget.dart';
import '../widgets/chat/chat_widget.dart';
import '../screens/booklist_screen.dart';
import '../providers/book_archive.dart';

class CurrentBook extends StatelessWidget with ChangeNotifier {
  final String clubId;

  CurrentBook({this.clubId});

  var returnUserName;

  String _currentBookId;

  String get currentBookId => _currentBookId;

  set currentBookId(String currentBookId) {
    _currentBookId = currentBookId;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    updateBookRating(rating) {
      Provider.of<BookArchive>(context, listen: false)
          .updateBookRating(clubId, rating);
    }

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('clubs')
            .doc(clubId)
            .collection('bookList')
            .where("isCurrentBook", isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('loading...'),
            );
          }
          // if (snapshot.data.docs.length > 0) {
          // getChosenByUserName(
          //       snapshot.data.docs.single.get(FieldPath(['chosenBy'])));
          // }
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black38, blurRadius: 10.0)
                  ],
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
                child: (snapshot.data.docs.length < 1 ||
                        snapshot.hasData == false)
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
                        child: Column(children: [
                          Expanded(
                            child: Row(children: [
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
                                          width: double.infinity,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              snapshot.data.docs.single[
                                                          'bookTitle'] ==
                                                      null
                                                  ? ''
                                                  : snapshot.data.docs.single
                                                      .get(FieldPath(
                                                          ['bookTitle']))
                                                      .toString(),
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
                                          child: SingleChildScrollView(
                                            child: Text(
                                              snapshot.data.docs
                                                          .single['bookDesc'] ==
                                                      null
                                                  ? ''
                                                  : snapshot.data.docs.single
                                                      .get(FieldPath(
                                                          ['bookDesc']))
                                                      .toString(),
                                              style: TextStyle(),
                                            ),
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
                                              snapshot.data.docs
                                                          .single['author'] ==
                                                      null
                                                  ? ''
                                                  : snapshot.data.docs.single
                                                      .get(
                                                          FieldPath(['author']))
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // ChosenBy(
                                      //     snapshot.data.docs.single['chosenBy'] ==
                                      //             null
                                      //         ? ''
                                      //         : getChosenByUserName(snapshot
                                      //             .data.docs.single
                                      //             .get(FieldPath(['chosenBy'])))),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: ChosenBy(snapshot
                                                .data.docs.single
                                                .get(FieldPath(['chosenBy']))
                                                .toString()),
                                          )
                                        ],
                                      ),
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
                                          SvgPicture.asset(
                                              'assets/images/bookClub_bc.svg'),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('clubs')
                                                  .doc(clubId)
                                                  .collection('bookList')
                                                  .doc(snapshot
                                                      .data.docs.single.id)
                                                  .collection('bookRankings')
                                                  .snapshots(),
                                              builder:
                                                  (context, ratingSnapshot) {
                                                var sumRating = 0.00;

                                                getSumRating() {
                                                  List ratings = ratingSnapshot
                                                      .data.docs
                                                      .toList();
                                                  ratings.forEach((item) => {
                                                        sumRating = sumRating +
                                                            double.parse(item
                                                                .get(FieldPath([
                                                                  'bookRating'
                                                                ]))
                                                                .toStringAsFixed(
                                                                    2)),
                                                      });
                                                  // .forEach((ratingValue) => {
                                                  //       sumRating = sumRating +
                                                  //           ratingValue.get();
                                                  //     });
                                                  sumRating = sumRating /
                                                      ratings.length;
                                                  if (sumRating.isNaN) {
                                                    sumRating = 0.00;
                                                  }
                                                  return sumRating;
                                                }

                                                return Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0),
                                                        color: Colors.black87,
                                                      ),
                                                      height: 40,
                                                      width: double.infinity,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: (ratingSnapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .active)
                                                            ? Text(
                                                                getSumRating()
                                                                    .toString())
                                                            : Text(
                                                                'loading...'),
                                                      )),
                                                );
                                              }),
                                        ]),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ]),
                      ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Theme.of(context).accentColor,
                      child: Text(
                        'Book List',
                        textAlign: TextAlign.right,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(BookListScreen.routeName, arguments: {
                          'clubId': clubId,
                          // 'bookList': _clubName['bookList'],
                        });
                      },
                    ),
                    if (snapshot.data.docs.length > 0)
                      RateBookWidget(updateBookRating),
                    // StarDisplayWidget(),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
