import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChosenBy extends StatelessWidget {
  final chosenBy;

  ChosenBy(this.chosenBy);

  var name;

  @override
  Widget build(BuildContext context) {
    // getChosenByUserName(chosenBy) async {
    //   var instance = FirebaseFirestore.instance;
    //   await instance.collection('users').doc(chosenBy).get().then((item) {
    //     returnUserName = (item.data()['userName']);
    //     print(returnUserName);
    //   });
    //   if (returnUserName == null) {
    //     returnUserName = 'Anonymous';
    //   }
    //   return returnUserName.toString();
    // }

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(chosenBy)
            .snapshots(),
        builder: (context, userSnapshot) {
          userSnapshot.connectionState == ConnectionState.waiting
              ? name = 'Bobs'
              : name = userSnapshot.data.get(FieldPath(['userName']));
          return Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  child: Text(
                    "$name\'s choice",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
