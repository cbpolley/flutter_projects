// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'message_bubble.dart';

// class Messages extends StatelessWidget {
//   var currentUser = FirebaseAuth.instance;

//   // var chatDocs = await currentUser.data.documents;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('stuff'),
//     );
//   }
// }

// return FutureBuilder(
//   future: FirebaseAuth.instance.currentUser(),
//   builder: (ctx, futureSnapshot) {
//     if (futureSnapshot.connectionState == ConnectionState.waiting) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }
// final chatDocs = chatSnapshot.data.documents;
// return
// StreamBuilder(
// stream: Firebase.collection('chat')
//     .orderBy(
//       'createdAt',
//       descending: true,
//     )
//     .snapshots(),
// builder: (ctx, chatSnapshot) {
//   if (chatSnapshot.connectionState == ConnectionState.waiting) {
//     return Center(
//       child: CircularProgressIndicator(),
//     );
//   }
// final chatDocs = chatSnapshot.data.documents;
//   return
//     ListView.builder(
//   reverse: true,
//   itemCount: chatDocs.length,
//   itemBuilder: (ctx, index) => MessageBubble(
//     chatDocs[index]['text'],
//     chatDocs[index]['username'],
//     chatDocs[index]['userImage'],
//     chatDocs[index]['userId'] == FirebaseAuth.instance.currentUser.uid,
//     key: ValueKey(chatDocs[index].documentID),
//   ),
// );
// });
//   },
// );
// }
// ;
