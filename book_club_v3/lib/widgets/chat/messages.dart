import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({
    Key key,
    @required this.chatDocs,
    @required String currentUserAuth,
    @required String userName,
  })  : _currentUserAuth = currentUserAuth,
        super(key: key);

  final List<QueryDocumentSnapshot> chatDocs;
  final String _currentUserAuth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            // height:
            color: Colors.grey,
            child: ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    MessageBubble(
                      chatDocs[index]['text'],
                      chatDocs[index]['userName'],
                      // chatDocs[index]['userImage'],
                      chatDocs[index]['userId'] == _currentUserAuth,
                      key: ValueKey(chatDocs[index].id),
                    ),
                    (index > 0 &&
                            chatDocs[index]['userId'] !=
                                chatDocs[index - 1]['userId'])
                        ? SizedBox(
                            height: 8,
                          )
                        : SizedBox(
                            height: 0,
                          ),
                  ]);
                }),
          ),
        ),
      ],
    );
  }
}
