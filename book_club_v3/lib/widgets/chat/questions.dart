import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'question_bubble.dart';

class Questions extends StatelessWidget {
  const Questions({
    Key key,
    @required this.questionDocs,
    @required String currentUserAuth,
    @required String userName,
  })  : _currentUserAuth = currentUserAuth,
        super(key: key);

  final List<QueryDocumentSnapshot> questionDocs;
  final String _currentUserAuth;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: (questionDocs.length > 0)
                  ? ListView.builder(
                      reverse: false,
                      itemCount: questionDocs.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          QuestionBubble(
                            index,
                            questionDocs[index]['text'],
                            questionDocs[index]['userName'],
                            questionDocs[index]['createdAt'],
                            // questionDocs[index]['userImage'],
                            questionDocs[index]['userId'] == _currentUserAuth,
                            key: ValueKey(questionDocs[index].id),
                          ),
                          (index > 0 &&
                                  questionDocs[index]['userId'] !=
                                      questionDocs[index - 1]['userId'])
                              ? SizedBox(
                                  height: 8,
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                        ]);
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.question_answer_rounded,
                            color: Colors.white,
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          Text(
                            'This book doesn\'t have any talking points yet. \n\n Why not post some?',
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ]),
      ),
    );
  }
}
