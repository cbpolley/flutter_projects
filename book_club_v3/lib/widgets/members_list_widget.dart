import '../widgets/member_item.dart';
import 'package:flutter/material.dart';
import '../screens/add_member_screen.dart';

class MembersListWidget extends StatefulWidget {
  final List memberList;
  Function updateUserProgress;
  final String clubId;
  final String currentBookId;

  MembersListWidget(
    this.memberList,
    this.updateUserProgress,
    this.clubId,
    this.currentBookId,
  );

  @override
  _MembersListWidgetState createState() => _MembersListWidgetState();
}

class _MembersListWidgetState extends State<MembersListWidget> {
  var _hideBar = true;
  double _progressAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Member List',
                    style: Theme.of(context).textTheme.headline5),
                Text('${widget.memberList.length} Members',
                    style: Theme.of(context).textTheme.headline5),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 5,
                color: Colors.grey[300],
              ),
            ),
            color: Theme.of(context).cardColor,
          ),
          height: 135,
          child: (widget.memberList.length == 0)
              ? Text(
                  'no members yet',
                  style: TextStyle(color: Colors.black),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.memberList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MemberItem(
                      id: widget.memberList[index].id,
                      memberName: widget.memberList[index].memberName,
                      currentBook: widget.memberList[index].currentBook,
                      imageUrl: widget.memberList[index].imageUrl,
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 40,
                    width: 150,
                    child: (_hideBar)
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
                                _hideBar = false;
                              });
                            },
                          )
                        : Slider(
                            value: _progressAmount,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: _progressAmount.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _progressAmount = value;
                              });
                            },
                            onChangeEnd: (double value) {
                              setState(() {
                                _hideBar = true;
                                widget.updateUserProgress(_progressAmount);
                              });
                            },
                          ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 150,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text('add member'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AddMemberScreen.routeName,
                        arguments: ScreenArguments(
                            widget.clubId, widget.currentBookId),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
