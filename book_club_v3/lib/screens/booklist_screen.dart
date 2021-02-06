import 'package:book_club_v3/providers/book_archive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/book_list.dart';
import '../screens/add_book_screen.dart';

class BookListScreen extends StatefulWidget {
  static const routeName = '/book-screen';

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  var _isInit = true;
  var _isLoading = false;
  var clubId = '';

  @override
  void initState() {
    super.initState();
  }

  // void getClubId(clubIdIn) {
  //   clubId = clubIdIn;

  //   Provider.of<BookArchive>(context).fetchAndSetBooks(clubId).then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     Provider.of<BookArchive>(context).fetchAndSetBooks(clubId).then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  Widget build(BuildContext context) {
    Map<String, dynamic> clubArguments =
        ModalRoute.of(context).settings.arguments;
    // getClubId(clubArguments['clubId']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Book club'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add a book',
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddBookScreen.routeName, arguments: clubArguments);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: (_isLoading)
                ? Center(
                    child: Text('Loading...'),
                  )
                : BookList(
                    clubArguments['bookList'],
                    clubArguments['clubId'],
                  ),
          ),
        ],
      ),
    );
  }
}
