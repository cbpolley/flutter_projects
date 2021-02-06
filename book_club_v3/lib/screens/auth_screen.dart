import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';
import '../widgets/auth/auth_card.dart';
import '../providers/auth.dart';
// enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  var errorMessage;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _submitAuthForm(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (authResult.user.emailVerified == false) {
          errorMessage = 'Your email has not yet been verified.';
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        try {
          await authResult.user.sendEmailVerification();
          getSnackBar(
              'Please confirm your email address using the link that has been sent to you.');
        } catch (error) {
          errorMessage =
              'An error occurred while sending a verification email. Please check your details and try again.';
          getSnackBar(errorMessage);
        }
        try {
          await authResult.user.updateProfile(displayName: email);
        } catch (error) {
          errorMessage =
              'An error occurred while setting up your details. Please check your details and try again.';
          getSnackBar(errorMessage);
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set(
          {
            'userName': email,
            'email': email,
            'joinedOn': DateTime.now(),
            'imageUrl': 'default',
            'clubs': 0,
          },
        );
        setState(() {
          _isLoading = false;
        });
      }
    } on PlatformException catch (err) {
      print(err.code);
      errorMessage = 'An error occurred, please check your credentials.';

      if (err.message != null) {
        errorMessage = err.message;
      }

      getSnackBar(errorMessage);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      if (err.message != null) {
        errorMessage = err.message;

        getSnackBar(errorMessage);
      }
      setState(() {
        _isLoading = false;
      });
    }
    Auth().isAuth = _auth.currentUser.uid == null ? false : true;
  }

  getSnackBar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      backgroundColor: Theme.of(context).accentColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      child: SvgPicture.asset(
                        'assets/images/bookClub_bc.svg',
                        semanticsLabel: 'Bookclub Logo',
                        height: 200,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(_submitAuthForm, _isLoading),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
