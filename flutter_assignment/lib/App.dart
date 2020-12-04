// 1) Create a new Flutter App (in this project) and output an AppBar and some text
// below it
// 2) Add a button which changes the text (to any other text of your choice)
// 3) Split the app into three widgets: App, TextControl & Text

import 'package:flutter/material.dart';

import './Text.dart';
import './TextControl.dart';

void main() => runApp(PeterApp());

class PeterApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PeterAppState();
  }
}

class _PeterAppState extends State<PeterApp> {
  var storyTextIndex = 0;

  void _resetStory() {
    setState(() {
      storyTextIndex = 0;
    });
  }

  void _progressStory() {
    setState(() {
      storyTextIndex < 4 ? storyTextIndex++ : storyTextIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 222, 217, 181),
        appBar: AppBar(
          title: Text('Peter and the wolf'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LibraryText(storyTextIndex),
              TextControl(_progressStory, _resetStory),
            ],
          ),
        ),
      ),
    );
  }
}
