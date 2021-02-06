import 'package:flutter/material.dart';

import '../providers/book_archive.dart';

class UpdateProgressWidget extends StatefulWidget {
  Function updateUserProgress;

  UpdateProgressWidget(this.updateUserProgress);

  @override
  _UpdateProgressWidgetState createState() => _UpdateProgressWidgetState();
}

class _UpdateProgressWidgetState extends State<UpdateProgressWidget> {
  double _currentSliderValue = 0;

  var _isPressed = true;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 40,
          width: 150,
          child: (_isPressed)
              ? RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.amber,
                  child: Text(
                    'update your progress',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPressed = false;
                    });
                  },
                )
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
                    setState(
                      () {
                        _isPressed = true;
                        widget.updateUserProgress(_currentSliderValue);
                      },
                    );
                  }),
        ));
  }
}
