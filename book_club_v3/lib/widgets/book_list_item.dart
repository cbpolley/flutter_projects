import 'package:book_club_v3/widgets/star_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookListItem extends StatelessWidget {
  final imageUrl;
  final title;
  final bookRating;
  final completedDate;

  BookListItem(
      {this.title, this.bookRating, this.completedDate, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        // height: 50,
        color: Theme.of(context).cardTheme.color,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              // height: 25,
              child: (completedDate == null)
                  ? Text(
                      "",
                    )
                  : (completedDate == "Current")
                      ? Text(
                          "Current",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      : Text(
                          DateFormat('dd-MM-yy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  completedDate.millisecondsSinceEpoch)),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: imageUrl.toString().startsWith('http')
                  ? Image(
                      image: NetworkImage(imageUrl),
                    )
                  : SvgPicture.asset(
                      'assets/images/bookClub_noTxt.svg',
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(height: 12, child: StarDisplayWidget(bookRating)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              title.toString(),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),

          // Text(.toString())m
        ]));
  }
}
