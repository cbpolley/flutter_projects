import '../widgets/star_display_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/current_book.dart';
import '../widgets/members_list_widget.dart';
import '../widgets/rate_book_widget.dart';
import '../widgets/chat/chat_widget.dart';
import 'booklist_screen.dart';
import '../providers/book_archive.dart';
import '../providers/club_members.dart';

class ClubScreen extends StatelessWidget {
  static const routeName = '/club-screen';

  var membersList;
  var bookData;
  var bookList;
  var _isInit = true;
  var _isLoading = true;
  var currentBookId;

  Future<List> getMembersList(context, clubName) async {
    return membersList = Provider.of<ClubMembers>(context).memberList;
  }

  Future<List> getBookList(context, clubName) async {
    bookList = Provider.of<BookArchive>(context).bookList;
    bookList.forEach(
      (item) {
        if (item.isCurrentBook == true) {
          currentBookId = item.id;
        }
      },
    );
    // for (var item in bookList)

    return bookList;
    // List bookList = bookData.bookList;
  }

  @override
  Widget build(BuildContext context) {
    final clubName =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    if (_isInit) {
      Provider.of<BookArchive>(context).fetchAndSetBooks(clubName['clubId']);
      Provider.of<ClubMembers>(context).getAllClubMembers(clubName['clubId']);
      _isInit = !_isInit;
    }

    updateBookRating(rating) {
      Provider.of<BookArchive>(context, listen: false)
          .updateBookRating(clubName['clubId'], bookList, rating);
    }

    updateUserProgress(progress) {
      Provider.of<ClubMembers>(context, listen: false).updateUserProgress(
          clubName['currentUser'], clubName['clubId'], bookList, progress);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          clubName['clubName'],
          style: TextStyle(
              fontSize: 18,
              letterSpacing: 1.2,
              color: Theme.of(context).textTheme.headline6.color),
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([
          getMembersList(context, clubName['clubId']),
          getBookList(context, clubName['clubId'])
        ]),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Container(
            child: Column(
              children: [
                CurrentBook(clubName['clubId'], bookList),
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
                            'clubId': clubName['clubId'],
                            'bookList': bookList,
                          });
                        },
                      ),
                      RateBookWidget(updateBookRating),
                      // StarDisplayWidget(),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 10,
                ),
                MembersListWidget(membersList, updateUserProgress,
                    clubName['clubId'], currentBookId),
                ChatWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
