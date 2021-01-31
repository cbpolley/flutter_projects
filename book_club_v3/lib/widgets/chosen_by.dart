import 'package:flutter/material.dart';

class ChosenBy extends StatelessWidget {
  final String chosenBy;

  ChosenBy(this.chosenBy);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            child: Text(
              "$chosenBy's choice",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        // Expanded(
        //   flex: 3,
        //   child: SizedBox(
        //     height: 30,
        //     child: RaisedButton(
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.only(
        //           bottomLeft: Radius.circular(10),
        //           bottomRight: Radius.circular(10),
        //         ),
        //       ),
        //       color: Colors.amber,
        //       child: Text(
        //         'Change book',
        //         textAlign: TextAlign.center,
        //       ),
        //       onPressed: () {
        //         Navigator.of(context).pushNamed(BookListScreen.routeName);
        //       },
        //     ),
        //   ),
        // ),
        // Expanded(
        //   flex: 3,
        //   child: FlatButton(
        //     color: Theme.of(context).accentColor,
        //     child: Text(
        //       'Change book',
        //       textAlign: TextAlign.center,
        //     ),
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(BookScreen.routeName);
        //     },
        //   ),
        // )
      ],
    );
  }
}
