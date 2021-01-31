import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: SvgPicture.asset(
            'assets/images/bookClub_bc.svg',
            semanticsLabel: 'Bookclub Logo',
            height: 200,
          ),
        ),
      ),
    );
  }
}
