import 'package:book_club_v3/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MemberItem extends StatelessWidget {
  final String id;
  final String memberName;
  final String imageUrl;
  final Map currentBook;
  final bool isAdmin;
  final bool hasCrown;

  MemberItem({
    this.id,
    this.memberName,
    this.imageUrl,
    this.currentBook,
    this.isAdmin,
    this.hasCrown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: Theme.of(context).cardTheme.color,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Container(
              height: 15,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  (memberName == null) ? id : memberName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 60,
                  child: ProgressBar(
                    (isAdmin == null) ? false : isAdmin,
                    (currentBook == null || currentBook['progress'] == null)
                        ? 0.0
                        : currentBook['progress'],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CircleAvatar(
                  // minRadius: 1,
                  maxRadius: 30,

                  child: (imageUrl == "default" ||
                          imageUrl == "" ||
                          imageUrl == null)
                      ? SvgPicture.asset(
                          'assets/images/bookClub_bc.svg',
                        )
                      : NetworkImage(imageUrl),
                ),
              ),
              if (hasCrown != null)
                if (hasCrown == true)
                  Positioned(
                    top: 0.0,
                    child: Image.asset(
                      'assets/images/crown.png',
                      height: 20,
                    ),
                  ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              child: (currentBook == null || currentBook["progress"] == null)
                  ? Text("0%")
                  : (Text(
                      "${currentBook['progress'].toStringAsFixed(0)}%",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
            ),
          ),
        ],
      ),
    );
  }
}
