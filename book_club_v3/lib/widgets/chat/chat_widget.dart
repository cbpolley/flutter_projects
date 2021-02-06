import 'package:book_club_v3/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  final clubId;
  final currentBookId;
  final currentBookTitle;
  // final userName;

  ChatWidget(this.clubId, this.currentBookId, this.currentBookTitle);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: {
          'clubMap': {
            'id': clubId,
            'bookId': currentBookId,
            'bookTitle': currentBookTitle,
            // 'userName': userName,
          }
        });
      },
      child: Container(
        height: 80,
        color: Colors.grey,
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('chatbox'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'did you hear about this book',
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      minRadius: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
