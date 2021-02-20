import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class QuestionBubble extends StatelessWidget {
  QuestionBubble(
    this.index,
    this.message,
    this.userName,
    this.createdAt,
    this.isMe, {
    this.key,
  });

  final int index;
  final Key key;
  final String message;
  final String userName;
  final createdAt;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(userName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.black)),
                  ),
                  Container(
                    child: Text(
                      DateFormat('HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              createdAt.millisecondsSinceEpoch * 1000)),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  "Q${index + 1}) $message",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
