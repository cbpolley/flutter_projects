import 'package:book_club_v3/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

import '../providers/club_members.dart';
import '../widgets/progress_bar.dart';

class UpdateProgressScreen extends StatefulWidget {
  static const routeName = '/update-progress-screen';

  @override
  _UpdateProgressScreenState createState() => _UpdateProgressScreenState();
}

class _UpdateProgressScreenState extends State<UpdateProgressScreen> {
  final _pageAmountController = TextEditingController();
  final _bookPageCountController = TextEditingController();
  final _percentageAmountController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  int _currentPage;
  int _bookTotalPages;
  var _progressPercentage;
  double _currentSliderValue = 0.0;
  var _isInit;
  var _isPressed = true;

  @override
  void initState() {
    _isInit = true;
    super.initState();
  }

  var validColor = Colors.green;

  void dispose() {
    _pageAmountController.dispose();
    _bookPageCountController.dispose();
    _percentageAmountController.dispose();
    super.dispose();
  }

  void updatePercentage(percentageAmount) {
    setState(() {
      _progressPercentage = percentageAmount;
      _currentSliderValue = percentageAmount;
    });
    if (_currentPage != null && _bookTotalPages != null) {
      if (_currentPage <= _bookTotalPages) {
        validColor = Colors.green;
        setState(() {
          _currentPage = (_bookTotalPages * _progressPercentage ~/ 100);
        });
      } else {
        validColor = Colors.red;
      }
    }
  }

  void updatePercentageFromBooks() {
    if (_currentPage != null && _bookTotalPages != null) {
      if (_currentPage <= _bookTotalPages) {
        validColor = Colors.green;
        setState(() {
          _progressPercentage = _currentPage / _bookTotalPages * 100;
        });
      } else {
        validColor = Colors.red;
      }
    }
  }

  void initialiseValues(clubId) {
    if (_isInit) {
      if (clubId[1] != null) {
        setState(() {
          _progressPercentage = clubId[1];
          _currentSliderValue = _progressPercentage;
        });
      }

      if (clubId[2] != null) {
        setState(() {
          _bookTotalPages = clubId[2];
        });
      }

      if (clubId[3] != null) {
        setState(() {
          _currentPage = clubId[3];
        });
      }
      _isInit = false;
    }
  }

  void submitProgressForm(clubId) {
    FocusScope.of(context).unfocus();
    var returnPercentage;
    var calcPercentage;

    if (_currentPage != '' && _bookTotalPages == '') {
      calcPercentage = (_currentPage / _bookTotalPages);
      // returnPercentage = double.parse(_progressPercentage);
      // return;
    }
    // if (_bookTotalPages == '') {
    //   // Please enter your current page number

    // }
    if (_progressPercentage != '') {
      calcPercentage = _progressPercentage;
      // Please enter the total page count for the book
    }

    if (calcPercentage != '') {
      _progressPercentage = calcPercentage;
      ClubMembers().updateUserProgress(
          clubId[0], _progressPercentage, _bookTotalPages, _currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clubId = ModalRoute.of(context).settings.arguments as List;

    initialiseValues(clubId);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Your progress'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Expanded(
              // child: ListView(
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _pageAmountController,
                                style: Theme.of(context).textTheme.headline4,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'What page number are you at?',
                                  labelStyle:
                                      Theme.of(context).textTheme.headline4,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _currentPage = int.parse(value);
                                    updatePercentageFromBooks();
                                  });
                                },
                              ),
                            ),
                            VerticalDivider(
                              thickness: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: validColor,
                              ),
                              height: 80,
                              width: 80,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  (_currentPage == null)
                                      ? '0'
                                      : _currentPage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _bookPageCountController,
                                keyboardType: TextInputType.number,
                                style: Theme.of(context).textTheme.headline4,
                                decoration: InputDecoration(
                                  labelText: 'The book has this many pages:',
                                  labelStyle:
                                      Theme.of(context).textTheme.headline4,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _bookTotalPages = int.parse(value);
                                    updatePercentageFromBooks();
                                  });
                                },
                              ),
                            ),
                            VerticalDivider(
                              thickness: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.green,
                              ),
                              height: 80,
                              width: 80,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  (_bookTotalPages == null)
                                      ? '0'
                                      : _bookTotalPages.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Your progress in the book is:',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            VerticalDivider(
                              thickness: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.green,
                              ),
                              height: 80,
                              width: 80,
                              child: Align(
                                alignment: Alignment.center,
                                child: Stack(children: [
                                  ProgressBar(false, _progressPercentage),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      (_progressPercentage == null)
                                          ? '0%'
                                          : "${_progressPercentage.toStringAsFixed(0)}%",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                      Slider(
                        value: _currentSliderValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                        onChangeEnd: (double value) {
                          setState(() {
                            // _isInit = true;
                            _isPressed = true;
                            updatePercentage(value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // ),
              // Spacer(),
              Container(
                // width: 200,
                height: 80,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // color:
                    child: Text(
                      'Update your progress',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    splashColor: Colors.amber,
                    onPressed: () {
                      submitProgressForm(clubId);
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
