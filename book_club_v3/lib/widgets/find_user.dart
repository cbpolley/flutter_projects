import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FindUser extends StatefulWidget {
  final String clubId;
  final addMember;
  FindUser(this.clubId, this.addMember);
  @override
  _FindUserState createState() => _FindUserState();
}

final _memberNameController = TextEditingController();

void dispose() {
  _memberNameController.dispose();
}

var _showUsersList = false;
var usersList = {};

class _FindUserState extends State<FindUser> {
  Future<void> _findUser(userName) {
    FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: userName)
        .get()
        .then((doc) {
      if (doc.docs.isNotEmpty) {
        usersList[doc.docs.single.id] = userName;
      }
      setState(() {
        _showUsersList = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: 500,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search for a user',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              TextFormField(
                controller: _memberNameController,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                    labelText: 'User Name:',
                    labelStyle: Theme.of(context).textTheme.bodyText1),
              ),
              RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  if (_memberNameController.text.isNotEmpty)
                    _findUser(_memberNameController.text.toString().trim());
                },
              ),
              if (_showUsersList)
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey[300])),
                  height: 200,
                  child: (usersList.length > 0)
                      ? ListView.builder(
                          itemCount: usersList.length,
                          itemBuilder: (context, index) {
                            String key = usersList.keys.elementAt(index);
                            return Column(
                              children: [
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.all(8.0),
                                  width: double.infinity,
                                  color: Theme.of(context).accentColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        usersList[key],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            FocusScope.of(context).unfocus();
                                            usersList.clear();
                                          });
                                          widget.addMember(
                                              context, widget.clubId, key);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 2,
                                )
                              ],
                            );
                          },
                        )
                      : Container(height: 0.0, width: double.infinity),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
