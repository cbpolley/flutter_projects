import 'package:flutter/material.dart';

import '../providers/book_archive.dart';

class RateBookWidget extends StatefulWidget {
  Function updateBookRating;

  RateBookWidget(this.updateBookRating);

  @override
  _RateBookWidgetState createState() => _RateBookWidgetState();
}

class _RateBookWidgetState extends State<RateBookWidget> {
  double _currentSliderValue = 20;

  var _isPressed = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (_isPressed)
          ? RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Theme.of(context).accentColor,
              child: Text(
                'Rate current book',
                textAlign: TextAlign.right,
              ),
              onPressed: () {
                setState(() {
                  _isPressed = false;
                });
              })
          : Slider(
              value: _currentSliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
              onChangeEnd: (double value) {
                setState(() {
                  _isPressed = true;
                  widget.updateBookRating(_currentSliderValue);
                });
              },
            ),
    );
  }
}
