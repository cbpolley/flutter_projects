import 'package:flutter/material.dart';

class AuthCard extends StatefulWidget {
  // const AuthCard({
  //   Key key,
  // }) : super(key: key);
  AuthCard(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    // File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  // File _userImageFile;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    // if (_userImageFile == null && !_isLogin) {
    //   Scaffold.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please pick an image.'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   return;
    // }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        // _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  // void _pickedImage(File image) {
  //   _userImageFile = image;
  // }
//     with SingleTickerProviderStateMixin {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   AuthMode _authMode = AuthMode.Login;
//   Map<String, String> _authData = {
//     'email': '',
//     'password': '',
//   };
  // var _isLoading = false;
  // final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    // _slideAnimation = Tween<Offset>(
    //   begin: Offset(0, 0),
    //   end: Offset(0, 0),
    // ).animate(
    //   CurvedAnimation(
    //     parent: _controller,
    //     curve: Curves.linear,
    //   ),
    // );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text('An Error Occurred!'),
  //       content: Text(message),
  //       actions: [
  //         FlatButton(
  //           onPressed: () {
  //             Navigator.of(ctx).pop();
  //           },
  //           child: Text('Okay'),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState.validate()) {
  //     // Invalid!
  //     return;
  //   }
  //   _formKey.currentState.save();
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     if (_authMode == AuthMode.Login) {
  //       // Log user in
  //       await Provider.of<Auth>(
  //         context,
  //         listen: false,
  //       ).login(
  //         _authData['email'],
  //         _authData['password'],
  //       );
  //     } else {
  //       // Sign user up
  //       await Provider.of<Auth>(
  //         context,
  //         listen: false,
  //       ).signup(
  //         _authData['email'],
  //         _authData['password'],
  //       );
  //     }
  //   } on HttpException catch (error) {
  //     var errorMessage = 'Authentication failed.';
  //     if (error.toString().contains('EMAIL_EXISTS')) {
  //       errorMessage = 'This email address is already in use.';
  //     } else if (error.toString().contains('INVALID_EMAIL')) {
  //       errorMessage = 'This is not a valid email address.';
  //     } else if (error.toString().contains('WEAK_PASSWORD')) {
  //       errorMessage = 'The password needs to be more complex.';
  //     } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
  //       errorMessage = 'Could not find a user with that password.';
  //     } else if (error.toString().contains('INVALID_PASSWORD')) {
  //       errorMessage = 'The password is invalid.';
  //     }
  //     _showErrorDialog(errorMessage);
  //   } catch (error) {
  //     const errorMessage =
  //         'Could not authenticate you, please try again later.';
  //     _showErrorDialog(errorMessage);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // void _switchAuthMode() {
  //   if (_authMode == AuthMode.Login) {
  //     setState(() {
  //       _authMode = AuthMode.Signup;
  //     });
  //     _controller.forward();
  //   } else {
  //     setState(() {
  //       _authMode = AuthMode.Login;
  //     });
  //     _controller.reverse();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 16.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _isLogin == false ? 320 : 260,
        constraints: BoxConstraints(minHeight: _isLogin == false ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 16),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onSaved: (value) {
                    _userEmail = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 16),
                  ),
                  obscureText: true,
                  // controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _isLogin == false ? 60 : 0,
                    maxHeight: _isLogin == false ? 120 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _isLogin == false,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 16),
                        ),
                        obscureText: true,
                        validator: _isLogin == false
                            ? (value) {
                                if (value != _userPassword) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (widget.isLoading)
                  CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                else
                  RaisedButton(
                    child: Text(
                      _isLogin == false ? 'LOGIN' : 'SIGN UP',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 16),
                    ),
                    onPressed: _trySubmit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                    '${_isLogin == false ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 16),
                  ),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).textTheme.bodyText2.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
