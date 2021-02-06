import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/club_members.dart';
import '../providers/member.dart';

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}

class AddMemberScreen extends StatelessWidget {
  static const routeName = '/add-member-screen';

  final _memberNameController = TextEditingController();
  final _memberImageUrlController = TextEditingController();

  void dispose() {
    _memberNameController.dispose();
    _memberImageUrlController.dispose();
  }

  Future<void> _addMemberToClub(context, Map memberMap, String clubId) async {
    Member convertedMember = new Member.fromJson(memberMap);
    // await Provider.of<ClubMembers>(context, listen: false)
    //     .addMember(context, clubId, convertedMember);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments clubId = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: _memberNameController,
                    decoration: InputDecoration(
                      labelText: 'Member Name:',
                    ),
                  ),
                  TextField(
                    controller: _memberImageUrlController,
                    decoration: InputDecoration(
                      labelText: 'ImageUrl:',
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.green,
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Text('Submit'),
                          splashColor: Colors.amber,
                          onTap: () {
                            Map memberMap = {
                              "memberName": _memberNameController.text,
                              "imageUrl": _memberImageUrlController.text,
                              "isAdmin": false,
                              "hasCrown": false,
                              "currentBook": {
                                clubId.title: 0,
                              },
                            };
                            _addMemberToClub(context, memberMap, clubId.title);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
