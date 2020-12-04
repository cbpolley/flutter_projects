import 'package:flutter/material.dart';

class TextControl extends StatelessWidget {
  final Function _progressStory;
  final Function resetStory;

  TextControl(this._progressStory, this.resetStory);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: <Widget>[
      RaisedButton(
        color: Colors.orange,
        textColor: Colors.white,
        child: Text('Read on...'),
        onPressed: _progressStory,
      ),
      SizedBox(
        width: double.infinity,
        height: 50,
        child: RaisedButton(
          child: Text('Start again from the beginning.'),
          textColor: Colors.black,
          color: Colors.white,
          onPressed: resetStory,
        ),
      ),
    ]));
  }
}
