import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
    this.message,
    this.userName,
    // this.userImage,
    this.isMe, {
    this.key,
  });

  final Key key;
  final String message;
  final String userName;
  // final String userImage;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  userName,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.black),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ),
            ],
          ),
        )
      ],
    );
    // Positioned(
    //   top: 0,
    //   left: isMe ? null : 120,
    //   right: isMe ? 120 : null,
    //   child: CircleAvatar(
    //     backgroundImage: NetworkImage(
    //       userImage,
    //     ),
    //   ),
    // ),
  }
}
