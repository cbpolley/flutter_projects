import 'package:flutter/material.dart';

class LibraryText extends StatelessWidget {
  final int _storyIndex;

  LibraryText(this._storyIndex);

  final _storyText = const [
    'Early one morning, Peter opened the gate andwalked out into the big green meadow.',
    'On a branch of a big tree sat a little bird, Peter\'s friend. "All is quiet" chirped the bird happily.',
    'Just then a duck came waddling round. She was glad that Peter had not closed the gate and decided to take a nice swim in the deep pond in the meadow.',
    'Seeing the duck, the little bird flew down upon the grass, settled next to her and shrugged his shoulders. "What kind of bird are you if you can\'t fly?" said he. To this the duck replied "What kind of bird are you if you can\'t swim?" and dived into the pond.',
    'They argued and argued, the duck swimming in the pond and the little bird hopping along the shore.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 8, style: BorderStyle.solid),
        ),
      ),
      child: Text(
        _storyText[_storyIndex],
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }
}
