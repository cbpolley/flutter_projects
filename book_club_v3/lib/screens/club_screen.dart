import 'package:book_club_v3/models/current_book_model.dart';
import 'package:book_club_v3/providers/book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/current_book.dart';
import '../widgets/members_list_widget.dart';
import '../widgets/rate_book_widget.dart';
import '../widgets/chat/chat_widget.dart';
import 'booklist_screen.dart';
import '../providers/book_archive.dart';
import '../providers/club_members.dart';
import '../models/user_model.dart';

class ClubScreen extends StatefulWidget {
  final clubName;
  final clubId;
  final adminId;
  // 'members': members,
  final imageUrl;
  // 'bookList': bookList,
  // final currentUser;

  ClubScreen({
    this.adminId,
    this.clubId,
    this.clubName,
    // this.currentUser,
    this.imageUrl,
  });

  static const routeName = '/club-screen';

  @override
  _ClubScreenState createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  var _isInit = true;
  var _isLoading = true;
  // @override
  // void initState() {
  //   // Future.delayed(Duration.zero).then((_) {
  //   //   Provider.of<BookArchive>(context).getCurrentBookId(widget.clubId);
  //   // });
  //   super.initState();
  // }

  var currentBookId;
  var currentBookTitle;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // _getCurrentBookInfo(context);

      // await Provider.of<BookArchive>(context).getCurrentBookId(widget.clubId);

      //     .then((_) {
      //   setState(() {
      //     currentBookId = Provider.of<BookArchive>(context).currentBookID;
      //     currentBookTitle = Provider.of<BookArchive>(context).currentBookTitle;
      //     _isLoading = false;
      //   });
      // });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<Map> _getCurrentBookInfo(BuildContext context) async {
    return await Provider.of<BookArchive>(context)
        .getCurrentBookId(widget.clubId);
  }

  // onGenerateRoute:

  @override
  Widget build(BuildContext context) {
    // var _clubName =
    //     ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    // Future<List> getCurrentBookInfo() async {
    //   return [currentBookId, currentBookTitle];
    // }

    // final userModel = Provider.of<UserModel>(context);
    // final userName = userModel.userName;
    // _clubName =
    //     ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    // if (_isInit) {
    //   Provider.of<BookArchive>(context)
    //       .getCurrentBookId(context, _clubName['clubId']);
    //   currentBookId = Provider.of<BookArchive>(context).currentBookID;
    //   _isInit = !_isInit;
    // }

    updateUserProgress(progress) {
      Provider.of<ClubMembers>(context, listen: false)
          .updateUserProgress(widget.clubId, progress);
    }

    // Future<String> _currentBookId = Future<String>.delayed(
    //     Duration.zero, () => CurrentBookModel().currentBookId);

    return FutureBuilder(
        future: _getCurrentBookInfo(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: (Text('Loading...')),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.clubName,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              body: Container(
                child: Column(
                  children: [
                    CurrentBook(clubId: widget.clubId),
                    SizedBox(
                      width: double.infinity,
                      height: 10,
                    ),
                    MembersListWidget(updateUserProgress, widget.clubId,
                        snapshot.data['currentBookID']),
                    ChatWidget(widget.clubId, snapshot.data['currentBookID'],
                        snapshot.data['currentBookTitle']),
                  ],
                ),
              ),
            );
          }
        });
  }
}
