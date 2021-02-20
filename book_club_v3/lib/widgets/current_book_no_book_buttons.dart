import 'package:flutter/material.dart';
import '../screens/booklist_screen.dart';

class CurrentBookNoBookButtons extends StatefulWidget {
  Function alertAllMembers;
  String clubId;

  CurrentBookNoBookButtons(this.alertAllMembers, this.clubId);

  @override
  _CurrentBookNoBookButtonsState createState() =>
      _CurrentBookNoBookButtonsState();
}

bool votePressed = false;

class _CurrentBookNoBookButtonsState extends State<CurrentBookNoBookButtons> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: votePressed == true
          ? Theme.of(context).buttonColor
          : Theme.of(context).cardColor,
      duration: Duration(milliseconds: 300),
      child: FlatButton(
        color: Colors.transparent,
        // visualDensity: ,
        child: Text(
          (votePressed) ? 'Votes requested!' : 'Ask members to vote',
          style: Theme.of(context).textTheme.caption,
        ),
        onPressed: () {
          if (votePressed == false)
            setState(() {
              votePressed = !votePressed;
            });
          widget.alertAllMembers(widget.clubId);
        },
      ),
    );
  }
}
