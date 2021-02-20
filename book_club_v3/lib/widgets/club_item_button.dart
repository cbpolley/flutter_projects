import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../screens/club_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class ClubItemButton extends StatefulWidget {
  bool confirmedMember;
  final String id;
  final String clubName;
  final String currentUser;
  final String adminId;

  ClubItemButton(
      {this.confirmedMember,
      this.clubName,
      this.currentUser,
      this.id,
      this.adminId});

  @override
  _ClubItemButtonState createState() => _ClubItemButtonState();
}

final userInstance = FirebaseFirestore.instance;

class _ClubItemButtonState extends State<ClubItemButton> {
  void _joinClub() async {
    await userInstance
        .collection('clubs')
        .doc(widget.id)
        .collection('members')
        .doc(widget.currentUser)
        .update({'confirmedMember': true});

    await userInstance
        .collection('users')
        .doc(widget.currentUser)
        .collection('clubs')
        .doc(widget.id)
        .update({'confirmedMember': true});
  }

  void _leaveClub() async {
    await userInstance
        .collection('clubs')
        .doc(widget.id)
        .collection('members')
        .doc(widget.currentUser)
        .update({'confirmedMember': false});

    await userInstance
        .collection('users')
        .doc(widget.currentUser)
        .collection('clubs')
        .doc(widget.id)
        .update({'confirmedMember': false});

    await userInstance
        .collection('users')
        .doc(widget.currentUser)
        .get()
        .then((userSS) async {
      var clubNumber = await userSS.data()['clubs'];
      clubNumber = clubNumber - 1;
      await userInstance
          .collection('users')
          .doc(widget.currentUser)
          .update({'clubs': clubNumber});
    });
  }

  void _removeClub() async {
    var deleteOnlyUser;

    await userInstance
        .collection('users')
        .doc(widget.currentUser)
        .collection('clubs')
        .doc(widget.id)
        .delete();

    await userInstance
        .collection('clubs')
        .doc(widget.id)
        .collection('members')
        .get()
        .then((doc) {
      deleteOnlyUser = (doc.docs.length > 1) ? true : false;
    });

    if (deleteOnlyUser == true) {
      userInstance
          .collection('clubs')
          .doc(widget.id)
          .collection('members')
          .doc(widget.currentUser)
          .delete();
    } else {
      userInstance.collection('clubs').doc(widget.id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        // color: Theme.of(context).cardColor,
        child: Column(
          children: [
            Expanded(
              child: (widget.confirmedMember)
                  ? FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: Theme.of(context).accentColor,
                      splashColor: Colors.white,
                      highlightColor: Colors.white,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.open_in_browser,
                          size: 30,
                          color: const Color(0xfffff6f4),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClubScreen(
                                clubId: widget.id,
                                clubName: widget.clubName,
                                adminId: widget.adminId,
                              ),
                            ));
                      },
                    )
                  : FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: Theme.of(context).accentColor,
                      child: Text('Join',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        setState(() {
                          widget.confirmedMember = true;
                        });
                        _joinClub();
                      },
                    ),
            ),
            SizedBox(
              height: 6,
            ),
            Expanded(
              child: (widget.confirmedMember)
                  ? FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: Theme.of(context).buttonColor,
                      child: Text('Leave',
                          style: Theme.of(context).textTheme.caption),
                      onPressed: () {
                        setState(() {
                          widget.confirmedMember = false;
                        });
                        _leaveClub();
                      },
                    )
                  : FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: Theme.of(context).buttonColor,
                      child: Text('Remove',
                          style: Theme.of(context).textTheme.caption),
                      onPressed: () {
                        _removeClub();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
