import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  getJoinedDate(userSnapshot) {
    return DateFormat.yMMMd().format(userSnapshot.data['joinedOn'].toDate());
  }

  getJoinedClubs(userSnapshot) {
    return userSnapshot.data['clubs'];
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    void _submitUserDetails(newName) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser.uid)
          .update({'userName': newName});
      auth.currentUser.updateProfile(displayName: newName);
    }

    // var userId = ModalRoute.of(context).settings.arguments;

    // final userAuthData = Provider.of<Auth>(context);

    // final userData = getUserDetails(context, userArguments);
    // _userIdController(text: 'Hey');

    return Scaffold(
      appBar: AppBar(
        title: Text('Your profile'),
      ),
      body: Container(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser.uid)
                .snapshots(),
            builder: (BuildContext ctx, userSnapshot) {
              return userSnapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Expanded(
                          flex: 10,
                          child: Container(
                            // height: 400,
                            child: ListView(
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: Theme.of(context).cardColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                userSnapshot.data['userName'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),

                                            Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                "Joined on ${getJoinedDate(userSnapshot)}",
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.all(8.0),
                                            //   child: TextField(
                                            //     style: TextStyle(color: Colors.black),
                                            //     enabled: false,
                                            //     controller: _userIdController =
                                            //         TextEditingController(
                                            //       text: DateFormat.yMMMMd().format(
                                            //         DateTime.fromMicrosecondsSinceEpoch(
                                            //             userSnapshot.data['joinedOn']
                                            //                 .microsecondsSinceEpoch),
                                            //       ),
                                            //     ),
                                            //     decoration: InputDecoration(
                                            //         labelText: 'Joined on',
                                            //         labelStyle: TextStyle(
                                            //             fontWeight: FontWeight.bold)),
                                            //   ),
                                            // ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                "Member of ${getJoinedClubs(userSnapshot)} clubs",
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
                                              child:
                                                  // CircleAvatar(
                                                  //   backgroundImage:
                                                  (userSnapshot.data[
                                                              'imageUrl'] ==
                                                          'default')
                                                      ? SvgPicture.asset(
                                                          'assets/images/bookClub_bc.svg',
                                                          semanticsLabel:
                                                              'Bookclub Logo',
                                                        )
                                                      : NetworkImage(
                                                          userSnapshot.data[
                                                              'imageUrl']),
                                              // radius: 45,
                                            ),
                                            // ),
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
                                        TextEditingController(
                                            text: userSnapshot.data.id),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[300],
                                        filled: true,
                                        labelText: 'User Id',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    enabled: false,
                                    controller: _memberNameController =
                                        TextEditingController(
                                            text: userSnapshot.data['email']),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[300],
                                        filled: true,
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    controller: _memberNameController =
                                        TextEditingController(
                                            text:
                                                userSnapshot.data['userName']),
                                    decoration: InputDecoration(
                                        labelText: 'Username',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 200,
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                final userDataPass = Member(
                                  id: _userIdController.text.toString(),
                                  memberName:
                                      _memberNameController.text.toString(),
                                  imageUrl:
                                      'https://image.shutterstock.com/image-photo/image-150nw-1342320983.jpg',
                                );
                                _submitUserDetails(
                                    _memberNameController.text.toString());
                              },
                              child: Text('Submit'),
                            ),
                          ),
                        )
                      ],
                    );
            }),
      ),
    );
  }
}
