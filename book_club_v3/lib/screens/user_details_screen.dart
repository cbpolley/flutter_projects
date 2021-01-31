import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/user_details.dart';
import '../providers/member.dart';

class UserDetailsScreen extends StatelessWidget {
  static const routeName = '/user-details-screen';

  // var _isInit = true;
  // var _isLoading = false;
  var _obtainedData;

  TextEditingController _userIdController;
  TextEditingController _memberNameController;

  Future<Member> getUserDetails(context, userId) async {
    // if (_isInit) {
    _obtainedData = Provider.of<UserDetails>(context, listen: false)
        .fetchAndSetUserDetails(userId);
    // _isInit = false;
    return _obtainedData;
    // }
  }

  void _submitUserDetails(context, userData) {
    Provider.of<UserDetails>(context, listen: false)
        .updateUserDetails(userData);
  }

  @override
  Widget build(BuildContext context) {
    var userId = ModalRoute.of(context).settings.arguments;

    // final userAuthData = Provider.of<Auth>(context);

    // final userData = getUserDetails(context, userArguments);
    // _userIdController(text: 'Hey');

    return Scaffold(
        appBar: AppBar(
          title: Text('Your profile'),
        ),
        body: Container(
          child: FutureBuilder(
              future: getUserDetails(context, userId),
              builder: (BuildContext ctx, snapshot) => snapshot
                          .connectionState ==
                      ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        snapshot.data.memberName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        snapshot.data.id,
                                        // 'userData.userDetails.id',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Joined on ...',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        '6 clubs',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            (snapshot.data.imageUrl == null)
                                                ? SvgPicture.asset(
                                                    'assets/images/bookClub_bc.svg',
                                                    semanticsLabel:
                                                        'Bookclub Logo',
                                                  )
                                                : NetworkImage(
                                                    snapshot.data.imageUrl),
                                        radius: 45,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0.0,
                                      right: 0.0,
                                      child: CircleAvatar(
                                        radius: 15.0,
                                        child: Icon(Icons.edit),
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            enabled: false,
                            controller: _userIdController =
                                TextEditingController(text: snapshot.data.id),
                            decoration: InputDecoration(
                                labelText: 'User Id',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: _memberNameController =
                                TextEditingController(
                                    text: snapshot.data.memberName),
                            decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            final userDataPass = Member(
                              id: _userIdController.text.toString(),
                              memberName: _memberNameController.text.toString(),
                              imageUrl:
                                  'https://image.shutterstock.com/image-photo/image-150nw-1342320983.jpg',
                            );
                            _submitUserDetails(context, userDataPass);
                          },
                          child: Text('Submit'),
                        )
                      ],
                    )),
        ));
  }
}
