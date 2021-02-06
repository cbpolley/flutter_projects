import 'dart:math';

import 'package:book_club_v3/providers/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/chat/message_bubble.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../providers/book_archive.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';
import '../providers/auth.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  // final clubId;
  // // final currentBookId;

  // ChatScreen(this.clubId)

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var clubName;
  var currentBookId;
  var currentBookTitle;
  var userName;
  FirebaseMessaging fbm;
  NotificationSettings settings;

  String _currentUserAuth;

  @override
  void initState() {
    super.initState();
    fbm = FirebaseMessaging.instance;
    initialiseMessagingSettings();
  }

  void initialiseMessagingSettings() async {
    NotificationSettings settings = await fbm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _currentUserAuth = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUserAuth)
        .get()
        .then((doc) {
      userName = doc.data()['userName'];
    });

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Widget _buildListItem(BuildContext context, String text) {
    return Container(
        child: Text(
      text,
      style: TextStyle(
        color: Colors.black,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var _questionBoxMode = false;
    final Map chatLocationDetails =
        ModalRoute.of(context).settings.arguments as Map;

    final clubId = chatLocationDetails['clubMap']['id'];
    final bookId = chatLocationDetails['clubMap']['bookId'];
    final bookTitle = chatLocationDetails['clubMap']['bookTitle'];
    // final userName = chatLocationDetails['clubMap']['userName'];

    // final authData = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(bookTitle),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('clubs')
              .doc(clubId)
              .collection('bookList')
              .doc(bookId)
              .collection('chat')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            final chatDocs = snapshot.data.docs;
            return Column(
              children: [
                Container(
                  height: 40,
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('question box'),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          _questionBoxMode = !_questionBoxMode;
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Messages(
                      chatDocs: chatDocs,
                      currentUserAuth: _currentUserAuth,
                      userName: userName),
                ),
                NewMessage(clubId, bookId, userName),
              ],
            );
          },
        ),
      ),
    );
  }
}

//   // Future<void> getSettings() async {
//   //   NotificationSettings settings = await fbm.requestPermission(
//   //     alert: true,
//   //     announcement: false,
//   //     badge: true,
//   //     carPlay: false,
//   //     criticalAlert: false,
//   //     provisional: false,
//   //     sound: true,
//   //   );
//   //   print(settings);
//   // }
//   // fbm.requestPermission();

//   // fbm.configure(onMessage: (msg) {
//   //   print(msg);
//   //   return;
//   // }, onLaunch: (msg) {
//   //   print(msg);
//   //   return;
//   // }, onResume: (msg) {
//   //   print(msg);
//   //   return;
//   // });
//   // fbm.getInitialMessage(msg)
//   // fbm.subscribeToTopic('chat');
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('FlutterChat'),
//         actions: [
//           DropdownButton(
//             underline: Container(),
//             icon: Icon(
//               Icons.more_vert,
//               color: Theme.of(context).primaryIconTheme.color,
//             ),
//             items: [
//               DropdownMenuItem(
//                 child: Container(
//                   child: Row(
//                     children: <Widget>[
//                       Icon(Icons.exit_to_app),
//                       SizedBox(width: 8),
//                       Text('Logout'),
//                     ],
//                   ),
//                 ),
//                 value: 'logout',
//               ),
//             ],
//             onChanged: (itemIdentifier) {
//               if (itemIdentifier == 'logout') {
//                 FirebaseAuth.instance.signOut();
//               }
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Messages(),
//             ),
//             NewMessage(),
//           ],
//         ),
//       ),
//     );
//   }
// }
