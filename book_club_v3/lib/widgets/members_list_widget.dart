import 'package:book_club_v3/models/current_book_model.dart';
import 'package:book_club_v3/providers/book_archive.dart';
import 'package:book_club_v3/providers/club_list_provider.dart';
import 'package:book_club_v3/providers/club_members.dart';
import 'package:book_club_v3/widgets/current_book.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/member_item.dart';
import 'package:flutter/material.dart';
import '../screens/add_member_screen.dart';
import '../widgets/update_progress_widget.dart';

class MembersListWidget extends StatelessWidget {
  // final Map memberList;
  Function updateUserProgress;
  final String clubId;
  final String currentBookId;

  MembersListWidget(
    // this.memberList,
    this.updateUserProgress,
    this.clubId,
    this.currentBookId,
  );

//   @override
//   _MembersListWidgetState createState() => _MembersListWidgetState();
// }

// class _MembersListWidgetState extends State<MembersListWidget> {
  var _hideBar = true;
  double _progressAmount = 0;

  // getMemberKeys() {
  //   List keys = [];
  //   widget.memberList.forEach((key, value) {
  //     keys.add(key);
  //   });
  //   return keys;
  // }
  var userName = '';

  // newInstance.get(FieldPath(['userName']));
  // .then((item) {
  // setState(() {});
  // userName = (item['userName'].toString());
  // });
  // return userName;

  // getCurrentBook() {

  //   // CollectionReference clubInstance = FirebaseFirestore.instance
  //   //     .collection('clubs')
  //   //     .doc(clubId)
  //   //     .collection('bookList');

  //   // await clubInstance
  //   //     .where("isCurrentBook", isEqualTo: true)
  //   //     .get()
  //   //     .then((document) {
  //   //   return clubInstance.doc(document.docs.single.id).toString();
  //   // });
  //   // return _currentBookId;
  // }

  @override
  Widget build(BuildContext context) {
    // var currentBookId = Provider.of<BookArchive>(con
    // var currentBookId =
    //     Provider.of<CurrentBookModel>(context, listen: false).currentBookId;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubId)
          .collection('members')
          .snapshots(),
      builder: (cx, memberListSnapshot) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Member List',
                        style: Theme.of(context).textTheme.headline5),
                    memberListSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? Text('... Members')
                        : Text('${memberListSnapshot.data.docs.length} Members',
                            style: Theme.of(context).textTheme.headline5),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 5,
                    color: Colors.grey[300],
                  ),
                ),
                color: Theme.of(context).cardColor,
              ),
              height: 135,
              child: (memberListSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      memberListSnapshot.hasData == false)
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'No members yet...',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                    )
                  : FutureBuilder(
                      builder: (context, _currentBookId) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: memberListSnapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MemberItem(
                              id: memberListSnapshot.data.docs[index].id,
                              currentClubId: clubId,
                              currentBookId: currentBookId,
                              // .tostring(),
                              // .data()['memberId'],
                              // isAdmin: widget.memberList[index]
                              //     ['isAdmin'],
                              // memberName: widget.memberList[key].memberName,
                              // currentBook: widget.memberList[key].currentBook,
                              // imageUrl: widget.memberList[index].imageUrl,
                            );
                          },
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      UpdateProgressWidget(updateUserProgress),
                      SizedBox(
                          height: 40,
                          width: 150,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text('add member'),
                              onPressed: () {
                                // Navigator.of(context).pushNamed(
                                //   AddMemberScreen.routeName,
                                //   arguments:
                                //       ScreenArguments(clubId, _currentBookId,
                              }))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
