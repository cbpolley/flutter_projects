import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingDateWidget extends StatelessWidget {
  final clubId;
  final isAdmin;
  MeetingDateWidget(this.clubId, this.isAdmin);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0))),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('clubs')
                    .doc(clubId)
                    .collection('meetingDates')
                    .where('date', isGreaterThanOrEqualTo: DateTime.now())
                    .orderBy(
                      'date',
                      descending: false,
                    )
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Container(height: 0, width: 0)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Next Meeting',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Container(
                                margin: (isAdmin)
                                    ? EdgeInsets.only(left: 8.0, right: 60)
                                    : EdgeInsets.only(left: 8.0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    color: (snapshot.data.docs.length == 0)
                                        ? Colors.grey
                                        : Theme.of(context).accentColor),
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 8.0, vertical: 4.0),
                                child: (snapshot.connectionState ==
                                        ConnectionState.waiting)
                                    ? LinearProgressIndicator()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: (snapshot.data.docs.length ==
                                                  0)
                                              ? Text(
                                                  'No future meeting',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                )
                                              : Text(
                                                  DateFormat.MMMEd().format(
                                                      snapshot.data.docs.single
                                                          .data()['date']
                                                          .toDate()),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                        )),
                              ),
                            ),
                          ],
                        );
                }),
          ),
          if (isAdmin)
            Positioned(
              right: 0.0,
              top: 0.0,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  bottomRight: const Radius.circular(8.0),
                ),
                child: Container(
                  height: 40,
                  width: 60,
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColor,
                    highlightColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                    onTap: () async {
                      var nextDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100));
                      if (nextDate != null)
                        await FirebaseFirestore.instance
                            .collection('clubs')
                            .doc(clubId)
                            .collection('meetingDates')
                            .add({'date': nextDate});
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
