// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// import '../widgets/chat/messages.dart';
// import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Row(
      children: [
        Text(document['text'].toString()),
        // Text(document['name']),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]));
          }),
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
