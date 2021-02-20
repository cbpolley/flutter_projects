import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/chat_screen.dart';

class TalkingPointsWidget extends StatelessWidget {
  final clubId;
  final userId;
  final currentBookId;
  final currentBookTitle;
  // final userName;

  // Future<bool> checkIfQuestions() async {
  //   var testBool;
  //   await FirebaseFirestore.instance
  //       .collection('clubs')
  //       .doc(clubId)
  //       .collection('bookList')
  //       .doc(currentBookId)
  //       .get()
  //       .then((doc) async {
  //     // try {
  //     //   testBool = await doc.data()['questions'];
  //     // } catch (err) {
  //     //   return false;
  //     // }
  //     return (doc.collection('questions') == null) ? false : true;
  //   });
  // }

  Future<bool> testIfQuestionExists() async {
    var testQuestion = await FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .collection('bookList')
        .doc(currentBookId)
        .collection('questions')
        .get();

    bool doesQuestionExist = testQuestion.docs.isNotEmpty;

    return doesQuestionExist;
  }

  TalkingPointsWidget(
      this.clubId, this.userId, this.currentBookId, this.currentBookTitle);
  @override
  Widget build(BuildContext context) {
    return (currentBookId != null)
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: {
                'clubMap': {
                  'id': clubId,
                  'bookId': currentBookId,
                  'bookTitle': currentBookTitle,
                  // 'userName': userName,
                  'questionsOpen': true
                },
              });
            },
            child: Container(
              // height: 40,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                // color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Discussion Points',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    FutureBuilder<bool>(
                        future: testIfQuestionExists(),
                        builder: (ctx, questionFuture) => (questionFuture
                                    .connectionState ==
                                ConnectionState.waiting)
                            ? Text('...')
                            : (questionFuture.data == true)
                                ? StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('clubs')
                                        .doc(clubId)
                                        .collection('bookList')
                                        .doc(currentBookId)
                                        .collection('questions')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: Text('...'),
                                        );
                                      }
                                      return Container(
                                          margin: EdgeInsets.only(left: 8.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(8),
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              color:
                                                  (snapshot.data.docs.length >
                                                          0)
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : Colors.grey),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: Text(
                                              (snapshot.hasData)
                                                  ? snapshot.data.docs.length
                                                      .toString()
                                                  : '0',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4));
                                    })
                                : Container(
                                    margin: EdgeInsets.only(left: 8.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(8),
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        color: Colors.grey),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text(
                                      '0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    )))
                  ]),
            ),
          )
        : Container(
            height: 0.0,
            width: 0.0,
          );
  }
}
